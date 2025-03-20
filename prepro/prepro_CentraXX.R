# Load packages 
library(tidyverse)

# Clear global environment
rm(list=ls())
setwd("/home/emba/Documents/EMBA/CentraXX")

# load raw data
# columns of Interest: internalStudyMemberID, name2, code, value, section, (valueIndex), numericValue
df = read_csv("EMOPRED_20250127.csv", show_col_types = F) %>%
  select(internalStudyMemberID, date, name2, code, value, section, numericValue) %>%
  filter(internalStudyMemberID != "NEVIA_test" & !is.na(name2)) %>%
  rename("questionnaire" = "name2", 
         "item" = "code", 
         "PID" = "internalStudyMemberID") %>%
  mutate(
    value = str_replace(value, ",", ";"),
    PID   = substr(PID, 1, 10)
  ) %>% 
  filter(substr(PID,1,7) != "EMOPRED") %>%                                      # filter out pilots
  group_by(PID)

## date of testing
df.date = df %>%
  group_by(PID) %>%
  summarise(
    date = min(date, na.rm = T)
  )

## preprocess each questionnaire separately:

# ASRS (0 bis 16: sehr unwahrscheinlich, 17 bis 23: es besteht die Möglichkeit, 24 oder größer: sehr wahrscheinlich)
df.asrs = df %>% filter(questionnaire == "PSY_NEVIA_ASRS") %>%
  mutate(
    numericValue = recode(value, 
                          `Nie` = 0,
                          `Selten` = 1,
                          `Manchmal` = 2,
                          `Oft` = 3,
                          `Sehr oft` = 4),
    section = recode(section, 
                     `Teil A` = "A",
                     `Teil B` = "B", 
                     `Teil C` = "B")
  ) %>% select(questionnaire, PID, section, numericValue) %>%
  group_by(PID, section) %>% 
  summarise(
    ASRS_total = sum(numericValue, na.rm = T),
    ASRS_extreme = sum(numericValue >= 3)
  ) %>% pivot_wider(names_from = section, values_from = c(ASRS_total, ASRS_extreme)) %>%
  mutate(
    ASRS_total = sum(c(ASRS_total_A, ASRS_total_B))
  )

# PSY_NEVIA_BDI 
# (10 bis 19: leichtes depressives Syndrom, 20 bis 29: mittelgradiges, >= 30: schweres)
df.bdi = df %>% filter(questionnaire == "PSY_NEVIA_BDI")  %>%
  ungroup() %>%
  mutate(
    numericValue = case_when(
      "NEIN" == value ~ 0,
      "Ja"   == value ~ 1,
      # if there are multiple answers chosen, select the highest value
      grepl(", ", numericValue, fixed = T) ~ max(readr::parse_number(str_split(numericValue, ", ")[[1]])),
      # if not, just convert it to a number
      T ~ as.numeric(numericValue)
      )
    ) %>%
  select(questionnaire, PID, item, numericValue) %>%
  group_by(PID) %>%
  summarise(
    BDI_total = sum(numericValue, na.rm = T)
  )

# PSY_NEVIA_CFT
df.cft = df %>% filter(questionnaire == "PSY_NEVIA_CFT") %>% 
  group_by(PID) %>%
  select(-c(questionnaire, section, numericValue)) %>%
  rename("raw" = `value`) %>%
  mutate(
    item = gsub("^PSY_PIPS_", "", item), 
    score = case_when(
      raw == 'd' & item == 'CFT_1_1' ~ 1, raw == 'b' & item == 'CFT_1_2' ~ 1,raw == 'e' & item == 'CFT_1_3' ~ 1,
      raw == 'a' & item == 'CFT_1_4' ~ 1, raw == 'e' & item == 'CFT_1_5' ~ 1, raw == 'b' & item == 'CFT_1_6' ~ 1, 
      raw == 'c' & item == 'CFT_1_7' ~ 1, raw == 'c' & item == 'CFT_1_8' ~ 1, raw == 'd' & item == 'CFT_1_9' ~ 1, 
      raw == 'a' & item == 'CFT_1_10' ~ 1, raw == 'b' & item == 'CFT_1_11' ~ 1, raw == 'a' & item == 'CFT_1_12' ~ 1, 
      raw == 'c' & item == 'CFT_1_13' ~ 1, raw == 'd' & item == 'CFT_1_14' ~ 1, raw == 'e' & item == 'CFT_1_15' ~ 1, 
      raw == 'd' & item == 'CFT_2_1' ~ 1, raw == 'a' & item == 'CFT_2_2' ~ 1, raw == 'b' & item == 'CFT_2_3' ~ 1, 
      raw == 'a' & item == 'CFT_2_4' ~ 1, raw == 'e' & item == 'CFT_2_5' ~ 1, raw == 'c' & item == 'CFT_2_6' ~ 1, 
      raw == 'b' & item == 'CFT_2_7' ~ 1, raw == 'a' & item == 'CFT_2_8' ~ 1, raw == 'c' & item == 'CFT_2_9' ~ 1, 
      raw == 'e' & item == 'CFT_2_10' ~ 1, raw == 'c' & item == 'CFT_2_11' ~ 1, raw == 'e' & item == 'CFT_2_12' ~ 1, 
      raw == 'd' & item == 'CFT_2_13' ~ 1, raw == 'd' & item == 'CFT_2_14' ~ 1, raw == 'b' & item == 'CFT_2_15' ~ 1, 
      raw == 'b' & item == 'CFT_3_1' ~ 1, raw == 'c' & item == 'CFT_3_2' ~ 1, raw == 'b' & item == 'CFT_3_3' ~ 1, 
      raw == 'd' & item == 'CFT_3_4' ~ 1, raw == 'b' & item == 'CFT_3_5' ~ 1, raw == 'a' & item == 'CFT_3_6' ~ 1, 
      raw == 'e' & item == 'CFT_3_7' ~ 1, raw == 'd' & item == 'CFT_3_8' ~ 1, raw == 'c' & item == 'CFT_3_9' ~ 1, 
      raw == 'a' & item == 'CFT_3_10' ~ 1, raw == 'e' & item == 'CFT_3_11' ~ 1, raw == 'c' & item == 'CFT_3_12' ~ 1, 
      raw == 'd' & item == 'CFT_3_13' ~ 1, raw == 'e' & item == 'CFT_3_14' ~ 1, raw == 'a' & item == 'CFT_3_15' ~ 1, 
      raw == 'd' & item == 'CFT_4_1' ~ 1, raw == 'b' & item == 'CFT_4_2' ~ 1, raw == 'e' & item == 'CFT_4_3' ~ 1, 
      raw == 'b' & item == 'CFT_4_4' ~ 1, raw == 'c' & item == 'CFT_4_5' ~ 1, raw == 'a' & item == 'CFT_4_6' ~ 1, 
      raw == 'd' & item == 'CFT_4_7' ~ 1, raw == 'a' & item == 'CFT_4_8' ~ 1, raw == 'a' & item == 'CFT_4_9' ~ 1, 
      raw == 'c' & item == 'CFT_4_10' ~ 1, raw == 'e' & item == 'CFT_4_11' ~ 1, TRUE ~ 0
    )
  ) %>% summarise(
    CFT_total = sum(score)
  )

# PSY_NEVIA_DEMO

df.demo = df %>% filter(questionnaire == "PSY_NEVIA_DEMO") %>%
  mutate(
    item = recode(item, 
                  `PSY_PIPS_Demo_Alter/age` = "age",
                  `PSY_NEVIA_DEMO_gender` = "gender",
                  `PSY_PIPS_Demo_Diagnose/diagnosis` = "ASD",
                  `PSY_PIPS_Demo_seit/since` = "since",
                  `PSY_NEVIA_DEMO_code` = "ASDcode",
                  `PSY_NEVIA_DEMO_familyASD` = "ASDfamily",
                  `PSY_NEVIA_DEMO_diagnoseADHD` = "ADHD",
                  `PSY_NEVIA_DEMO_seit2` = "ADHDsince",
                  `PSY_NEVIA_DEMO_familyADHD` = "ADHDfamily",
                  `PSY_NEVIA_DEMO_diagcode2` = "ADHDcode",
                  `PSY_PIPS_DEMO_DISEASES_1` = "physDisease",
                  `PSY_PIPS_DEMO_DISEASES_2` = "psychDisease",
                  `PSY_PIPS_DEMO_MEDICATION` = "meds", 
                  `PSY_NEVIA_DEMO_edu` = "edu",
                  `PSY_PIPS_Demo_Sehhilfe/glasses` = "vision", 
                  `PSY_NEVIA_DEMO_handedness` = "handedness",
                  `PSY_PIPS_Demo_Metall/metal` = "metal",
                  `PSY_NEVIA_emotiontraining` = "emoTrain",
                  `PSY_NEVIA_fallsja_4` = "emotrainDetails"),
    item = gsub("^PSY_NEVIA_DEMO_Geschlechtsiden.*", "cis", item, useBytes = TRUE),
    value = gsub("^(Keine|Nein|keine).*", "0", value),
    value = gsub("^Ja", "1", value)
  )

df.demo[!is.na(df.demo$numericValue),]$value = as.character(df.demo[!is.na(df.demo$numericValue),]$numericValue)

df.demo = df.demo %>%
  group_by(PID) %>% select(PID, item, value) %>%
  pivot_wider(names_from = item, values_from = value)

# PSY_NEVIA_MWT
df.mwt = df %>% filter(questionnaire == "PSY_NEVIA_MWT") %>%
  group_by(PID) %>% select(PID, numericValue) %>%
  mutate(
    numericValue = as.numeric(numericValue)
  ) %>%
  summarise(
    MWT_total = sum(numericValue, na.rm = T)
  )

# PSY_NEVIA_RAADS
# scores above 65 are consistent with ASD
df.raads = df %>% filter(questionnaire == "PSY_NEVIA_RAADS") %>%
  mutate(
    numericValue = recode(value, 
           `Nur wahr als ich < 16 J. alt war` = 1,
           `Nur jetzt wahr` = 2,
           `Wahr jetzt und als ich jung war` = 3,
           `Nicht wahr` = 0),
    section = gsub("^Abschnitt ", "", section),
    item = gsub("^PSY_NEVIA_RAADS_", "", item)
  ) %>% group_by(PID) %>% 
  select(PID, item, section, numericValue)

# some need to be turned around: 1, 6, 11, 23, 26, 33, 37, 43, 47, 48, 53, 58, 62, 68, 72, 77
idx = c(1, 6, 11, 23, 26, 33, 37, 43, 47, 48, 53, 58, 62, 68, 72, 77)
df.raads[df.raads$item %in% idx,]$numericValue = abs(df.raads[df.raads$item %in% idx,]$numericValue - max(df.raads$numericValue, na.rm = T) + min(df.raads$numericValue, na.rm = T))

df.raads = df.raads %>% group_by(PID) %>%
  summarise(
    RAADS_total = sum(numericValue, na.rm = T)
  )

# PSY_NEVIA_TAS
# <= 51 non-alexithymia, 52 to 60 possible, >=61 alexithymia
# subscales: difficulty describing feelings, difficulty identifying feelings, externally-oriented thinking
df.tas = df %>% filter(questionnaire == "PSY_NEVIA_TAS") %>%
  mutate(
    item = gsub("^PSY_BOKI_TAS_", "", item), 
    numericValue = as.numeric(numericValue)
  ) %>% group_by(PID) %>% 
  select(PID, item, numericValue)

# some need to be turned around
idx = c(4, 5, 10, 18, 19)
df.tas[df.tas$item %in% idx,]$numericValue = abs(df.tas[df.tas$item %in% idx,]$numericValue - (max(df.tas$numericValue, na.rm = T) + min(df.tas$numericValue, na.rm = T)))

df.tas = df.tas %>% group_by(PID) %>%
  summarise(
    TAS_total = sum(numericValue, na.rm = T)
  )

# merge all together
ls.df = list(df.date, df.demo, df.cft, df.mwt, df.bdi, df.asrs, df.raads, df.tas)
df.sub = ls.df %>% reduce(full_join, by = "PID") %>% 
  mutate(
    age = as.numeric(age)
  )

# add iq scores
mwt = read_delim("MWT-norms.csv", show_col_types = F, delim = ";")
cft = read_delim("CFT-norms.csv", show_col_types = F, delim = ";")

df.sub$CFT_iq = NA
df.sub$MWT_iq = NA
for (i in 1:nrow(df.sub)) {
  if (df.sub$CFT_total[i] >= 9 & !is.na(df.sub$CFT_total[i]) & !is.na(df.sub$age[i]) & df.sub$age[i] >= 16 & df.sub$age[i] <= 60) {
    df.sub$CFT_iq[i] = cft[(df.sub$age[i] >= cft$lower & df.sub$age[i] <= cft$upper & df.sub$CFT_total[i] == cft$raw),]$iq
  }
  if (!is.na(df.sub$MWT_total[i])) {
    df.sub$MWT_iq[i] = mwt[(df.sub$MWT_total[i] == mwt$raw),]$iq
  }
}

# filter out pilots and some participants
df.sub = df.sub %>%
  filter(!is.na(ASRS_total)) %>%                                                # filter out participants who did not complete study
  mutate(
    PID = substr(PID,1,10)
  )

# load csv with PIDs and IQs from other studies
df.iqs = read_delim(file = paste("PID_iq.csv", sep = "/"), show_col_types = F) %>%
  select(PID, MWT_iq, CFT_iq) %>% drop_na() %>% 
  filter(nchar(PID) == 10)

# update our df.sub with these values
df.sub = rows_update(df.sub, df.iqs) %>%
  mutate(
    iq = (MWT_iq + CFT_iq)/2
  )

# check if there are still IQ values missing
if (nrow(df.sub %>% filter(is.na(MWT_iq))) > 0) {
  warning('There are still IQ values missing!')
  # save csv with PIDs where we need the iq values from other studies
  write_csv(df.sub %>% filter(is.na(MWT_iq)) %>% select(PID), file = "PID_iq_missing.csv")
}

# categorise the groups and gender
df.sub = df.sub %>%
  mutate(
    ASD  = as.numeric(ASD),
    ADHD = as.numeric(ADHD),
    diagnosis = as.factor(case_when(
      ASD  == 1 & ADHD  == 1                ~ "BOTH",
      ASD  == 1 & (ADHD == 0 | is.na(ADHD)) ~ "ASD",
      ADHD == 1 & (ASD  == 0 | is.na(ASD))  ~ "ADHD",
      TRUE ~ "COMP"
    )),
    gender_desc = gender,
    gender = as.factor(case_when(
      grepl("männlich|male|m|Geb. weiblich", gender_desc, ignore.case = TRUE) ~ "mal",
      grepl("weiblich|female|w|f", gender_desc, ignore.case = TRUE) ~"fem",
      TRUE ~ "dan")
    )
  ) %>%
  relocate(PID, diagnosis, gender) %>%
  rename("subID" = "PID")

# check if someone has to be excluded
nrow(df.sub %>% filter(iq <= 70))

# add the ICD codes
df.sub = df.sub %>%
  mutate(
    ASD.icd10 = case_when(
      diagnosis == "COMP" | diagnosis == "ADHD" ~ '',
      grepl(".0", ASDcode) ~ 'F84.0', # childhood
      grepl(".1", ASDcode) ~ 'F84.1', # atypical
      grepl(".5", ASDcode) ~ 'F84.5'  # asperger
    )
  ) %>% 
  merge(.,
        read_csv(list.files(pattern = ".*_code.csv")) %>%
          select(subID, Code, Group),
        all = T
        ) %>%
  filter(Group != "NOT") %>%
  mutate(
    ASD.icd10 = case_when(
      diagnosis == "COMP" | diagnosis == "ADHD" ~ ASD.icd10,
      !is.na(ASD.icd10) & ASD.icd10 == Code ~ ASD.icd10,
      is.na(ASD.icd10) ~ Code,
      T ~ sprintf("CHECK: %s or %s", Code, ASD.icd10)
    ),
    adhd.meds = case_when(
      grepl("ritalin|methylphenidat|medikinet", meds, ignore.case = T) ~ "methylphenidate",
      grepl("elvan|attentin", meds, ignore.case = T) ~ "amphetamine", 
      grepl("atomoxetin|atofab", meds, ignore.case = T) ~ "atomoxetine"
    ),
    cis       = if_else(as.numeric(cis)==1, "cis", "trans")
  )

# save just the code info to check 
write_csv(df.sub %>% 
            select(date, subID, diagnosis, Code, ASD.icd10) %>% 
            filter(substr(ASD.icd10, 1, 5) == "CHECK"), 
          file = "EMBA_CodeCentraXX.csv")

# save everything
write_csv(df.sub %>% select(-Group, -Code) %>% filter(!is.na(diagnosis)), file = "EMBA_centraXX.csv")
