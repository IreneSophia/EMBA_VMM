# script to divide log files properly
library(tidyverse)

# figure out which files need to be converted
fl.path = paste('/home/emba/Documents/EMBA', 'BVET', sep = "/")                 # file path
fls.log = list.files(path = fl.path, pattern = "*\\.log$", full.names = F)      # get all log files
fls.log = substr(fls.log, 1, nchar(fls.log)-4)                                  # get rid of file extension
fls.tsv = list.files(path = fl.path, pattern = "*\\.tsv$", full.names = F)      # get all converted files
fls.tsv = substr(fls.tsv, 1, nchar(fls.tsv)-4)                                  # get rid of file extension
fls = paste(fl.path, "/", setdiff(fls.log,fls.tsv), ".log", sep = "")           # which files have not been converted yet?

# convert them
for (fl in fls) {
  log = readLines(fl)
  idx = which(log == "Event Type	Code	Type	Response	RT	RT Uncertainty	Time	Uncertainty	Duration	Uncertainty	ReqTime	ReqDur") - 3
  rows = c(4,5:idx)
  log_rel = log[rows]
  write_lines(log_rel, file = paste(substr(fl,1,(nchar(fl)-4)), "tsv", sep = "."))
}
