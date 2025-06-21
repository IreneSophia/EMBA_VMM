#!/bin/bash

# set our directories
cd ..
dir_out=$(pwd)
dir_res="$dir_out/results_tstt/"
dir_hel="$dir_out/helpers/"

for FILE in $dir_res/*_tfce_corrp_*.nii.gz
do
   :
   echo $FILE >> "$dir_hel/out_results.txt"
   fslstats $FILE -l 0.95 -V >> "$dir_hel/out_results.txt"
done

dir_res="$dir_out/results_ostt/"

for FILE in $dir_res/*_tfce_corrp_*.nii.gz
do
   :
   echo $FILE >> "$dir_hel/out_results.txt"
   fslstats $FILE -l 0.95 -V >> "$dir_hel/out_results.txt"
done

dir_res="$dir_out/results_tstt-cov/"

for FILE in $dir_res/*_tfce_corrp_*.nii.gz
do
   :
   echo $FILE >> "$dir_hel/out_results.txt"
   fslstats $FILE -l 0.95 -V >> "$dir_hel/out_results.txt"
done
