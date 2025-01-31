# -*- coding: utf-8 -*-
"""
Created on Thu Jan  9 18:24:21 2025

@author: Oswin
"""

from nilearn import image
import pandas
import glob


# get the AAL information and nii file
aal      = image.get_data('AAL3v1_resampled.nii.gz')
aalnames = pandas.read_csv('AAL3v1.csv')

# get list of all relevant text files
pattern = '_randomise-output_local-max.txt'
ls_files = glob.glob('results_sig/*' + pattern)


# loop through files
for file in ls_files:

    # get the FSL output
    df = pandas.read_csv(file, sep='\t')
    
    df['MNIx']  = (df['x'] - 45)*2
    df['MNIy']  = (df['y'] - 63)*2
    df['MNIz']  = (df['z'] - 36)*2
    ls_aalno   = list()
    ls_aalname = list()
    
    # loop through the local maxima
    for i, row in df.iterrows():
        temp_no = int(aal[int(row['x']), int(row['y']), int(row['z'])])
        ls_aalno.append(temp_no)
        ls_aalname.append(aalnames['name'].iloc[aalnames.isin([temp_no]).any(axis=1).idxmax()])
        
    df['AALno']   = ls_aalno
    df['AALname'] = ls_aalname
    
    df.to_csv(file.replace(pattern,"")+'_MNI-AAL.csv')
