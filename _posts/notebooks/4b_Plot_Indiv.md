
## Step 4b - Visualize the individual gradients

#### Write out of individual Nifti files for primary gradient

#####  written by J. Freyberg  for the Autism Gradients project at Brainhack Cambridge 2017


```python
%matplotlib inline
# this cell in only necessary for plotting below
import matplotlib.pylab as plt 
import nilearn 
import nilearn.plotting 

import numpy as np
import nibabel as nib
import os
from os import listdir
from os.path import isfile, join
```


```python
# first import the input list from the csv file
import pandas as pd
# read in csv
df_phen = pd.read_csv('./data/SelectedSubjects.csv')
selected = list(df_phen.filename_npy)
```


```python
def rebuild_nii_individ(num):
    
    for index in range(len(selected)):
        
        sub = selected[index]
        #print(sub)
        data = np.load('./data/Outputs/Regs/%s' % sub)
        a = data[:,num].astype('float32')
        nim = nib.load('./ROIs_Mask/cc400_roi_atlas.nii')
        imdat = nim.get_data().astype('float32')
        
        #print(np.unique(a))
        for i in np.unique(imdat):
            #a[a>0.1] = 0
            #a[a<-0.1] = 0
            if i != 0 and i < 392:
                imdat[imdat == i] = a[int(i)-1]
            elif i >= 392:
                imdat[imdat == i] = np.nan

        nim_out = nib.Nifti1Image(imdat, nim.get_affine(), nim.get_header())
        nim_out.set_data_dtype('float32')
        # to save:
        nim_out.to_filename(os.getcwd() + '/data/Outputs/individual/' + 'res' + sub + str(num) + '.nii')
```


```python
nims = rebuild_nii_individ(0)
```


```python

```
