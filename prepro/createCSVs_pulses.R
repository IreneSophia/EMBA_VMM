# Load packages 
library(tidyverse)

# clear global environment
rm(list=ls())
setwd("/home/emba/Documents/EMBA/VMM_analysis/00_input")
dir.in   = '/home/emba/Documents/EMBA/BVET'
dir.post = '/home/emba/Documents/EMBA/BVET-Nacherhebung'
dir.out  = '/home/emba/Documents/EMBA/log-check'
tr = 2.451

# read in HGF data --------------------------------------------------------

df.hgf = list.files(pattern = "PLIST_.*.csv", full.names = T) %>%
  setNames(nm = .) %>%
  map_df(~read_csv(., show_col_types = F), .id = "fln") %>%
  mutate(
    order = as.numeric(gsub(".*BEST_(.+)_HGF.*", "\\1", fln))
  ) %>% group_by(order) %>%
  mutate(
    trl = row_number()
  ) %>% select(-fln) %>% 
  ungroup() %>%
  # take the absolute value for all numeric values
  mutate_if(is.numeric, abs) %>%
  # create centered and scaled versions
  mutate(
    c.mu_c  = as.vector(scale(mu_c, scale = F)),
    c.mu_e  = as.vector(scale(mu_e, scale = F)),
    c.eps_c = as.vector(scale(eps_c, scale = F)),
    c.eps_e = as.vector(scale(eps_e, scale = F)),
    s.mu_c  = as.vector(scale(mu_c, scale = T)),
    s.mu_e  = as.vector(scale(mu_e, scale = T)),
    s.eps_c = as.vector(scale(eps_c, scale = T)),
    s.eps_e = as.vector(scale(eps_e, scale = T))
  )

# continuous files --------------------------------------------------------

# get all continuous files
fls = c(list.files(path = dir.in,   pattern = "*-task.tsv", full.names = T),
        list.files(path = dir.post, pattern = "*-task.tsv", full.names = T))

# loop through them
for (fl in fls) {
  
  # get subID
  subID = substr(basename(fl),1,10)
  
  # check if the files exists, if yes move on
  if (file.exists(sprintf('sub-%s_task-1.csv', subID))) {
    next
  }
  
  # read in the log file
  df = read_delim(fl, show_col_types = F) %>%
    # cut off after the last stimulus presentation
    filter(between(row_number(), 1, which(`Event Type` == "Picture")[sum(`Event Type` == "Picture", na.rm = T)]))
  
  # get the info on the first pulse of a run
  # problem: sometimes fieldmap pulses are logged but not always 
  # > need to filter those out
  df.pulses = df %>% 
    mutate(
      rown = row_number()
    ) %>% 
    filter(`Event Type` == "Pulse") %>%
    ungroup() %>%
    mutate(
      diff1 = (Time - lag(Time))/10000, # difference between this and previous pulse
      diff2 = (lead(Time) - Time)/10000 # difference between this and next pulse
    ) %>% 
    select(Trial, `Event Type`, Code, Time, diff1, diff2, rown) %>%
    # pulses from our functional runs are always longer after the previous pulse
    # but very close to the tr to the next pulse
    filter((abs(diff1 - tr) > 0.02) | is.na(diff1), abs(diff2 - tr) < 0.02)
  
  # there should only be two pulses left, the first of the first and the first 
  # of the second run > let's check this at this point!
  if (nrow(df.pulses) != 2) {
    stop("Wrong number of first pulses: ", nrow(df.pulses))
  }
  
  # create additional checks 
  df.check = df %>% 
    mutate(
      rown = row_number()
    ) %>% 
    group_by(`Event Type`) %>%
    mutate(
      diff1 = (Time - lag(Time))/10000, # difference between this and previous pulse
      diff2 = (lead(Time) - Time)/10000, # difference between this and next pulse
      count = if_else(`Event Type` == "Pulse", row_number(), 0)
    ) %>% 
    select(Trial, `Event Type`, Code, count, Time, diff1, diff2, rown)

  df.check = df.check[c(1:which(df.check$count == 6), 
                        (which(df.check$count == 370)):(which(df.check$count == 390))),]
  
  df.check$selected = 0
  df.check[df.check$rown == df.pulses$rown[1] | df.check$rown == df.pulses$rown[2], ]$selected = 1
  
  # check if it works with the fieldmaps > save it with mismatch appended if not
  if ((df.check[df.check$rown == df.pulses$rown[1],]$count == 1 & df.check[df.check$rown == df.pulses$rown[2],]$count == 383) |
      (df.check[df.check$rown == df.pulses$rown[1],]$count == 3 & df.check[df.check$rown == df.pulses$rown[2],]$count == 385)) {
    write_csv(df.check, file.path(dir.out, paste0(subID, '.csv')))
  } else {
    write_csv(df.check, file.path(dir.out, paste0(subID, '_mismatch.csv')))
  }
  
  # task-1
  df1 = df[df.pulses$rown[1]:df.pulses$rown[2],]
  start1 = df.pulses$Time[1]
  df1.button = df1 %>%
    filter(`Event Type` == "Response" & Code != "5") %>%
    mutate(
      onset = (Time - start1)/10000
    ) %>% select(onset)
  df1 = df1 %>%
    filter(`type(str)` == "pic") %>%
    mutate(
      trl      = if_else(`trl(num)` > 595, `trl(num)` - 595, `trl(num)`),
      onset    = (Time - start1)/10000
    ) %>% rename("subID" = "Subject", "order" = "run(num)",
                 "condition" = "cnd(num)", "trl_blk" = "trlb(num)") %>%
    select(subID, order, trl, trl_blk, condition, onset) %>%
    mutate(
      first_onset = df.pulses$Time[1],
      first_trial = df.pulses$Trial[1]
    )
  df1 = merge(df1, df.hgf, all.x = T) %>% arrange(onset)
  if (nrow(df1) != 1190) {
    warning("Task-1 wrong number of trials: ", subID)
  }
  write_csv(df1, file = sprintf("sub-%s/sub-%s_task-1.csv", subID, subID))
  write_delim(df1.button, file = sprintf("sub-%s/sub-%s_task-1_button.txt", subID, subID), delim = " ", col_names = F)

  # task-2
  df2 = df[df.pulses$rown[2]:nrow(df),]
  start2 = df.pulses$Time[2]
  df2.button = df2 %>%
    filter(`Event Type` == "Response" & Code != "5") %>%
    mutate(
      onset = (Time - start2)/10000
    ) %>% select(onset)
  df2 = df2 %>%
    filter(`type(str)` == "pic") %>%
    mutate(
      trl      = if_else(`trl(num)` > 595, `trl(num)` - 595, `trl(num)`),
      onset    = (Time - start2)/10000
    ) %>% rename("subID" = "Subject", "order" = "run(num)",
                 "condition" = "cnd(num)", "trl_blk" = "trlb(num)") %>%
    select(subID, order, trl, trl_blk, condition, onset) %>%
    mutate(
      first_onset = df.pulses$Time[2],
      first_trial = df.pulses$Trial[2]
    )
  df2 = merge(df2, df.hgf, all.x = T) %>% arrange(onset)
  if (nrow(df2) != 1190) {
    warning("Task-2 wrong number of trials: ", subID)
  }
  write_csv(df2, file = sprintf("sub-%s/sub-%s_task-2.csv", subID, subID))
  write_delim(df2.button, file = sprintf("sub-%s/sub-%s_task-2_button.txt", subID, subID), delim = " ", col_names = F)
  
}

# separate files ----------------------------------------------------------

# get all files > ignore pilots
fls1 = list.files(path = dir.in, pattern = "^(.|[^P].*|.[^I].*)\\-task-1.tsv")
fls2 = list.files(path = dir.in, pattern = "^(.|[^P].*|.[^I].*)\\-task-2.tsv")

# get all files > including pilots
fls1 = list.files(path = dir.in, pattern = "*-task-1.tsv")
fls2 = list.files(path = dir.in, pattern = "*-task-2.tsv")

# loop through task-1 files
for (fl in fls1) {
  
  # get subID
  subID = substr(gsub("PILOT-", "", fl),1,10)
  
  # check if the files exists, if yes move on
  if (file.exists(sprintf('sub-%s_task-1.csv', subID))) {
    next
  }
  
  # read in the log file
  df = read_delim(file.path(dir.in, fl), show_col_types = F) %>%
    # cut off after the last stimulus presentation
    filter(between(row_number(), 1, which(`Event Type` == "Picture")[sum(`Event Type` == "Picture", na.rm = T)]))
  
  # get the info on the first pulse of a run
  # problem: sometimes fieldmap pulses are logged but not always 
  # > need to filter those out
  df.pulses = df %>% 
    mutate(
      rown = row_number()
    ) %>% 
    filter(`Event Type` == "Pulse") %>%
    ungroup() %>%
    mutate(
      diff1 = (Time - lag(Time))/10000, # difference between this and previous pulse
      diff2 = (lead(Time) - Time)/10000 # difference between this and next pulse
    ) %>% 
    select(Trial, `Event Type`, Code, Time, diff1, diff2, rown) %>%
    # pulses from our functional runs are always longer after the previous pulse
    # but very close to the tr to the next pulse
    filter((abs(diff1 - tr) > 0.02) | is.na(diff1), abs(diff2 - tr) < 0.02)
  
  # there should only be one pulse left, the first of this task > let's check!
  if (nrow(df.pulses) != 1) {
    stop("Wrong number of first pulses: ", nrow(df.pulses), " ", subID)
  }
  
  # create additional checks 
  df.check = df %>% 
    mutate(
      rown = row_number()
    ) %>% 
    group_by(`Event Type`) %>%
    mutate(
      diff1 = (Time - lag(Time))/10000, # difference between this and previous pulse
      diff2 = (lead(Time) - Time)/10000, # difference between this and next pulse
      count = if_else(`Event Type` == "Pulse", row_number(), 0)
    ) %>% 
    select(Trial, `Event Type`, Code, count, Time, diff1, diff2, rown)
  
  df.check = df.check[c(1:which(df.check$count == 10), 
                        (nrow(df.check)-20):(nrow(df.check))),]
  
  df.check$selected = 0
  df.check[df.check$rown == df.pulses$rown[1], ]$selected = 1
  
  # check if it works with the fieldmaps > save it with mismatch appended if not
  if ((df.check[df.check$rown == df.pulses$rown[1],]$count == 1 | df.check[df.check$rown == df.pulses$rown[1],]$count == 3 )) {
    write_csv(df.check, file.path(dir.out, paste0(subID, '_task-1.csv')))
  } else {
    write_csv(df.check, file.path(dir.out, paste0(subID, '_task-1_mismatch.csv')))
  }
  
  # task-1
  df    = df[df.pulses$rown[1]:nrow(df),]
  start = df.pulses$Time[1]
  df.button = df %>% 
    filter(`Event Type` == "Response" & Code != "5") %>%
    mutate(
      onset = (Time - start)/10000
    ) %>% select(onset)
  df = df %>%
    filter(`type(str)` == "pic") %>%
    mutate(
      trl      = if_else(`trl(num)` > 595, `trl(num)` - 595, `trl(num)`),
      onset    = (Time - start)/10000
    ) %>% rename("subID" = "Subject", "order" = "run(num)", 
                 "condition" = "cnd(num)", "trl_blk" = "trlb(num)") %>%
    select(subID, order, trl, trl_blk, condition, onset) %>%
    mutate(
      first_onset = df.pulses$Time[1],
      first_trial = df.pulses$Trial[1]
    )
  df = merge(df, df.hgf, all.x = T) %>% arrange(onset)
  if (nrow(df) != 1190) {
    warning("Task-1 wrong number of trials: ", subID)
  }
  write_csv(df, file = sprintf("sub-%s/sub-%s_task-1.csv", subID, subID))
  write_delim(df.button, file = sprintf("sub-%s/sub-%s_task-1_button.txt", subID, subID), delim = " ", col_names = F)
  
}

# loop through task-2 files
for (fl in fls2) {
  
  # get subID
  subID = substr(gsub("PILOT-", "", fl),1,10)
  
  # check if the folder exists otherwise move on
  if (dir.exists(sprintf("sub-%s", subID)) == F) {
    next
  }
  
  # read in the log file
  df = read_delim(file.path(dir.in, fl), show_col_types = F) %>%
    # cut off after the last stimulus presentation
    filter(between(row_number(), 1, which(`Event Type` == "Picture")[sum(`Event Type` == "Picture", na.rm = T)]))
  
  # get the info on the first pulse of a run
  # problem: sometimes fieldmap pulses are logged but not always 
  # > need to filter those out
  df.pulses = df %>% 
    mutate(
      rown = row_number()
    ) %>% 
    filter(`Event Type` == "Pulse") %>%
    ungroup() %>%
    mutate(
      diff1 = (Time - lag(Time))/10000, # difference between this and previous pulse
      diff2 = (lead(Time) - Time)/10000 # difference between this and next pulse
    ) %>% 
    select(Trial, `Event Type`, Code, Time, diff1, diff2, rown) %>%
    # pulses from our functional runs are always longer after the previous pulse
    # but very close to the tr to the next pulse
    filter((abs(diff1 - tr) > 0.02) | is.na(diff1), abs(diff2 - tr) < 0.02)
  
  # there should only be one pulse left, the first of this task > let's check!
  if (nrow(df.pulses) != 1) {
    stop("Wrong number of first pulses: ", nrow(df.pulses), " ", subID)
  }
  
  # create additional checks 
  df.check = df %>% 
    mutate(
      rown = row_number()
    ) %>% 
    group_by(`Event Type`) %>%
    mutate(
      diff1 = (Time - lag(Time))/10000, # difference between this and previous pulse
      diff2 = (lead(Time) - Time)/10000, # difference between this and next pulse
      count = if_else(`Event Type` == "Pulse", row_number(), 0)
    ) %>% 
    select(Trial, `Event Type`, Code, count, Time, diff1, diff2, rown)
  
  df.check = df.check[c(1:which(df.check$count == 10), 
                        (nrow(df.check)-20):(nrow(df.check))),]
  
  df.check$selected = 0
  df.check[df.check$rown == df.pulses$rown[1], ]$selected = 1
  
  # check if it works with the fieldmaps > save it with mismatch appended if not
  if ((df.check[df.check$rown == df.pulses$rown[1],]$count == 1 | df.check[df.check$rown == df.pulses$rown[1],]$count == 3 )) {
    write_csv(df.check, file.path(dir.out, paste0(subID, '_task-2.csv')))
  } else {
    write_csv(df.check, file.path(dir.out, paste0(subID, '_task-2_mismatch.csv')))
  }
  
  # task-1
  df    = df[df.pulses$rown[1]:nrow(df),]
  start = df.pulses$Time[1]
  df.button = df %>% 
    filter(`Event Type` == "Response" & Code != "5") %>%
    mutate(
      onset = (Time - start)/10000
    ) %>% select(onset)
  df = df %>%
    filter(`type(str)` == "pic") %>%
    mutate(
      trl      = if_else(`trl(num)` > 595, `trl(num)` - 595, `trl(num)`),
      onset    = (Time - start)/10000
    ) %>% rename("subID" = "Subject", "order" = "run(num)", 
                 "condition" = "cnd(num)", "trl_blk" = "trlb(num)") %>%
    select(subID, order, trl, trl_blk, condition, onset) %>%
    mutate(
      first_onset = df.pulses$Time[1],
      first_trial = df.pulses$Trial[1]
    )
  df = merge(df, df.hgf, all.x = T) %>% arrange(onset)
  if (nrow(df) != 1190) {
    warning("Task-2 wrong number of trials: ", subID)
  }
  write_csv(df, file = sprintf("sub-%s/sub-%s_task-2.csv", subID, subID))
  write_delim(df.button, file = sprintf("sub-%s/sub-%s_task-2_button.txt", subID, subID), delim = " ", col_names = F)
  
}
