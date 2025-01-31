% This script was written by Anna Yurova to model belief trajectories
% regarding colour and emotion to assess prediction strength and 
% prediction error based on the order of stimuli presented to the
% participants. 

clc
clear 
close all

% add tapas toolbox to path
addpath('/home/emba/Documents/EMBA/EMBA_HGF/tapas-master/HGF');

% choose which sequences to run through HGF
sequences = {'01', '05', '07', '08'};
path_input = [pwd filesep 'PLIST_BEST_'];

% loop through the sequences
for s = 1:length(sequences)

    sequence = sequences{s};

    % load the stimulus order
    load(strcat(path_input, sequence, '.mat'));
    
    % Generate color input sequence
    % 1 and 3 - green
    % 2 and 4 - red
    
    inputs = plist(5, :);
    
    color_input = NaN(length(inputs),1);
    emotion_input = NaN(length(inputs), 1);
    
    % color input sequence; green = 0; red = 1
    for i=1:length(inputs)
        if ( (inputs(i) == 1) || (inputs(i) == 3) )
            color_input(i) = 0;
        else
            color_input(i) = 1;
        end
    end 
    
    % emotion input sequence; happy = 0, sad = 1s
    for i=1:length(inputs)
        if ( (inputs(i) == 1) || (inputs(i) == 2) )
            emotion_input(i) = 0;
        else
            emotion_input(i) = 1;
        end
    end 
    
    baseName = pwd;
    
    % use the function to model the 2 level HGF for emotion and colour
    % separately
    r_e = fit_2_level_HGF_model(emotion_input, 'emotion', baseName, sequence);
    r_c = fit_2_level_HGF_model(color_input, 'color', baseName, sequence);
    
    % extract prediction strength and prediction error
    mu_c = r_c.traj.mu(:,2);
    eps_c = r_c.traj.epsi(:,2);
    mu_e = r_e.traj.mu(:,2);
    eps_e = r_e.traj.epsi(:,2);
    output_table = table(mu_c, eps_c, mu_e, eps_e);
    writetable(output_table, strcat(path_input, sequence,'_HGF', '.csv'));

end