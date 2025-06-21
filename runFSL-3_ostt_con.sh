#!/bin/bash

# set our directories
dir_out=$(pwd)
log_file="$dir_out/logfiles/log_runFSL-3.txt"
dir_ostt="$dir_out/results_ostt"
if [ ! -d "$dir_ostt" ]; then
  mkdir -p "$dir_ostt";
fi

nsim=5000

## Start with the hypothesis about the control participants

ctr=0

if [ $ctr == 1 ]; then

	code="HGF_ctr_cope4"
	echo "$(date) start $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_ostt/hgf_ctr_eps_c_ROI" -d "$dir_out/fMRI_designs/glm_ctr_ostt-f.mat" -t "$dir_out/fMRI_designs/glm_ctr_ostt-f.con" -f "$dir_out/fMRI_designs/glm_ctr_ostt-f.fts" -m fMRI_data/ROI_c -1 -T -n $nsim &

	code="HGF_ctr_cope5"
	echo "$(date) start $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_ostt/hgf_ctr_eps_e_ROI" -d "$dir_out/fMRI_designs/glm_ctr_ostt-f.mat" -t "$dir_out/fMRI_designs/glm_ctr_ostt-f.con" -f "$dir_out/fMRI_designs/glm_ctr_ostt-f.fts" -m fMRI_data/ROI_e -1 -T -n $nsim &

	code="HGF_ctr_cope6"
	echo "$(date) start $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_ostt/hgf_ctr_mu_c_ROI" -d "$dir_out/fMRI_designs/glm_ctr_ostt-f.mat" -t "$dir_out/fMRI_designs/glm_ctr_ostt-f.con" -f "$dir_out/fMRI_designs/glm_ctr_ostt-f.fts" -m fMRI_data/ROI_c -1 -T -n $nsim &
	
	code="HGF_ctr_cope7"
	echo "$(date) start $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_ostt/hgf_ctr_mu_e_ROI" -d "$dir_out/fMRI_designs/glm_ctr_ostt-f.mat" -t "$dir_out/fMRI_designs/glm_ctr_ostt-f.con" -f "$dir_out/fMRI_designs/glm_ctr_ostt-f.fts" -m fMRI_data/ROI_e -1 -T -n $nsim &
	
fi

## Continue with pooled sample

pooled=1

if [ $pooled == 1 ]; then

	code="HGF_all_cope4"
	echo "$(date) start $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_ostt/hgf_all_eps_c_ROI" -d "$dir_out/fMRI_designs/glm_ostt-f.mat" -t "$dir_out/fMRI_designs/glm_ostt-f.con" -f "$dir_out/fMRI_designs/glm_ostt-f.fts" -m fMRI_data/ROI_e -1 -T -n $nsim &

	code="HGF_all_cope5"
	echo "$(date) start $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_ostt/hgf_all_eps_e_ROI" -d "$dir_out/fMRI_designs/glm_ostt-f.mat" -t "$dir_out/fMRI_designs/glm_ostt-f.con" -f "$dir_out/fMRI_designs/glm_ostt-f.fts" -m fMRI_data/ROI_e -1 -T -n $nsim &

	code="HGF_all_cope6"
	echo "$(date) start $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_ostt/hgf_all_mu_c_ROI" -d "$dir_out/fMRI_designs/glm_ostt-f.mat" -t "$dir_out/fMRI_designs/glm_ostt-f.con" -f "$dir_out/fMRI_designs/glm_ostt-f.fts" -m fMRI_data/ROI_e -1 -T -n $nsim &

	code="HGF_all_cope7"
	echo "$(date) start $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_ostt/hgf_all_mu_e_ROI" -d "$dir_out/fMRI_designs/glm_ostt-f.mat" -t "$dir_out/fMRI_designs/glm_ostt-f.con" -f "$dir_out/fMRI_designs/glm_ostt-f.fts" -m fMRI_data/ROI_e -1 -T -n $nsim &
	
fi

echo "$(date) end for all ostts with contrasts" >> "$log_file"

