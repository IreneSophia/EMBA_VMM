#!/bin/bash

# set our directories
dir_out=$(pwd)
log_file="$dir_out/logfiles/log_runFSL-3.txt"
dir_ostt="$dir_out/results_ostt"
if [ ! -d "$dir_ostt" ]; then
  mkdir -p "$dir_ostt";
fi

nsim=5000

## Hypothesis about neural adaptation

code="SMP_all_cope4"
echo "$(date) start $code" >> "$log_file"

# negative
fslmaths "$dir_out/fMRI_data/$code" -mul -1 "$dir_out/fMRI_data/${code}_neg"
randomise -i "$dir_out/fMRI_data/${code}_neg" -m fMRI_data/ROI_e -o "$dir_ostt/smp_adapt_neg_ROI" -1 -T -n $nsim &

## Explore general and specific neural adaptation

code="SMP_all_cope4"
echo "$(date) start $code" >> "$log_file"

# positive
randomise -i "$dir_out/fMRI_data/$code" -o "$dir_ostt/smp_adapt_pos" -m fMRI_data/WB_mask -1 -T -n $nsim &
# negative
randomise -i "$dir_out/fMRI_data/${code}_neg" -m fMRI_data/WB_mask -o "$dir_ostt/smp_adapt_neg" -1 -T -n $nsim &

code="SMP_all_cope5"
echo "$(date) start $code" >> "$log_file"

# positive
randomise -i "$dir_out/fMRI_data/$code" -o "$dir_ostt/smp_adapt_c_pos" -m fMRI_data/WB_mask -1 -T -n $nsim &
# negative
fslmaths "$dir_out/fMRI_data/$code" -mul -1 "$dir_out/fMRI_data/${code}_neg"
randomise -i "$dir_out/fMRI_data/${code}_neg" -m fMRI_data/WB_mask -o "$dir_ostt/smp_adapt_c_neg" -1 -T -n $nsim &

code="SMP_all_cope6"
echo "$(date) start $code" >> "$log_file"

# positive
randomise -i "$dir_out/fMRI_data/$code" -o "$dir_ostt/smp_adapt_e_pos" -m fMRI_data/WB_mask -1 -T -n $nsim &
# negative
fslmaths "$dir_out/fMRI_data/$code" -mul -1 "$dir_out/fMRI_data/${code}_neg"
randomise -i "$dir_out/fMRI_data/${code}_neg" -m fMRI_data/WB_mask -o "$dir_ostt/smp_adapt_e_neg" -1 -T -n $nsim &

wait

echo "$(date) end for all simple ostts" >> "$log_file"


