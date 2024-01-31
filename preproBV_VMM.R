library(knitr)           # kable
library(tidyverse)       # tibble stuff
library(ggplot2)         # plots
library(ggstatsplot)     # ggplot with stats
library(ggpubr)          # background image
library(png)             # readPNG

dt.path = paste('/home/emba/Documents/EMBA', 'BVET', sep = "/")

# participants from whom we can use the MRI data
df.inc  = read_csv(file.path(dt.path, 'df_VMM_include.csv'))

# load the relevant data in long format: only people with separate logs for runs
df.log1 = list.files(path = dt.path, pattern = "*task-.*\\.tsv$", full.names = T) %>%
  setNames(nm = .) %>%
  map_df(~read_delim(., show_col_types = F, delim = "\t"), .id = "Filename") %>%
  mutate(
    Run = sub(".*task-", "", Filename),
    Run = as.numeric(substr(Run, 1, 1))
  ) %>% filter(nchar(Subject) == 10) %>%
  select(-Filename) 
# load the relevant data in long format: only people with one log for both runs
df.log2 = list.files(path = dt.path, pattern = "*task.tsv$", full.names = T) %>%
  setNames(nm = .) %>%
  map_df(~read_delim(., show_col_types = F, delim = "\t"), .id = "Filename") %>%
  group_by(Subject, `Event Type`) %>%
  mutate(
    Run = case_when(`Event Type` == "Pulse" ~ row_number())
  ) %>% select(-Filename) %>% 
  ungroup() %>%
  fill(Run, .direction = "up") %>%
  mutate(
    Run = case_when(Run <= 380 ~ 1, TRUE ~ 2)
  )
# bind them together
df.log = rbind(df.log1, df.log2)

# merge with subjects
df.log = merge(df.inc, df.log, all.x = T)

# only rows relevant for answer
df.logresp = df.log %>% 
  filter(Code != 255 & ((`Event Type` == "Response" & Code <= 4) | `flp_rel(num)` == 1)) %>%
  arrange(Subject, Run, Trial) %>%
  select(Subject, Run, Trial, `Event Type`, Time)

# get trial numbers for the flips
df.flips = df.log %>% 
  filter((`Event Type` == "Picture" & `flp_rel(num)` == 1)) %>%
  arrange(Subject, Run, Trial) %>%
  group_by(Subject) %>%
  mutate(
    trl = row_number()
  ) %>% ungroup() %>%
  select(Subject, Run, Trial, trl)

# merge responses with flips
df.logresp = merge(df.logresp, df.flips, all = T)

# find relevant responses to each flip
sub  = c()
run  = c()
trl  = c()
rt   = c()
sdt  = c()

for (i in 1:nrow(df.logresp)) {
  # first, check if this is the first row
  if (i == 1) {
    # check if it's a picture, otherwise set look for picture
    if (df.logresp$`Event Type`[i] == "Picture") {
      onset = df.logresp$Time[i] # ...get the onset and look for response
      look  = "Response"
    } else {
      look  = "Picture"
    }
    # if we are not in the first row, check if it's a new run or subject
  } else if ((df.logresp$Subject[i] != df.logresp$Subject[i-1]) | 
             (df.logresp$Run[i] != df.logresp$Run[i-1])) {
    # check if it's a picture, otherwise set look to picture
    if (df.logresp$`Event Type`[i] == "Picture") {
      onset = df.logresp$Time[i] # ...get the onset and look for response
      look  = "Response"
    } else {
      look  = "Picture"
    }
    # if it's not a new run or subject and it's a picture and we're looking for a picture...
  } else if (df.logresp$`Event Type`[i] == look & look == "Picture") {
    onset = df.logresp$Time[i] # ...get the onset and look for response
    look  = "Response"
    # if we are looking for a response and it is one...
  } else if (df.logresp$`Event Type`[i] == look & look == "Response") {
    sub   = c(sub, df.logresp$Subject[i]) # ...log it all!
    run   = c(run, df.logresp$Run[i])
    trl   = c(trl, df.logresp$trl[i-1])
    rt    = c(rt, (df.logresp$Time[i] - onset)/10)
    sdt   = c(sdt, "hit")
    look  = "Picture"
    # if it's a picture and we are looking for a response
  } else if (df.logresp$`Event Type`[i] == "Picture" & look == "Response") {
    sub   = c(sub, df.logresp$Subject[i-1])
    run   = c(run, df.logresp$Run[i-1])
    trl   = c(trl, df.logresp$trl[i-1])
    rt    = c(rt, NA)
    sdt   = c(sdt, "miss")
    onset = df.logresp$Time[i]
    # if it's a response and we are looking for a picture
  } else if (df.logresp$`Event Type`[i] == "Response" & look == "Picture") {
    sub   = c(sub, df.logresp$Subject[i-1])
    run   = c(run, df.logresp$Run[i-1])
    trl   = c(trl, NA)
    rt    = c(rt, NA)
    sdt   = c(sdt, "faal")
  }
}

rt = round(rt)

df.tsk = data.frame(sub, run, trl, rt, sdt) %>%
  rename("subID" = "sub") %>%
  group_by(subID) %>%
  mutate(
    subID = as.factor(subID),
    iqr   = IQR(rt, na.rm = T),
    cl    = quantile(rt, probs = c(.75), na.rm = T) + 1.5 * iqr,
    fl    = quantile(rt, probs = c(.25), na.rm = T) - 1.5 * iqr,
    rtc   = ifelse(rt > cl | rt < fl, NA, rt),
    sdt   = as.factor(case_when(rt <= 2000 ~ sdt,
                                rt >  2000 ~ "miss", # answers slower than this are counted as misses
                                is.na(rt)  ~ sdt))
  ) %>% select(-iqr, -cl, -fl)

rm(list = c("df.log1","df.log2"))

# remove participants who missed more than 1/3 of fixation cross changes per run
# or more than 1/3 of false alarms in one of the runs
df.tsk = df.tsk %>%
  group_by(subID, run) %>%
  mutate(
    run.miss   = sum(sdt == "miss")/120,      # there are 120 flips per run
    run.faal   = sum(sdt == "faal")/120
  ) %>%
  group_by(subID) %>%
  mutate(
    max.miss = max(run.miss),
    max.faal = max(run.faal)
  ) %>%
  filter(max.miss < 0.33 & max.faal < 0.33) %>%
  ungroup()

nsub = length(unique(df.tsk$subID))

# how many people were excluded due to behavioural data?
nrow(df.inc) - nsub

# create a data frame with discrimination rate
df.disc = df.tsk %>%
  group_by(subID) %>%
  summarise(
    hits = sum(sdt == "hit", na.rm = T),
    faal = sum(sdt == "faal", na.rm = T),
  ) %>%
  mutate(
    disc = hits - faal
  )

# save the data frame
save(df.tsk, df.disc, file = file.path(dt.path, "VMM_data.RData"))

