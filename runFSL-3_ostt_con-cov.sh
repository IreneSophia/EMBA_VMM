#!/bin/bash

# set our directories
dir_out=$(pwd)
log_file="$dir_out/log_runFSL-3.txt"
dir_ostt="$dir_out/results_ostt-cov"
if [ ! -d "$dir_ostt" ]; then
  mkdir -p "$dir_ostt";
fi

nsim=5000

## Start with neural adaptation

ada=1

if [ $ada == 1 ]; then

	code="SMP_all_cope4"
	echo "$(date) start $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_ostt/smp_adapt_ROI" -d "$dir_out/fMRI_designs/glm_ostt-cov-f.mat" -t "$dir_out/fMRI_designs/glm_ostt-cov-f.con" -f "$dir_out/fMRI_designs/glm_ostt-cov-f.fts" -m fMRI_data/ROI_e -1 -T -n $nsim &

	code="SMP_all_cope4"
	echo "$(date) start $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_ostt/smp_adapt" -d "$dir_out/fMRI_designs/glm_ostt-cov-f.mat" -t "$dir_out/fMRI_designs/glm_ostt-cov-f.con" -f "$dir_out/fMRI_designs/glm_ostt-cov-f.fts" -m fMRI_data/WB_mask -1 -T -n $nsim &

	code="SMP_all_cope5"
	echo "$(date) start $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_ostt/smp_adapt_c" -d "$dir_out/fMRI_designs/glm_ostt-cov-f.mat" -t "$dir_out/fMRI_designs/glm_ostt-cov-f.con" -f "$dir_out/fMRI_designs/glm_ostt-cov-f.fts" -m fMRI_data/WB_mask -1 -T -n $nsim &
	
	code="SMP_all_cope6"
	echo "$(date) start $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_ostt/smp_adapt_e" -d "$dir_out/fMRI_designs/glm_ostt-cov-f.mat" -t "$dir_out/fMRI_designs/glm_ostt-cov-f.con" -f "$dir_out/fMRI_designs/glm_ostt-cov-f.fts" -m fMRI_data/WB_mask -1 -T -n $nsim &
	
fi

## HGF in the pooled sample

pooled=1

if [ $pooled == 1 ]; then

	code="HGF_all_cope4"
	echo "$(date) start $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_ostt/hgf_all_eps_c_ROI" -d "$dir_out/fMRI_designs/glm_ostt-cov-f.mat" -t "$dir_out/fMRI_designs/glm_ostt-cov-f.con" -f "$dir_out/fMRI_designs/glm_ostt-cov-f.fts" -m fMRI_data/ROI_e -1 -T -n $nsim &

	code="HGF_all_cope5"
	echo "$(date) start $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_ostt/hgf_all_eps_e_ROI" -d "$dir_out/fMRI_designs/glm_ostt-cov-f.mat" -t "$dir_out/fMRI_designs/glm_ostt-cov-f.con" -f "$dir_out/fMRI_designs/glm_ostt-cov-f.fts" -m fMRI_data/ROI_e -1 -T -n $nsim &

	code="HGF_all_cope6"
	echo "$(date) start $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_ostt/hgf_all_mu_c_ROI" -d "$dir_out/fMRI_designs/glm_ostt-cov-f.mat" -t "$dir_out/fMRI_designs/glm_ostt-cov-f.con" -f "$dir_out/fMRI_designs/glm_ostt-cov-f.fts" -m fMRI_data/ROI_e -1 -T -n $nsim &

	code="HGF_all_cope7"
	echo "$(date) start $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_ostt/hgf_all_mu_e_ROI" -d "$dir_out/fMRI_designs/glm_ostt-cov-f.mat" -t "$dir_out/fMRI_designs/glm_ostt-cov-f.con" -f "$dir_out/fMRI_designs/glm_ostt-cov-f.fts" -m fMRI_data/ROI_e -1 -T -n $nsim &
	
fi

echo "$(date) end for all ostts with contrasts" >> "$log_file"

