#!/bin/bash

## ORIGINAL RESULTS

# set our directories
cd ..
dir_ostt="results_ostt"
dir_out="results_sig"
if [ ! -d "$dir_out" ]; then
  mkdir -p "$dir_out";
fi

codes=( "hgf_all_eps_c_ROI" "hgf_all_mu_c_ROI" "hgf_all_mu_e_ROI" "hgf_ctr_eps_c_ROI" "hgf_ctr_mu_c_ROI" "hgf_ctr_mu_e_ROI" )
con="fstat1"

for code in "${codes[@]}"
do 
   :
   
   # copy all files
   cp "$dir_ostt/${code}_tfce_corrp_$con.nii.gz" "$dir_out/${code}_tfce_corrp_$con.nii.gz"
   cp "$dir_ostt/${code}_$con.nii.gz" "$dir_out/${code}_$con.nii.gz"
      
   # threshold the file
   fslmaths "$dir_out/${code}_tfce_corrp_$con.nii.gz" -thr 0.95 -bin -mul "$dir_out/${code}_$con.nii.gz" "$dir_out/${code}_${con}_thresholded.nii.gz"
   
   # create the cluster nii files
   cluster -i "$dir_out/${code}_${con}_thresholded.nii.gz" -t 0.0001 -o "$dir_out/${code}_${con}_thresholded_summary" --olmax="$dir_out/${code}_${con}_randomise-output_local-max.txt" --osize="$dir_out/${code}_${con}_randomise-output_cluster-size" > "$dir_out/${code}_${con}_randomise_output_all.txt"
      
   # create the cluster text files
   cluster -i "$dir_out/${code}_tfce_corrp_$con.nii.gz" -t 0.95 --scalarname="1-p" > "$dir_out/${code}_${con}_cluster-summary.txt"  
      
done

code="smp_adapt_neg_ROI"
con="tstat1"

# copy all files
cp "$dir_ostt/${code}_tfce_corrp_$con.nii.gz" "$dir_out/${code}_tfce_corrp_$con.nii.gz"
cp "$dir_ostt/${code}_$con.nii.gz" "$dir_out/${code}_$con.nii.gz"

# threshold the file
fslmaths "$dir_out/${code}_tfce_corrp_$con.nii.gz" -thr 0.95 -bin -mul "$dir_out/${code}_$con.nii.gz" "$dir_out/${code}_${con}_thresholded.nii.gz"

# create the cluster nii files
cluster -i "$dir_out/${code}_${con}_thresholded.nii.gz" -t 0.0001 -o "$dir_out/${code}_${con}_thresholded_summary" --olmax="$dir_out/${code}_${con}_randomise-output_local-max.txt" --osize="$dir_out/${code}_${con}_randomise-output_cluster-size" > "$dir_out/${code}_${con}_randomise_output_all.txt"

# create the cluster text files
cluster -i "$dir_out/${code}_tfce_corrp_$con.nii.gz" -t 0.95 --scalarname="1-p" > "$dir_out/${code}_${con}_cluster-summary.txt"  

