#!/bin/bash

# run first level for both runs of each subject

# first, load in the subIDs that should be processed from a space separated file
subs=()
while IFS=$' ' read -r -a line 
do
     subs+=("${line}")
done < "all_use-new"
nos="${#subs[@]}"

# set our directories
dir_out="/home/emba/Documents/EMBA/VMM_analysis/01_FSL"
log_file="/home/emba/Documents/EMBA/VMM_analysis/01_FSL/log_runFSL-1.txt"

# set up parallisation
cores=24
cores="$((cores/2))" # there are 2 tasks per inner loop
starts=($(seq 0 $cores $((nos-1))))

# start with the HGF stuff
echo "$(date) --------------- HGF --------------- " >> "$log_file"
for i in "${starts[@]}"
do
   : 

   # assess the last index in this batch
   if [[ $((i+cores)) > $nos ]]; then
      end=$((nos-1))
   else
      end=$((i+cores-1))
   fi
   
   # loop through all subjects in this batch
   sequ=($(seq $i 1 $end))
   echo "$(date) starting: $i to $end" >> "$log_file"
   for j in "${sequ[@]}"
   do
      :
      sub="sub-${subs[$j]}"
      echo "$(date) starting: $sub" >> "$log_file"

      # run feat
      feat "${dir_out}/${sub}/${sub}_HGF_task-1.fsf" &
      feat "${dir_out}/${sub}/${sub}_HGF_task-2.fsf" &
      
   done
   
   # wait for background to finish
   wait
   
   # print that this batch is finished
   echo "$(date) finished: $i to $end" >> "$log_file"
   
done

# start with the SMP stuff
echo "$(date) --------------- SMP --------------- " >> "$log_file"
for i in "${starts[@]}"
do
   : 

   # assess the last index in this batch
   if [[ $((i+cores)) > $nos ]]; then
      end=$((nos-1))
   else
      end=$((i+cores-1))
   fi
   
   # loop through all subjects in this batch
   sequ=($(seq $i 1 $end))
   echo "$(date) starting: $i to $end" >> "$log_file"
   for j in "${sequ[@]}"
   do
      :
      sub="sub-${subs[$j]}"
      echo "$(date) starting: $sub" >> "$log_file"

      # run feat
      feat "${dir_out}/${sub}/${sub}_SMP_task-1.fsf" &
      feat "${dir_out}/${sub}/${sub}_SMP_task-2.fsf" &
      
   done
   
   # wait for background to finish
   wait
   
   # print that this batch is finished
   echo "$(date) finished: $i to $end" >> "$log_file"
   
done
