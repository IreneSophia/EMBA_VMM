# Load packages 
library(tidyverse)

# clear global environment
rm(list=ls())
setwd("/home/emba/Documents/EMBA/VMM_analysis/00_input")
dir.in = getwd()

# get all directories
subs = list.files(pattern = "sub-*")

# loop through them
for (subID in subs) {
  
  tryCatch(
    {
      
      # check if the file exists
      if (file.exists(file.path(getwd(), subID, sprintf("%s_task-1_pms.txt", subID)))) {
        next
      }
      
      # read in the csv file
      df1 = read_csv(file.path(dir.in, sprintf("%s/%s_task-1.csv", subID, subID)), show_col_types = F) %>% 
        mutate(
          duration = 0, 
          pm_colour  = if_else(condition%%2 == 1, 1, -1), # 2, 4 = pink  = -1; 1, 3 = green  = 1
          pm_emotion = if_else(condition<=2,     -1,  1)  # 1, 2 = happy = -1; 3, 4 = afraid = 1
          ) 
      
      # add info on adaptation
      df1 = df1 %>% 
        merge(., 
              df1 %>% filter(lag(pm_colour) != pm_colour) %>% mutate(blk_col = row_number()), 
              all.x = T) %>%
        merge(., 
              df1 %>% filter(lag(pm_emotion) != pm_emotion) %>% mutate(blk_emo = row_number()), 
              all.x = T) %>%
        fill(blk_col, blk_emo) %>% 
        replace_na(list(blk_col = 0, blk_emo = 0)) %>% 
        group_by(blk_col) %>%
        mutate(
          col_adapt = row_number()
        ) %>% group_by(blk_emo) %>%
        mutate(
          emo_adapt = row_number()
        ) %>% ungroup()
      
      # save the parametric EV files
      write_delim(df1 %>%
                    select(onset, condition, trl_blk, pm_colour, pm_emotion, emo_adapt, col_adapt, s.mu_c, s.mu_e, s.eps_c, s.eps_e), 
                  file = file.path(getwd(), subID, sprintf("%s_task-1_pms.txt", subID)), col_names = T)
      
    },
    error = function(err) {
      message(sprintf("Error for %s: %s", subID, err))
    }
  )
  tryCatch(
    {
      
      # check if the file exists
      if (file.exists(file.path(getwd(), subID, sprintf("%s_task-2_pms.txt", subID)))) {
        next
      }
      
      # read in the csv file
      df2 = read_csv(file.path(dir.in, sprintf("%s/%s_task-2.csv", subID, subID)), show_col_types = F) %>% 
        mutate(
          duration = 0, 
          pm_colour  = if_else(condition%%2 == 1, 1, -1),
          pm_emotion = if_else(condition<=2,     -1,  1)
        ) 
      
      # add info on adaptation
      df2 = df2 %>% 
        merge(., 
              df2 %>% filter(lag(pm_colour) != pm_colour) %>% mutate(blk_col = row_number()), 
              all.x = T) %>%
        merge(., 
              df2 %>% filter(lag(pm_emotion) != pm_emotion) %>% mutate(blk_emo = row_number()), 
              all.x = T) %>%
        fill(blk_col, blk_emo) %>% 
        replace_na(list(blk_col = 0, blk_emo = 0)) %>% 
        group_by(blk_col) %>%
        mutate(
          col_adapt = row_number()
        ) %>% group_by(blk_emo) %>%
        mutate(
          emo_adapt = row_number()
        ) %>% ungroup()
      
      # save the parametric EV files
      write_delim(df2 %>% 
                    select(onset, condition, trl_blk, pm_colour, pm_emotion, emo_adapt, col_adapt, s.mu_c, s.mu_e, s.eps_c, s.eps_e), 
                  file = file.path(getwd(), subID, sprintf("%s_task-2_pms.txt", subID)), col_names = T)
      
    },
    error = function(err) {
      message(sprintf("Error for %s: %s", subID, err))
    }
  )
    
}
