library(tidyverse)

text = readLines("out_results.txt")

fln = text[seq(from=1, to=length(text), by=2)]
val = text[seq(from=2, to=length(text), by=2)]

df = data.frame(fln, val) %>%
  # get rid of non-significant results
  filter(val != "0 0.000000 ") %>%
  mutate(
    cov      = if_else(grepl("-cov", fln), "cov", "none"),
    contrast = gsub(".*//(.+).nii.gz$", "\\1", fln),
    # cov of RS has the wrong name
    contrast = if_else(contrast == "smp_adapt_ROI_tfce_corrp_tstat2", 
                       "smp_adapt_neg_ROI_tfce_corrp_tstat1",
                       contrast),
    test    = if_else(grepl("tstt", fln), "tstt", "ostt"),
    ROI      = if_else(grepl("ROI", contrast), T, F),
    fln = NULL
  ) %>%
  pivot_wider(values_from = c(val), names_from = cov)

write_csv(df, "out_results_comparison.csv")
