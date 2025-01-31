#!/bin/bash

# registration has been done in fMRIPrep > following Mumford's workaround:
# https://mumfordbrainstats.tumblr.com/post/166054797696/feat-registration-workaround

subs=( "" )

dir_out="/home/emba/Documents/EMBA/VMM_analysis/01_FSL"

for sub in "${subs[@]}"
do
   : 
   
   rm "$dir_out/sub-$sub/sub-${sub}_HGF_task-1.feat/reg/example_func2standard.mat"
   rm "$dir_out/sub-$sub/sub-${sub}_HGF_task-1.feat/reg/standard2example_func.mat"
   rm "$dir_out/sub-$sub/sub-${sub}_HGF_task-2.feat/reg/example_func2standard.mat"
   rm "$dir_out/sub-$sub/sub-${sub}_HGF_task-2.feat/reg/standard2example_func.mat"
   rm "$dir_out/sub-$sub/sub-${sub}_SMP_task-1.feat/reg/example_func2standard.mat"
   rm "$dir_out/sub-$sub/sub-${sub}_SMP_task-1.feat/reg/standard2example_func.mat"
   rm "$dir_out/sub-$sub/sub-${sub}_SMP_task-2.feat/reg/example_func2standard.mat"
   rm "$dir_out/sub-$sub/sub-${sub}_SMP_task-2.feat/reg/standard2example_func.mat"
   
   cp $FSLDIR/etc/flirtsch/ident.mat "$dir_out/sub-$sub/sub-${sub}_HGF_task-1.feat/reg/example_func2standard.mat"
   cp $FSLDIR/etc/flirtsch/ident.mat "$dir_out/sub-$sub/sub-${sub}_HGF_task-2.feat/reg/example_func2standard.mat"
   cp $FSLDIR/etc/flirtsch/ident.mat "$dir_out/sub-$sub/sub-${sub}_SMP_task-1.feat/reg/example_func2standard.mat"
   cp $FSLDIR/etc/flirtsch/ident.mat "$dir_out/sub-$sub/sub-${sub}_SMP_task-2.feat/reg/example_func2standard.mat"
   
   cp "$dir_out/sub-$sub/sub-${sub}_HGF_task-1.feat/mean_func.nii.gz" "$dir_out/sub-$sub/sub-${sub}_HGF_task-1.feat/reg/standard.nii.gz"
   cp "$dir_out/sub-$sub/sub-${sub}_HGF_task-2.feat/mean_func.nii.gz" "$dir_out/sub-$sub/sub-${sub}_HGF_task-2.feat/reg/standard.nii.gz"
   cp "$dir_out/sub-$sub/sub-${sub}_SMP_task-1.feat/mean_func.nii.gz" "$dir_out/sub-$sub/sub-${sub}_SMP_task-1.feat/reg/standard.nii.gz"
   cp "$dir_out/sub-$sub/sub-${sub}_SMP_task-2.feat/mean_func.nii.gz" "$dir_out/sub-$sub/sub-${sub}_SMP_task-2.feat/reg/standard.nii.gz"
   
done
