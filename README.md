# EMBA: using the Bayesian Brain to investigate the specificity of emotion recognition differences in autism and ADHD

Mutual social interactions require people to be aware of the affective state of their counterpart. An important source for this is facial expressions, which can be indicative of the emotions experienced by the other person. Individuals with autism spectrum disorder (ASD) often have difficulties with this function. Despite the extensive documentation of such differences, it is still unclear which processes underlie attenuated emotion recognition in ASD. In this project, we aim to use a prominent human brain theory called the Bayesian Brain to evaluate the impact of three mechanisms on emotion recognition in individuals with ASD at the neural and behavioural levels: (1) emotional face processing, (2) learning of associations between contextual cues and facial expressions associated with emotions, and (3) biased attention for faces. We also plan to include individuals with attention deficit hyperactivity disorder (ADHD) as clinical controls in addition to a sample of people with no neurodevelopmental disorder. This allows us to determine whether differences in emotion recognition can be attributed to attentional deficits or are unspecific for the included developmental disorders. The results of this project will not only shed more light on the causes of deficits in emotion recognition in people with ASD, but also provide the basis for developing a model of the similarities and differences in processes of the Bayesian Brain in neurodevelopmental disorders.

## Visual mismatch (VMM)

In this repository, we will focus on neural correlates of a visual mismatch (VMM) paradigm, which is used while in the functional magnetic resonance imaging (fMRI) scanner. The paradigm was modelled after Stefanics and colleagues (Stefanics et al., 2019). Participants’ task is to react as fast as possible to changes in the fixation cross. Around the fixation cross, four faces are shown for a short duration. These faces all express the same emotion (fear, happiness) and are all coloured in green or pink. The same emotion and colour are used several times in a row, leading to repetition suppression. When a switch from one emotion or colour to the other happens, a prediction error is produced. We are interested in these prediction errors in response to colours and emotions and how they vary in participants with ADHD or ASD. We will compare three groups (ADHD vs. ASD vs. comparison group without any psychiatric disorders, COMP). 

Participants also perform three additional paradigms: a dot-probe task to measure face attention bias (FAB), a probabilistic learning paradigm (PAL) and a visual mismatch task (VMM). The preregistrations for this project are on [OSF](https://osf.io/znrht) and currently embargoed as the data collection is still ongoing. The preregistrations will be made public when manuscripts are submitted. 

This repository is a work in progress. The script are continuously augmented.

## Repository folders

* `_brms_models`     : contains the models computed with brms for the behavioural analysis, created when running `S1_VMM_behavioural.Rmd`
* `_brms_SBC_cache`  : simulation-based calibration for the behavioural analysis, created when running `S1_VMM_behavioural.Rmd`
* `experiment`       : scripts needed to run the experiment in NBS Presentation
* `fMRI_data`        : ROIs used in the fMRI analysis; concatenated participant output from the second level analysis in FSL (both COPE and zstat files), which is in turn used to run the third level analysis; extracted activation based on the clusters for the offline analysis
* `fMRI_designs`     : FSL designs used for the third level analysis 
* `heatmaps`         : heatmaps of eye-tracking coordinates for the three groups separately
* `helpers`          : helper functions to run extensive simulation-based calibration; interpret and extract results from the FSL analysis
* `HGF_sequence`     : scripts so model the participant-unspecific belief states entered into the FSL models on the first level; relies on TAPAS toolbox; we used version 7.1
* `MRIQC_output`     : MRI quality control of the included data in this analysis
* `prepro`           : scripts to extract timing and parametric modulators for the first level analysis in FSL; bash scripts to run the first and second level analysis in FSL including the design files which were adjusted for the respective participant; preprocessing of the behavioural and eye-tracking data including creating the heatmaps
* `results_ostt`     : nifti files with the results of the third level analysis in FSL focusing on task effects either in the comparison group only or in the pooled sample of all groups
* `results_sig`      : thresholded files and output tables for the significant effects in `results_ostt` and `results_tstt`
* `results_tstt`     : nifti files with the results of the third level analysis in FSL comparing groups

## How to run this analysis

This repository includes scripts for the presentation of the paradigm, preprocessing of the data and analysis. Due to privacy issues, we only share preprocessed and anonymised data. Therefore, only the following analysis RMarkdown scripts can actually be run based on this repository: 

* `S1_VMM_behavioural.Rmd`  : behavioural analysis including the dwell times
* `S2_VMM_neuroimaging.Rmd` : additional information on the fMRI preprocessing as well as offline group comparisons of the effects to extract Bayes Factors

There are some absolute paths in these scripts within if statements. Downloading everything in this repository should ensure that these are not executed. 

We also share the models and the results of the simulation-based calibration. **Rerunning these, especially the SBC, can take longer depending on the specific model.** Runtime of the scripts using the models and SBC shared in this repository should only take a few minutes. The scripts will create all relevant output that was used in the manuscript. If you need access to other data associated with this project or want to use the stimuli / paradigm, please contact the project lead (Irene Sophia Plank, 10planki@gmail.com). 

Additionally, the third level analysis of the FSL analysis can be run by using the followig script: 
* To be added. 

### Belief trajectory extraction with the HGF implemented in the TAPAS toolbox

This extraction was done by Anna Yurova. The stimulus orders were kindly provided by the original authors of Stefanics et al. (2019). Using the HGF requires to download the TAPAS toolbox (we used version 7.1) and replace the path in `runHGF.m` with the correct path. The config file of the `tapas_hgf_binary_config` was rewritten and is shared here as `tapas_hgf_binary_k2_0_config_VMM.m`. Specifically, the config file was adjusted to essentially change the three-level to a two-level HGF by setting kappa_2 to 0, thereby cutting off the third level from any information. Additionally, we set the variance of mu_3 and omega_3 to 0 to stop the optimisation algorithm from attempting to estimate these parameters. This approach was suggested to us by Mathys, see https://github.com/translationalneuromodeling/tapas/issues/260.

### Versions and installation

Each PDF file contains an output of the versions used to run that particular script. It is important to install all packages mentioned in the file before running a specific analysis file. Not all packages can be installed with `install.packages`, please consult the respective installation pages of the packages for more information. If the models are rerun, ensure a valid cmdstanr installation. 

To render the RMarkdown file as a PDF, an installation of pdflatex is mandatory. 

We used MATLAB R2023a for preprocessing of the eye tracking data as well as for the HGF application via the TAPAS toolbox. 

## Variables

To be added. 

## Result files

To be added. 

## Project members

* Project lead: Irene Sophia Plank
* NEVIA lab PI: Christine M. Falter-Wagner
* Project members (alphabetically): Krasniqi, Kaltrina; Nowak, Julia; Papazov, Boris; Pior, Alexandra; Zhuanghua, Shi; Yurova, Anna

## Licensing

GNU GENERAL PUBLIC LICENSE
