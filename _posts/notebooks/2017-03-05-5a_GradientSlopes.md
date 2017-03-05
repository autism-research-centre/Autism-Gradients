---
layout:     post
title:      "Step 5a - Estimating gradient slopes"
subtitle:   "iPython notebook used to estimate the gradient slopes"
date:       2017-03-05 12:00:00
author:     "Richard Bethlehem"
header-img: "img/home-bg.jpg"
categories: notebooks
---

## Step 5a - Estimating gradient slopes

#####  written by R.A.I. Bethlehem & B. Soergel for the Autism Gradients project at Brainhack Cambridge 2017


```python
from scipy import stats
import pandas as pd
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
grdnt_slope = []
for i in selected:
    # load gradients
    # print i
    filename = i
    grdnt = np.load("./data/Outputs/Regs/" + filename)
    # do we need a specific ordering of the nodes??
    x = list(xrange(392))
    temp = []
    for ii in range(10):
        y = sorted(grdnt[:,ii]) # just sort in ascending order?
        slope, intercept, r_value, p_value, std_err = stats.linregress(x,y)
        temp.append(slope)
        
    grdnt_slope.append(temp)
grdnt_slope = np.array(grdnt_slope)
# make it into a dataframe
data_grdnt = pd.DataFrame(grdnt_slope)
data_grdnt['file'] = selected
```

Merge with the original file


```python
output = df_phen.merge(data_grdnt, left_on='filename_npy',right_on='file',how='outer')
output.to_csv('./data/Gradients.csv')
```


```python

```
