%% create and save histograms 

% start with a clean slate
clearvars
clc

% determine input and output directories
dir_data = '/home/emba/Documents/EMBA/BVET'; 
dir_pics = '/home/emba/Documents/EMBA/VMM_pics';

%% create the data files

% get a list of the participants
subs  = readtable([dir_data filesep 'VMM_ET_inc.csv']);

% declare empty vectors to be filled with coordinates
ASD       = [];
ADHD      = [];
COMP      = [];

% set some options to load the data
opts = delimitedTextImportOptions("NumVariables", 3);
opts.Delimiter = "\t";
opts.VariableNames = ["timepoints", "x", "y"];
opts.SelectedVariableNames = ["timepoints", "x", "y"];
opts.VariableTypes = ["double", "char", "char"];

% loop through all the subjects to create data files
for j = 1:height(subs)

    % display subID
    disp(subs.subID{j})

    % check if this has already been done
    if exist([dir_pics filesep 'VMM_sub-' subs.subID{j} '.mat'], 'file')

        load([dir_pics filesep 'VMM_sub-' subs.subID{j} '.mat'])

    else

        % load the data
        tbl = readtable([dir_data filesep subs.shortname{j}], opts);
    
        % get rid of blinks and messages and only keep pixel locations
        tbl = tbl(~isnan(tbl.timepoints),1:3);
    
        % convert to numbers
        tbl.x = str2double(strrep(tbl.x, ',', '.'));
        tbl.y = str2double(strrep(tbl.y, ',', '.'));
    
        % at to matrix
        if j > 1
            if strcmp(subs.subID{j}, subs.subID{j-1})
                mtx = [mtx; tbl.x tbl.y];
            else 
                mtx = [tbl.x tbl.y];
            end
        else
            mtx = [tbl.x tbl.y];
        end
    
        % save the matrix
        save([dir_pics filesep 'VMM_sub-' subs.subID{j} '.mat'], 'mtx')

    end

    % add to group matrix
    if strcmpi(subs.diagnosis{j}, 'ADHD')
        ADHD = [ADHD; mtx];
    elseif strcmpi(subs.diagnosis{j}, 'ASD')
        ASD = [ASD; mtx];
    else
        COMP = [COMP; mtx];
    end

end

% save the matrices
save([dir_pics filesep 'VMM_ADHD.mat'], 'ADHD');
save([dir_pics filesep 'VMM_ASD.mat'],  'ASD');
save([dir_pics filesep 'VMM_COMP.mat'], 'COMP');

%% create the heatmaps

files = dir([dir_pics filesep 'VMM_sub*.mat']);

for j = 1:length(files)

    [~,~] = heatmap_generator_ISP( ...
        [files(j).folder filesep files(j).name], ...      # file with data
        [dir_pics filesep 'task_blurred_AOI.jpg'], ... # scene image
        25, ...            # spacing: interval to define heatmap density
        1024, ...          # maximum horizontal value of tracker coordinate system
        768, ...           # maximum vertical value of tracker coordinate system
        6, ...             # kernel size for gaussian filtering
        3 ...              # sigma for gaussian filtering
        );

    saveas(gcf, [dir_pics filesep extractBefore(files(j).name, '.') '_heatmap.png']);
    close all;

end

scene = [dir_pics filesep 'task_blurred_AOI.jpg'];
[~,~] = heatmap_generator_ISP( ...
    [dir_pics filesep 'VMM_ADHD.mat'], ...      # file with data
    scene, ...         # scene image
    25, ...            # spacing: interval to define heatmap density
    1024, ...          # maximum horizontal value of tracker coordinate system
    768, ...           # maximum vertical value of tracker coordinate system
    6, ...             # kernel size for gaussian filtering
    3 ...              # sigma for gaussian filtering
    );
saveas(gcf, [dir_pics filesep 'VMM_ADHD_heatmap.png']);

[~,~] = heatmap_generator_ISP( ...
    [dir_pics filesep 'VMM_ASD.mat'], ...      # file with data
    scene, ...         # scene image
    25, ...            # spacing: interval to define heatmap density
    1024, ...          # maximum horizontal value of tracker coordinate system
    768, ...           # maximum vertical value of tracker coordinate system
    6, ...             # kernel size for gaussian filtering
    3 ...              # sigma for gaussian filtering
    );
saveas(gcf, [dir_pics filesep 'VMM_ASD_heatmap.png']);

[~,~] = heatmap_generator_ISP( ...
    [dir_pics filesep 'VMM_COMP.mat'], ...      # file with data
    scene, ...         # scene image
    25, ...            # spacing: interval to define heatmap density
    1024, ...          # maximum horizontal value of tracker coordinate system
    768, ...           # maximum vertical value of tracker coordinate system
    6, ...             # kernel size for gaussian filtering
    3 ...              # sigma for gaussian filtering
    );
saveas(gcf, [dir_pics filesep 'VMM_COMP_heatmap.png']);
close all;

scene = '';
[~,~] = heatmap_generator_ISP( ...
    [dir_pics filesep 'VMM_ADHD.mat'], ...      # file with data
    scene, ...         # scene image
    25, ...            # spacing: interval to define heatmap density
    1024, ...          # maximum horizontal value of tracker coordinate system
    768, ...           # maximum vertical value of tracker coordinate system
    6, ...             # kernel size for gaussian filtering
    3 ...              # sigma for gaussian filtering
    );
saveas(gcf, [dir_pics filesep 'VMM_ADHD_heatmap_empty.png']);

[~,~] = heatmap_generator_ISP( ...
    [dir_pics filesep 'VMM_ASD.mat'], ...      # file with data
    scene, ...         # scene image
    25, ...            # spacing: interval to define heatmap density
    1024, ...          # maximum horizontal value of tracker coordinate system
    768, ...           # maximum vertical value of tracker coordinate system
    6, ...             # kernel size for gaussian filtering
    3 ...              # sigma for gaussian filtering
    );
saveas(gcf, [dir_pics filesep 'VMM_ASD_heatmap_empty.png']);

[~,~] = heatmap_generator_ISP( ...
    [dir_pics filesep 'VMM_COMP.mat'], ...      # file with data
    scene, ...         # scene image
    25, ...            # spacing: interval to define heatmap density
    1024, ...          # maximum horizontal value of tracker coordinate system
    768, ...           # maximum vertical value of tracker coordinate system
    6, ...             # kernel size for gaussian filtering
    3 ...              # sigma for gaussian filtering
    );
saveas(gcf, [dir_pics filesep 'VMM_COMP_heatmap_empty.png']);
close all;
