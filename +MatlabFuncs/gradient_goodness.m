%% compare gradients inside a mask to outside the mask
function [ratio] = gradient_goodness(gradfile, component, mask, bin)
%% comp         -       component to compare
%% comp2compare -       directory of components to compare against
%% mask         -       brainmask
%% plotting     -       logical to set if you want all scatterplots


% use read_avw (fsl?s matlab function) to read in *.nii.gz files
bgmask = logical(read_avw(mask));

[compmap] = logical(read_avw(component));
compmap = reshape(compmap, [numel(compmap), 1]);

% compcontinuous = read_avw(component);

[gradmap] = read_avw(gradfile);
gradmap(~bgmask) = NaN;
gradmap = reshape(gradmap, [numel(gradmap), 1]);

% Loop over bins if required
if ~isempty(bin) && bin
    for ibin = 1:10
        boundaries = prctile(gradmap, [ibin-1, ibin]*10);
        inside = abs(nanmean(gradmap(compmap & gradmap>min(boundaries) & gradmap<max(boundaries))));
        outside = abs(nanmean(gradmap(~compmap & gradmap>min(boundaries) & gradmap<max(boundaries))));
        ratio(ibin) = inside / outside;
    end
else
    inside = abs(nanmean(gradmap(compmap)));
    outside = abs(nanmean(gradmap(~compmap)));
    ratio = inside / outside;
end


% correlate = corr(gradmap(bgmask & compmap), compcontinuous(bgmask & compmap));

end