%% compare gradients inside a mask to outside the mask
function [ratio, inside, outside, correlate] = gradient_goodness(gradfile, component, mask)
%% comp         -       component to compare
%% comp2compare -       directory of components to compare against
%% mask         -       brainmask
%% plotting     -       logical to set if you want all scatterplots


% use read_avw (fsl?s matlab function) to read in *.nii.gz files
bgmask = logical(read_avw(mask));

[compmap] = logical(read_avw(component));

compcontinuous = read_avw(component);

[gradmap] = read_avw(gradfile);

inside = abs(nanmean(reshape(gradmap(bgmask & compmap), numel(gradmap(bgmask & compmap)), 1))/100);
outside = abs(nanmean(reshape(gradmap(bgmask & ~compmap), numel(gradmap(bgmask & ~compmap)), 1))/100);


% Calculate the ratio between the two
ratio = inside / outside;

correlate = corr(gradmap(bgmask & compmap), compcontinuous(bgmask & compmap));

end