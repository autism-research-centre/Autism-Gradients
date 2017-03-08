---
layout:     post
title:      "Step 6a - gradients inside standard networks"
subtitle:   "iPython notebook to measure goodness of fit between known networks and gradient maps"
date:       2017-03-08 12:00:00
author:     "Jan Freyberg"
header-img: "img/home-bg.jpg"
categories: notebooks
---

## 6a Calculate gradients inside standard networks

#####  written by J. Freyberg  for the Autism Gradients project at Brainhack Cambridge 2017

__Note: This is a matlab notebook!__

You need to have both a valid matlab installation (2016a or newer) and the python package `matlab_kernel` installed. You also need to have SPM installed.

In the first cell, we transform all of the gradient files into the same voxel space as the standard network maps from neurosynth.


```matlab
% list the correct files:
indivfiles = dir(fullfile(pwd, 'data', 'Outputs', 'individual', '*npy0.nii'));
network_files = dir(fullfile(pwd, 'ROIs_mask', '*FDR_0.01.nii*'));

```


```matlab
%plot native
network_file = fullfile(pwd, 'ROIs_mask', network_files(1).name);

% transform into different voxel space
MatlabFuncs.progressbar(0);
for i = 1:numel(indivfiles)
    gradient_file = fullfile(pwd, 'data', 'Outputs', 'individual', indivfiles(i).name);
    if ~exist(fullfile([gradient_file(1:end-4), 'transformed.nii']))
            MatlabFuncs.Transform_into_the_same_voxelspace(network_file, gradient_file);
    end
    MatlabFuncs.progressbar(i/numel(indivfiles));
end
```

In the next cell, we use the different network files to calculate a goodness-of-fit (ratio between inside-of-the-network to outside-of-the-network).


```matlab
%plot native
% define the inputs
mask_file = fullfile(pwd, 'ROIs_mask', 'rbgmask.nii');
network_files = dir(fullfile(pwd, 'ROIs_mask', '*FDR_0.01.nii*'));

% list the new, transformed files
transformfiles = dir(fullfile(pwd, 'data', 'Outputs', 'individual', '*transformed.nii'));

% reset the goodness of fit result
ratio = [];

MatlabFuncs.progressbar(0);
for inetwork = 1:numel(network_files)
    
    % define network file for this loop
    network_file = fullfile(pwd, 'ROIs_mask', network_files(inetwork).name);
    
    % loop over participants
    for i = 1:numel(transformfiles)
        % update a progbar
        MatlabFuncs.progressbar(((inetwork-1)*numel(transformfiles)+i)/(numel(transformfiles)*numel(network_files)));
        % define gradient for this loop
        gradient_file = fullfile(pwd, 'data', 'Outputs', 'individual', transformfiles(i).name);
        % run the goodness-of-fit analysis
        [ratio(inetwork, i)] = MatlabFuncs.gradient_goodness(gradient_file, network_file, mask_file);
    end
end

```

To avoid having to run everything _again_, we can save the ratio file to disk:


```matlab
save(fullfile(pwd, 'data', 'ratios.mat'), 'ratio');
```

Now, make one big vector that indexes what group people are in


```matlab
phenodata = readtable(fullfile(pwd, 'data', 'Outputs', 'Phenotypic_V1_0b_preprocessed1.csv'));
for i = 1:numel(transformfiles)
    [~, loc] = ismember(transformfiles(i).name(4:end-34), phenodata.FILE_ID(:));
    if loc
        group(i) = phenodata.DX_GROUP(loc);
    else
        group(i) = NaN;
    end
end

```

    Warning: Variable names were modified to make them valid MATLAB identifiers. The original names are saved in the VariableDescriptions property.


In the next cell, I create a boxplot that ranks the networks by fit


```matlab
%plot inline -s 900,1000
network_files = dir(fullfile(pwd, 'ROIs_mask', '*FDR_0.01.nii*'));
[~, sortorder] = sort(median(ratio, 2));
figure;
labels = {network_files(:).name};
for i = 1:numel(labels)
    labels{i} = labels{i}(1:end-23);
end

grouplabels = {'control', 'autism'};
for igroup = 1:2
    subplot(2, 1, igroup);
    boxplot((ratio(sortorder, group==igroup)'), 'orientation', 'horizontal', 'Label', labels(sortorder));
    xlim([0, 300]);
    xlabel('Gradient_i_n_s_i_d_e / Gradient_o_u_t_s_i_d_e of the network');
    title([grouplabels{igroup}, ' group']);
end
% MatlabFuncs.xticklabel_rotate([1:inetwork],90,{network_files(:).name},'interpreter','none')
```


![Figure1](/Autism-Gradients/img/post_imgs/2017-03-05-output_10_0.png)


We can also do this for each bin of the gradient. The bin boundaries (in percentiles) can be given as a last argument to the gradient_goodness function. Note that this will roughly take 10x as long as the previous steps.


```matlab
%plot native
% define the inputs
mask_file = fullfile(pwd, 'ROIs_mask', 'rbgmask.nii');
network_files = dir(fullfile(pwd, 'ROIs_mask', '*FDR_0.01.nii*'));

% list the new, transformed files
transformfiles = dir(fullfile(pwd, 'data', 'Outputs', 'individual', '*transformed.nii'));

% reset the goodness of fit result
binned_ratio = [];

MatlabFuncs.progressbar(0);
a = 0;
for inetwork = 1:numel(network_files)
    
    % define network file for this loop
    network_file = fullfile(pwd, 'ROIs_mask', network_files(inetwork).name);
    
    % loop over participants
    for i = 1:numel(transformfiles)
            % update a progbar
            a = a+1;
            MatlabFuncs.progressbar(a/(numel(network_files)*numel(transformfiles)));
            % define gradient for this loop
            gradient_file = fullfile(pwd, 'data', 'Outputs', 'individual', transformfiles(i).name);
            % run the goodness-of-fit analysis
            [binned_ratio(inetwork, i, 1:10)] = MatlabFuncs.gradient_goodness(gradient_file, network_file, mask_file, true);
    end
end

```

Since this takes for-absolutely-ever, we should save this file so that we don't have to repeat anything!


```matlab
save(fullfile(pwd, 'data', 'binned_ratios.mat'), 'binned_ratio');
```


```matlab
load(fullfile(pwd, 'data', 'binned_ratios.mat'));
```

We can also do the same visualisation as above for these binned results


```matlab
%plot inline -s 2000,1000
% network_files = dir(fullfile(pwd, 'ROIs_mask', '*FDR_0.01.nii*'));
figure;
labels = {network_files(:).name};
for i = 1:numel(labels)
    labels{i} = labels{i}(1:end-23);
end

grouplabels = {'control', 'autism'};

for ibin = 1
figure;
for igroup = 1:2
    
    subplot(1, 2, igroup);
    
    [~, sortorder] = sort(median(binned_ratio(:, group==igroup, ibin), 2));
    disp(binned_ratio(sortorder, group==igroup, ibin)');
    
    boxplot(squeeze(binned_ratio(sortorder, group==igroup, ibin))', 'orientation', 'horizontal', 'Labels', labels(sortorder));
    % xlim([0, 300]);
    xlabel('Gradient_i_n_s_i_d_e / Gradient_o_u_t_s_i_d_e of the network');
    title([grouplabels{igroup}, ' group']);
end
end

```


![Figure](/Autism-Gradients/img/post_imgs/2017-03-05-output_17_0.png)
