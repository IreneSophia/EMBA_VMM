% This function was written by Anna Yurova to use the HGF as implemented 
% in the TAPAS toolbox with 2 levels to model belief trajectories
% regarding colour and emotion to assess prediction strength and 
% prediction error based on the order of stimuli presented to the
% participants. 
% input sequence - vector of binary inputs
% data_type - can be either 'emotion' or 'color'
% impl - implementation type; could be either 'custom' or 'original'

function [r_2level, filename] = fit_2_level_HGF_model(input_sequence, data_type, baseName, sequence)

config_name = strcat('tapas_hgf_binary_k2_0_config_VMM');

r_2level = tapas_fitModel([],...
                         input_sequence,...
                         config_name,...
                         'tapas_bayes_optimal_binary_config',...
                         'tapas_quasinewton_optim_config');

filename = strcat(baseName, filesep, 'PLIST_BEST_', sequence, '_', ...
    data_type, '_mu_', num2str(r_2level.c_prc.mu_0mu(2), 2), ...
    '_logsa0mu_', num2str(r_2level.c_prc.logsa_0mu(2),3), '_omega_', ...
    num2str(r_2level.c_prc.ommu(2), 2));

if (strcmp(data_type, 'color')) 
    plot_color_mu  = 'm';
    plot_color_eps = 'r';
else
    plot_color_mu  = 'b';
    plot_color_eps = 'g';
end 

f = figure;
plot(abs(r_2level.traj.mu(:,2)), 'color', plot_color_mu, 'linewidth', 1.2)
hold on
plot(abs(r_2level.traj.epsi(:,2)), 'color', plot_color_eps, 'linewidth', 1.2)
hold on
plot(5.*input_sequence, '--', 'color', [0.3 0.3 0.3], 'linewidth', 1.2)
fontsize(f, 18, "points");
f.Position = [100 100 1500 300];
legend('\mu_2', '\epsilon_2', 'input', 'Location','NorthEastOutside');
title(strcat('PLIST\_BEST\_', sequence, '\_', data_type));
exportgraphics(f, strcat(filename, '.png'));

close all;

f = figure;
plot(r_2level.traj.mu(:,2), 'color', plot_color_mu, 'linewidth', 1.2)
hold on
plot(r_2level.traj.epsi(:,2), 'color', plot_color_eps, 'linewidth', 1.2)
hold on
plot(5.*input_sequence, '--', 'color', [0.3 0.3 0.3], 'linewidth', 1.2)
fontsize(f, 18, "points");
f.Position = [100 100 1500 300];
legend('\mu_2', '\epsilon_2', 'input', 'Location','NorthEastOutside');
title(strcat('PLIST\_BEST\_raw\_', sequence, '\_', data_type));
exportgraphics(f, strcat(filename, '.png'));

close all;

return
