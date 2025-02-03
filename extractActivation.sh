#!/bin/bash

dir_data="fMRI_data"
dir_out="results_sig"
if [ ! -d "$dir_out" ]; then
  mkdir -p "$dir_out";
fi

# first, create the masks for all the clusters

fslmaths $dir_out/hgf_all_eps_c_ROI_fstat1_thresholded_summary.nii.gz -thr 7 -uthr 7 $dir_data/ROI_hgf_all_eps_c_C7

fslmaths $dir_out/hgf_all_eps_c_ROI_fstat1_thresholded_summary.nii.gz -thr 6 -uthr 6 $dir_data/ROI_hgf_all_eps_c_C6

fslmaths $dir_out/hgf_all_eps_c_ROI_fstat1_thresholded_summary.nii.gz -thr 5 -uthr 5 $dir_data/ROI_hgf_all_eps_c_C5

fslmaths $dir_out/hgf_all_eps_c_ROI_fstat1_thresholded_summary.nii.gz -thr 4 -uthr 4 $dir_data/ROI_hgf_all_eps_c_C4

fslmaths $dir_out/hgf_all_mu_c_ROI_fstat1_thresholded_summary.nii.gz -thr 3 -uthr 3 $dir_data/ROI_hgf_all_mu_c_C3

fslmaths $dir_out/hgf_all_mu_c_ROI_fstat1_thresholded_summary.nii.gz -thr 4 -uthr 4 $dir_data/ROI_hgf_all_mu_c_C4

fslmaths $dir_out/hgf_all_mu_c_ROI_fstat1_thresholded_summary.nii.gz -thr 5 -uthr 5 $dir_data/ROI_hgf_all_mu_c_C5

fslmaths $dir_out/hgf_all_mu_c_ROI_fstat1_thresholded_summary.nii.gz -thr 6 -uthr 6 $dir_data/ROI_hgf_all_mu_c_C6

fslmaths $dir_out/hgf_all_mu_c_ROI_fstat1_thresholded_summary.nii.gz -thr 7 -uthr 7 $dir_data/ROI_hgf_all_mu_c_C7

fslmaths $dir_out/hgf_all_mu_e_ROI_fstat1_thresholded_summary.nii.gz -thr 4 -uthr 4 $dir_data/ROI_hgf_all_mu_e_C4

fslmaths $dir_out/hgf_all_mu_e_ROI_fstat1_thresholded_summary.nii.gz -thr 3 -uthr 3 $dir_data/ROI_hgf_all_mu_e_C3

fslmaths $dir_out/hgf_all_mu_e_ROI_fstat1_thresholded_summary.nii.gz -thr 2 -uthr 2 $dir_data/ROI_hgf_all_mu_e_C2

# then, extract the activation from all participants and save it to files

fslmeants -i $dir_data/HGF_all_zstat4.nii.gz -o $dir_data/eps_c_C7_meants.txt -m $dir_data/ROI_hgf_all_eps_c_C7

fslmeants -i $dir_data/HGF_all_zstat4.nii.gz -o $dir_data/eps_c_C6_meants.txt -m $dir_data/ROI_hgf_all_eps_c_C6

fslmeants -i $dir_data/HGF_all_zstat4.nii.gz -o $dir_data/eps_c_C5_meants.txt -m $dir_data/ROI_hgf_all_eps_c_C5

fslmeants -i $dir_data/HGF_all_zstat4.nii.gz -o $dir_data/eps_c_C4_meants.txt -m $dir_data/ROI_hgf_all_eps_c_C4

fslmeants -i $dir_data/HGF_all_zstat6.nii.gz -o $dir_data/mu_c_C3_meants.txt -m $dir_data/ROI_hgf_all_mu_c_C3

fslmeants -i $dir_data/HGF_all_zstat6.nii.gz -o $dir_data/mu_c_C4_meants.txt -m $dir_data/ROI_hgf_all_mu_c_C4

fslmeants -i $dir_data/HGF_all_zstat6.nii.gz -o $dir_data/mu_c_C5_meants.txt -m $dir_data/ROI_hgf_all_mu_c_C5

fslmeants -i $dir_data/HGF_all_zstat6.nii.gz -o $dir_data/mu_c_C6_meants.txt -m $dir_data/ROI_hgf_all_mu_c_C6

fslmeants -i $dir_data/HGF_all_zstat6.nii.gz -o $dir_data/mu_c_C7_meants.txt -m $dir_data/ROI_hgf_all_mu_c_C7

fslmeants -i $dir_data/HGF_all_zstat7.nii.gz -o $dir_data/mu_e_C4_meants.txt -m $dir_data/ROI_hgf_all_mu_e_C4

fslmeants -i $dir_data/HGF_all_zstat7.nii.gz -o $dir_data/mu_e_C3_meants.txt -m $dir_data/ROI_hgf_all_mu_e_C3

fslmeants -i $dir_data/HGF_all_zstat7.nii.gz -o $dir_data/mu_e_C2_meants.txt -m $dir_data/ROI_hgf_all_mu_e_C2

fslmeants -i $dir_data/SMP_all_zstat4.nii.gz -o $dir_data/adapt_meants.txt -m $dir_out/smp_adapt_neg_ROI_tstat1_thresholded_summary.nii.gz
