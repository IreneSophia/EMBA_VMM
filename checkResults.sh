#!/bin/bash

# set our directories
dir_out=$(pwd)
dir_res="$dir_out/results_tstt/"

for FILE in $dir_res/*_tfce_corrp_*.nii.gz
do
   :
   echo $FILE >> 'out_results.txt'
   fslstats $FILE -l 0.95 -V >> 'out_results.txt'
done

dir_res="$dir_out/results_ostt/"

for FILE in $dir_res/*_tfce_corrp_*.nii.gz
do
   :
   echo $FILE >> 'out_results.txt'
   fslstats $FILE -l 0.95 -V >> 'out_results.txt'
done
