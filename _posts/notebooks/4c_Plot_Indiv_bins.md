
## Step 4c - Visualize the binned gradients

#### Write out of individual Nifti files for each percentile bin of the primary gradient

#####  written by R. Farahibozorg  for the Autism Gradients project at Brainhack Cambridge 2017


```python
# first import the input list from the csv file
import pandas as pd
# read in csv
df_phen = pd.read_csv('./data/SelectedSubjects.csv')
selected = list(df_phen.filename_npy)
```


```python
import matplotlib.pylab as plt
import nilearn
import nilearn.plotting
import os
import numpy as np
import nibabel as nib
##create path to save the output
out_pathbase='./data/Outputs/Bins/'
if not os.path.exists(out_pathbase):
    os.makedirs(out_pathbase)
```


```python
def rebuild_nii_indv_bins(num,subs,bins):
    thisfile=[selected[ii] for ii in subs]
    
    for sub in thisfile:
        print(sub)
        data = np.load('./data/Outputs/Regs/%s' % sub)
        a = data[:,num].copy()
        steps=int((1/float(bins))*len(a))
        data_argsort=np.argsort(a)[::-1]
        nim = nib.load('./ROIs_Mask/cc400_roi_atlas.nii')
        imdat=nim.get_data().astype('float')
        for thisperc in range(bins):            
            #print a
            #print data_argsort
            abin=np.zeros(a.shape)#a.copy()
            abin[data_argsort[thisperc*steps:(thisperc+1)*steps+1]]=a[data_argsort[thisperc*steps:(thisperc+1)*steps+1]]            
            imdat_new = imdat.copy()
            for n, i in enumerate(np.unique(imdat)):
                if i != 0 and i < 392:
                    imdat_new[imdat == i] = abin[n-1]
                elif i >= 392:
                    imdat_new[imdat == i] = np.nan
            nim_out = nib.Nifti1Image(imdat_new, nim.get_affine(), nim.get_header())
            nim_out.set_data_dtype('float32')
            
            out_path=out_pathbase + '/' + str(thisperc) + '/'
            if not os.path.exists(out_path):
                os.makedirs(out_path)
            
            out_name=out_path+'Bin'+str(thisperc)+'_'+sub+'.nii'
            #print out_name
            # to save:
            nim_out.to_filename(out_name)            
            #nilearn.plotting.plot_epi(nim_out, cut_coords=(0,0,0),colorbar=True)
```


```python
plt.close("all")
for i in range(1):
    subs=list(range(len(selected)))
    numbins=10
    nims = rebuild_nii_indv_bins(i,subs,numbins)
    #plt.show()
```

    Pitt_0050009_rois_cc400.1D.npy
    Pitt_0050010_rois_cc400.1D.npy

