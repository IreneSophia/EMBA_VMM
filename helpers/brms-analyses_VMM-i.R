ls.packages = c(
                "brms",             # Bayesian lmms
                "tidyverse",        # tibble stuff
                "SBC"               # plots for checking computational faithfulness
)

lapply(ls.packages, library, character.only=TRUE)

# set cores
options(mc.cores = parallel::detectCores())

# set file paths
setwd('/home/emba/Documents/EMBA/EMBA_VMM_scripts')

# settings for the SBC package
use_cmdstanr = getOption("SBC.vignettes_cmdstanr", TRUE) # Set to false to use rst
options(brms.backend = "cmdstanr")
cache_dir = "./_brms_SBC_cache"
if(!dir.exists(cache_dir)) {
  dir.create(cache_dir)
}

# Using parallel processing
library(future)

# number of simulations
nsim = 250

# set number of iterations and warmup for models
iter = 4500
warm = 1500

# get and prep data
load("VMM_data.RData")
df.rtc = df.tsk %>% 
  filter(sdt == "hit" & !is.na(rtc)) %>% 
  ungroup() %>%
  mutate_if(is.character, as.factor)
contrasts(df.rtc$diagnosis)  = contr.sum(3)
contrasts(df.rtc$diagnosis)

# set the code
code = "VMM_rtc_full_sub"

# full model formula
f.rtc = brms::bf(rtc ~ diagnosis + (1 | subID) )

# set informed priors based on previous results
priors = c(
  # general priors based on SBV
  prior(normal(6,     0.3),  class = Intercept),
  prior(normal(0,     0.5),  class = sigma),
  prior(normal(0.1,   0.1),  class = sd),
  #prior(lkj(2),              class = cor),
  # ADHD subjects being slower based on Pievsky & McGrath (2018)
  prior(normal(0.025, 0.04), class = b, coef = diagnosis1),
  # ASD subjects being slower based on Morrison et al. (2018)
  prior(normal(0.025, 0.04), class = b, coef = diagnosis2),
  # shift
  prior(normal(100,   50),   class = ndt)
)

# STUFF

# set the seed
set.seed(2468)
# perform the SBC
gen = SBC_generator_brms(f.rtc, data = df.rtc, prior = priors,
                         family = shifted_lognormal,
                         thin = 50, warmup = 20000, refresh = 2000)
bck = SBC_backend_brms_from_generator(gen, chains = 4, thin = 1,
                                      init = 0.1, warmup = warm, iter = iter)
if (!file.exists(file.path(cache_dir, paste0("dat_", code, ".rds")))){
  dat = generate_datasets(gen, nsim) 
  saveRDS(dat, file = file.path(cache_dir, paste0("dat_", code, ".rds")))
} else {
  dat = readRDS(file = file.path(cache_dir, paste0("dat_", code, ".rds")))
}
ls.files = list.files(path = cache_dir, pattern = sprintf("res_%s_.*", code))
if (is_empty(ls.files)) {
  i = 1
} else {
  i = max(as.numeric(gsub(".*([0-9]+).*", "\\1", ls.files))) + 1
}
set.seed(2468+i)
m = 125

write(sprintf('%s: %s %d', now(), code, i), sprintf("%slog_VMM-rtc.txt", "~/Insync/10planki@gmail.com/Google Drive/NEVIA/logfiles/"), append = TRUE)

plan(multisession)
print("start res")
res = compute_SBC(SBC_datasets(dat$variables[((i-1)*m + 1):(i*m),], 
                               dat$generated[((i-1)*m + 1):(i*m)]), 
                  bck,
                  cache_mode     = "results", 
                  cache_location = file.path(cache_dir, sprintf("res_%s_%02d", code, i)))

write(sprintf('%s: DONE %d', now(), i), sprintf("%slog_VMM-rtc.txt", "~/Insync/10planki@gmail.com/Google Drive/NEVIA/logfiles/"), append = TRUE)
