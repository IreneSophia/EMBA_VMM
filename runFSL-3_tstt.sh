#!/bin/bash

# set our directories
dir_out=$(pwd)
log_file="$dir_out/logfiles/log_runFSL-3.txt"
dir_tstt="$dir_out/results_tstt/"
if [ ! -d "$dir_tstt" ]; then
  mkdir -p "$dir_tstt";
fi

nsim=5000

## Start with the hypotheses

hyp=1

if [ $hyp == 1 ]; then

	code="SMP_all_cope6"
	echo "$(date) start tstt $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_tstt/smp_adapt_e_ROI" -d "$dir_out/fMRI_designs/glm_tstt.mat" -t "$dir_out/fMRI_designs/glm_tstt.con" -m fMRI_data/ROI_e -T -n $nsim &
	
	code="HGF_all_cope4"
	echo "$(date) start tstt $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_tstt/hgf_eps_c_ROI" -d "$dir_out/fMRI_designs/glm_tstt.mat" -t "$dir_out/fMRI_designs/glm_tstt.con" -m fMRI_data/ROI_c -T -n $nsim &
	
	code="HGF_all_cope5"
	echo "$(date) start tstt $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_tstt/hgf_eps_e_ROI" -d "$dir_out/fMRI_designs/glm_tstt.mat" -t "$dir_out/fMRI_designs/glm_tstt.con" -m fMRI_data/ROI_e -T -n $nsim &
	
fi

## Explore whole-brain

exp=1

if [ $exp == 1 ]; then

	code="SMP_all_cope6"
	echo "$(date) start tstt $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_tstt/smp_adapt_e" -d "$dir_out/fMRI_designs/glm_tstt.mat" -t "$dir_out/fMRI_designs/glm_tstt.con" -m fMRI_data/WB_mask -T -n $nsim &
		
	code="SMP_all_cope5"
	echo "$(date) start tstt $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_tstt/smp_adapt_c" -d "$dir_out/fMRI_designs/glm_tstt.mat" -t "$dir_out/fMRI_designs/glm_tstt.con" -m fMRI_data/WB_mask -T -n $nsim &
	
	code="SMP_all_cope4"
	echo "$(date) start tstt $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_tstt/smp_adapt" -d "$dir_out/fMRI_designs/glm_tstt.mat" -t "$dir_out/fMRI_designs/glm_tstt.con" -m fMRI_data/WB_mask -T -n $nsim &
	
	code="HGF_all_cope4"
	echo "$(date) start tstt $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_tstt/hgf_eps_c" -d "$dir_out/fMRI_designs/glm_tstt.mat" -t "$dir_out/fMRI_designs/glm_tstt.con" -m fMRI_data/WB_mask -T -n $nsim &
	
	code="HGF_all_cope5"
	echo "$(date) start tstt $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_tstt/hgf_eps_e" -d "$dir_out/fMRI_designs/glm_tstt.mat" -t "$dir_out/fMRI_designs/glm_tstt.con" -m fMRI_data/WB_mask -T -n $nsim &
	
	code="HGF_all_cope6"
	echo "$(date) start tstt $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_tstt/hgf_mu_c" -d "$dir_out/fMRI_designs/glm_tstt.mat" -t "$dir_out/fMRI_designs/glm_tstt.con" -m fMRI_data/WB_mask -T -n $nsim &
	
	code="HGF_all_cope7"
	echo "$(date) start tstt $code" >> "$log_file"

	randomise -i "$dir_out/fMRI_data/$code" -o "$dir_tstt/hgf_mu_e" -d "$dir_out/fMRI_designs/glm_tstt.mat" -t "$dir_out/fMRI_designs/glm_tstt.con" -m fMRI_data/WB_mask -T -n $nsim &
	
fi

wait

echo "$(date) end for all tstts with contrasts" >> "$log_file"

