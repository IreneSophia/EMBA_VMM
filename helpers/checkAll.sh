#!/bin/bash

# go into the directory
cd ../results_ostt

pattern="*tfce_corrp_*.nii.gz"

for file in $pattern
do 
   :
   name="${file%.*}"
   name="${name%.*}"
   echo $name
   # create the cluster text files
   cluster -i $file -t 0 > "${name}_cluster-summary.txt"  
   
done

# go into the directory
cd ../results_tstt

for file in $pattern
do 
   :
   name="${file%.*}"
   name="${name%.*}"
   echo $name
   # create the cluster text files
   cluster -i $file -t 0 > "${name}_cluster-summary.txt"  
   
done
