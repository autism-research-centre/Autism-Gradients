
Step 1: Selecting subjects based on
- Missing data
- SUB_IN_SMP variable (subjects used in the orginal paper)


```python
# import useful things
import numpy as np
import os
import nibabel as nib
from sklearn.metrics import pairwise_distances

# get a list of inputs
from os import listdir
from os.path import isfile, join
import os.path

# little helper function to return the proper filelist with the full path but that skips hidden files
def listdir_nohidden(path):
    for f in os.listdir(path):
        if not f.startswith('.'):
            yield f

def listdir_fullpath(d):
    return [os.path.join(d, f) for f in listdir_nohidden(d)]
# and create a filelist
onlyfiles = listdir_fullpath("./data/Input/")
```

Check for missing data


```python
# check to see which files contains nodes with missing information
missingarray = []
for i in onlyfiles:
# load timeseries
    filename = i
    ts_raw = np.loadtxt(filename)

# check zero columns
    missingn = np.where(~ts_raw.any(axis=0))[0]
    missingarray.append(missingn)

# select the ones that don't have missing data
ids = np.where([len(i) == 0 for i in missingarray])[0]
selected_filename_only = [onlyfiles[i] for i in ids]
# could be useful to have one without pathnames later one
selected_full_path = [os.path.basename(onlyfiles[i]) for i in ids]
print(len(selected_filename_only))
```

    178


Now load the phenotype file and check to see the filenames match the selected ones and have the SUB_IN_SMP set to 1


```python
import pandas as pd
# read in csv
df_phen = pd.read_csv('./data/Phenotypic_V1_0b_preprocessed1_filt.csv')
# add a column that matches the filename
for i in df_phen:
    df_phen['filename_1D'] = join(df_phen['FILE_ID']+"_rois_cc400.1D")
    df_phen['filename_npy'] = join(df_phen['FILE_ID']+"_rois_cc400.1D.npy")

df_phen['selected'] = np.where(df_phen['filename_1D'].isin((selected_full_path)), 1, 0 )

df_phen = df_phen.loc[df_phen["SUB_IN_SMP"] == 1]    
df_phen = df_phen.loc[df_phen["selected"] == 1]    

df_phen.to_csv('./data/SelectedSubjects.csv')
```


```python

```
