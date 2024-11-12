# libraries
library(tidyverse)       # tibble stuff

# total number of flips 
n.trl = 240

# file paths
dt.path1 = paste('/home/emba/Documents/EMBA', 'BVET', sep = "/")
dt.path2 = paste('/home/emba/Documents/EMBA', 'BVET-Nacherhebung', sep = "/")

# load the relevant data in long format: only people with separate logs for runs
df.log1 = c(list.files(path = dt.path1, pattern = "*task-.*\\.tsv$", full.names = T),
            list.files(path = dt.path2, pattern = "*task-.*\\.tsv$", full.names = T)) %>%
  setNames(nm = .) %>%
  map_df(~read_delim(., show_col_types = F, delim = "\t"), .id = "Filename") %>%
  mutate(
    run = sub(".*task-", "", Filename),
    run = as.numeric(substr(run, 1, 1))
  ) %>% filter(nchar(Subject) == 10) %>%
  select(-Filename) 
# load the relevant data in long format: only people with one log for both runs
df.log2 = c(list.files(path = dt.path1, pattern = "*task.tsv$", full.names = T),
            list.files(path = dt.path2, pattern = "*task.tsv$", full.names = T)) %>%
  setNames(nm = .) %>%
  map_df(~read_delim(., show_col_types = F, delim = "\t")) %>%
  mutate(
    run = case_when(Trial <= 2504 ~ 1, TRUE ~ 2)
  ) %>% filter(nchar(Subject) == 10)
# bind together
df.log = rbind(df.log1, df.log2)

# preprocess the responses
df.logresp = df.log %>%
  # get rid of everything before the task starts and after it ends
  group_by(Subject) %>%
  mutate(
    max_trl = max(`trl(num)`, na.rm = T),
    use = case_when(`trl(num)` == 1 ~ 1,
                    lag(`trl(num)`) == max_trl & lag(`type(str)`) == "fix" ~ 2
                    )
  ) %>%
  fill(use, .direction = "down") %>%
  filter(use == 1) %>%
  # label the trials based on the flip 
  group_by(Subject, `flp_rel(num)`) %>%
  mutate(
    trl = if_else(`flp_rel(num)` == 1, row_number(), NA)
  ) %>%
  # add information on the button pressed and convert the Time to seconds
  group_by(Subject, run) %>%
  mutate(
    button = as.numeric(Code),
    onset  = Time / 10 # convert to milliseconds
  ) %>%
  # concentrate on the flips and the button presses
  filter(`Event Type` == 'Response' | `flp_rel(num)`) %>%
  mutate(
    sdt = case_when(
      # false alarms are consecutive responses not separated by a flip
      ((lag(`flp_rel(num)`) != 1 | is.na(lag(`flp_rel(num)`))) & `Event Type` == 'Response') |
      # ...or button presses more than 2s after a flip
       ((onset - lag(onset)) > 2000 & `Event Type` == 'Response') ~ "faal", 
      # hits are responses immediately following a flip
      lag(`flp_rel(num)`) == 1 & `Event Type` == 'Response' ~ "hit"
    ),
    rt = if_else(sdt == "hit", onset - lag(onset), NA)
  ) %>% 
  fill(trl, .direction = "down") %>%
  filter(`Event Type` == 'Response' & button != 5) %>%
  rename(
    "subID" = "Subject"
  ) %>%
  select(subID, run, trl, sdt, rt) %>%
  mutate(across(where(is.character), as.factor))

df.tsk = df.logresp %>%
  group_by(subID) %>%
  mutate(
    iqr      = IQR(rt, na.rm = T),
    cl       = quantile(rt, probs = c(.75), na.rm = T) + 1.5 * iqr,
    fl       = quantile(rt, probs = c(.25), na.rm = T) - 1.5 * iqr,
    # exclude rts with IQR method
    rtc      = ifelse(rt > cl | rt < fl , NA, rt),
    # get the number of trials for this participant
    max.trl  = max(trl, na.rm = T)
  ) %>% select(-iqr, -cl, -fl)

# get number of subjects
sub  = unique(df.tsk$subID)
nsub = length(sub)

# remove participants who missed more than 1/3 of fixation cross changes per run
# or more than 1/3 of false alarms in one of the runs
df.tsk = df.tsk %>%
  group_by(subID, run) %>%
  mutate(
    run.miss   = 1 - (sum(sdt == "hit")/(n.trl/2)),      # per run
    run.faal   = sum(sdt == "faal")/(n.trl/2)
  ) %>%
  group_by(subID) %>%
  mutate(
    max.miss = max(run.miss),
    max.faal = max(run.faal)
  ) %>%
  # only keep participants who have not missed too many flips or reacted to the
  # faces instead (high false alarm rate) and who have both runs
  filter(max.miss < 1/3 & max.faal < 1/3 & max.trl > (n.trl/2)) %>%
  ungroup()

# how many people were excluded due to behavioural data?
nsub - length(unique(df.tsk$subID))

# save the IDs of the excluded participants
exc = setdiff(unique(sub), unique(as.character(df.tsk$subID)))
write(exc, file = file.path(dt.path1, "VMM_exc.txt"))

# create a data frame with discrimination rate
df.disc = df.tsk %>%
  group_by(subID) %>%
  summarise(
    disc  = (sum(sdt == "hit", na.rm = T) - 
               sum(sdt == "faal", na.rm = T))
  )

# save the data frame
save(df.tsk, df.disc, file = file.path(dt.path1, "VMM_preprocessed.RData"))
