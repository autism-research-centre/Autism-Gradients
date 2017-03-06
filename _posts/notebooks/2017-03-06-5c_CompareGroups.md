---
layout:     post
title:      "Step 5c - Comparing gradient slopes"
subtitle:   "iPython notebook to compare gradient slopes created in 5a"
date:       2017-03-05 12:00:00
author:     "Richard Bethlehem"
header-img: "img/home-bg.jpg"
categories: notebooks
---

## Step 5C - Comparing gradient slopes

#####  written by R.A.I. Bethlehem for the Autism Gradients project at Brainhack Cambridge 2017


```python
import numpy as np 
import matplotlib as mpl 
import pandas as pd
output = pd.read_csv('./data/Gradients.csv')
output.head()
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>SUB_ID</th>
      <th>X</th>
      <th>subject</th>
      <th>SITE_ID</th>
      <th>FILE_ID</th>
      <th>DX_GROUP</th>
      <th>DSM_IV_TR</th>
      <th>AGE_AT_SCAN</th>
      <th>SEX</th>
      <th>HANDEDNESS_CATEGORY</th>
      <th>...</th>
      <th>1</th>
      <th>2</th>
      <th>3</th>
      <th>4</th>
      <th>5</th>
      <th>6</th>
      <th>7</th>
      <th>8</th>
      <th>9</th>
      <th>file</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>50004</td>
      <td>3</td>
      <td>50004</td>
      <td>PITT</td>
      <td>Pitt_0050004</td>
      <td>1</td>
      <td>1</td>
      <td>19.09</td>
      <td>1</td>
      <td>R</td>
      <td>...</td>
      <td>0.008470</td>
      <td>0.007940</td>
      <td>0.007781</td>
      <td>0.008144</td>
      <td>0.009179</td>
      <td>0.008527</td>
      <td>0.008443</td>
      <td>0.007053</td>
      <td>0.007298</td>
      <td>Pitt_0050004_rois_cc400.1D.npy</td>
    </tr>
    <tr>
      <th>1</th>
      <td>50009</td>
      <td>8</td>
      <td>50009</td>
      <td>PITT</td>
      <td>Pitt_0050009</td>
      <td>1</td>
      <td>1</td>
      <td>33.86</td>
      <td>1</td>
      <td>R</td>
      <td>...</td>
      <td>0.008657</td>
      <td>0.008265</td>
      <td>0.008871</td>
      <td>0.008278</td>
      <td>0.008208</td>
      <td>0.007907</td>
      <td>0.007276</td>
      <td>0.008844</td>
      <td>0.008266</td>
      <td>Pitt_0050009_rois_cc400.1D.npy</td>
    </tr>
    <tr>
      <th>2</th>
      <td>50010</td>
      <td>9</td>
      <td>50010</td>
      <td>PITT</td>
      <td>Pitt_0050010</td>
      <td>1</td>
      <td>1</td>
      <td>35.20</td>
      <td>1</td>
      <td>L</td>
      <td>...</td>
      <td>0.008397</td>
      <td>0.007800</td>
      <td>0.007688</td>
      <td>0.006135</td>
      <td>0.007923</td>
      <td>0.007170</td>
      <td>0.007871</td>
      <td>0.006554</td>
      <td>0.005794</td>
      <td>Pitt_0050010_rois_cc400.1D.npy</td>
    </tr>
    <tr>
      <th>3</th>
      <td>50012</td>
      <td>11</td>
      <td>50012</td>
      <td>PITT</td>
      <td>Pitt_0050012</td>
      <td>1</td>
      <td>1</td>
      <td>21.48</td>
      <td>1</td>
      <td>R</td>
      <td>...</td>
      <td>0.008173</td>
      <td>0.008331</td>
      <td>0.008421</td>
      <td>0.008395</td>
      <td>0.007317</td>
      <td>0.008295</td>
      <td>0.007617</td>
      <td>0.007579</td>
      <td>0.008206</td>
      <td>Pitt_0050012_rois_cc400.1D.npy</td>
    </tr>
    <tr>
      <th>4</th>
      <td>50020</td>
      <td>18</td>
      <td>50020</td>
      <td>PITT</td>
      <td>Pitt_0050020</td>
      <td>1</td>
      <td>1</td>
      <td>20.83</td>
      <td>1</td>
      <td>R</td>
      <td>...</td>
      <td>0.008207</td>
      <td>0.008663</td>
      <td>0.007796</td>
      <td>0.008236</td>
      <td>0.007974</td>
      <td>0.008120</td>
      <td>0.008483</td>
      <td>0.010089</td>
      <td>0.007470</td>
      <td>Pitt_0050020_rois_cc400.1D.npy</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 118 columns</p>
</div>




```python
# Column names are strings, so need to provide a list of strings to index:
df = output[['DX_GROUP'] + [str(x) for x in range(10)]]
ASC = df['DX_GROUP'] == 2
NT = df['DX_GROUP'] == 1
G1 = df[ASC]
G2 = df[NT]
```


```python
%matplotlib inline

## agg backend is used to create plot as a .png file
mpl.use('agg')

import matplotlib.pyplot as plt 

# some plotting options
fs = 10  # fontsize
flierprops = dict(marker='o', markerfacecolor='green', markersize=12,
                  linestyle='none')

## combine the group collections into a list    
Grd0 = [G1['0'], G2['0']]
Grd1 = [G1['1'], G2['1']]
Grd2 = [G1['2'], G2['2']]
Grd3 = [G1['3'], G2['3']]
Grd4 = [G1['4'], G2['4']]
Grd5 = [G1['5'], G2['5']]
Grd6 = [G1['6'], G2['6']]
Grd7 = [G1['7'], G2['7']]
Grd8 = [G1['8'], G2['8']]
Grd9 = [G1['9'], G2['9']]

fig, axes = plt.subplots(nrows=2, ncols=5, figsize=(6, 6), sharey=True)

axes[0, 0].boxplot(Grd0, patch_artist=True)
axes[0, 0].set_title('G0', fontsize=fs)

axes[0, 1].boxplot(Grd1, patch_artist=True)
axes[0, 1].set_title('G1', fontsize=fs)

axes[0, 2].boxplot(Grd2, patch_artist=True)
axes[0, 2].set_title('G2', fontsize=fs)

axes[0, 3].boxplot(Grd3, patch_artist=True)
axes[0, 3].set_title('G3', fontsize=fs)

axes[0, 4].boxplot(Grd4, patch_artist=True)
axes[0, 4].set_title('G4', fontsize=fs)

axes[1, 0].boxplot(Grd5, patch_artist=True)
axes[1, 0].set_title('G5', fontsize=fs)

axes[1, 1].boxplot(Grd6, patch_artist=True)
axes[1, 1].set_title('G6', fontsize=fs)

axes[1, 2].boxplot(Grd7, patch_artist=True)
axes[1, 2].set_title('G7', fontsize=fs)

axes[1, 3].boxplot(Grd8, patch_artist=True)
axes[1, 3].set_title('G8', fontsize=fs)

axes[1, 4].boxplot(Grd9, patch_artist=True)
axes[1, 4].set_title('G9', fontsize=fs)

fig.suptitle("Gradient Slopes")
fig.subplots_adjust(hspace=0.4)
```


![png](output_3_0.png)

