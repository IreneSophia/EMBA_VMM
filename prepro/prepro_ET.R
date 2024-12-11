# Load packages 
library(tidyverse)

# Clear global environment
rm(list=ls())
dt.path = "/home/emba/Documents/EMBA/BVET"
df.inc  = read_delim("/home/emba/Documents/EMBA/VMM_analysis/FSL_dur/all_use-new", show_col_types = F) %>%
  filter(diagnosis != "pilot") %>% select(subID, diagnosis)

# load raw data
# columns of Interest: internalStudyMemberID, name2, code, value, section, (valueIndex), numericValue
df = list.files(path = dt.path, pattern = "*.asc$", full.names = T) %>%
  setNames(nm = .) %>%
  map_df(~read_delim(., show_col_types = F, delim = "\t", skip = 11, col_names = F, n_max = 300), .id = "filename") %>%
  filter(grepl("!CAL VALIDATION H", X2)) %>%
  mutate(
    shortname = gsub(paste0(dt.path, "/"), "", filename),
    run = case_when(
      substr(shortname, 1, 2) == "1_" ~ "1",
      substr(shortname, 1, 2) == "2_" ~ "2",
      T ~ "both"
    ),
    subID = substr(shortname, nchar(shortname)-13, nchar(shortname)-4)
  ) %>%
  group_by(shortname, run) %>%
  mutate(
    n = row_number()
  ) %>%
  filter(n == max(n)) %>%
  mutate(
    val.type  = gsub(".*VALIDATION (.*) R RIGHT.*", "\\1", X2),
    avg.error = as.numeric(gsub(".*ERROR (.*) avg.*", "\\1", X2))
  ) %>%
  select(shortname, subID, run, val.type, avg.error) %>%
  filter(avg.error < 1) %>%
  merge(., df.inc) %>%
  # only keep participants with data for both runs
  group_by(subID) %>% 
  mutate(
    nor = n()
  ) %>%
  filter(run == "both" | nor == 2)

write_csv(df, file = file.path(dt.path, "VMM_ET_inc.csv"))

# Fixation duration -------------------------------------------------------

if (!file.exists(file.path(dt.path, "VMM_fixations.rds"))) {
  
  df.fix = file.path(dt.path, df$shortname) %>%
    setNames(nm = .) %>%
    map_df(~read_delim(., 
                       show_col_types = F, delim = "\t", skip = 11, col_names = F), .id = "filename") %>% 
    filter(grepl("EFIX R", X1)) %>%
    mutate(X2 = gsub(',', ".", X2)) %>%
    separate(X2, sep = "\t", into = c('end', 'duration', 'x.pixel', 'y.pixel', 'pupil')) %>%
    mutate(across(c('end', 'duration', 'x.pixel', 'y.pixel', 'pupil'), as.numeric)) %>%
    mutate(
      dist.centre = sqrt((x.pixel-x.centre)^2 + (y.pixel-y.centre)^2),
      shortname = gsub(paste0(dt.path, "/"), "", filename),
      run = case_when(
        substr(shortname, 1, 2) == "1_" ~ "1",
        substr(shortname, 1, 2) == "2_" ~ "2",
        T ~ "both"
      ),
      subID = substr(shortname, nchar(shortname)-13, nchar(shortname)-4)
    ) %>% select(-X1, -filename)
  
  saveRDS(df.fix, file.path(dt.path, "VMM_fixations.rds"))
  
} else {
  df.fix = readRDS(file.path(dt.path, "VMM_fixations.rds"))
}

### MOVE TO RMARKDOWN



ggplot(df.fix.agg, aes(x = fix.prop, fill = diagnosis)) +
  geom_density(alpha = 0.5) + xlim(0, 1) + theme_bw()
