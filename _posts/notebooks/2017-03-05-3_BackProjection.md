---
layout:     post
title:      "Step 3 - Back projection"
subtitle:   "iPython notebook to backproject individual embeddings from the grouped output in Step 2"
date:       2017-03-05 12:00:00
author:     "Richard Bethlehem"
header-img: "img/home-bg.jpg"
categories: notebooks
---

## Step 3 - Back project the embeddings to individuals


#####  written by R.A.I. Bethlehem, D. Margulies and M. Falkiewicz  for the Autism Gradients project at Brainhack Cambridge 2017


```python
# first import the input list from the csv file
import pandas as pd
# read in csv
df_phen = pd.read_csv('./data/SelectedSubjects.csv')
selected = list(df_phen.filename_1D)
```


```python
Run the back projection ysing pySTATIS
```


```python
%%capture
from pySTATIS import statis
import numpy as np 
import os

#load vectors
names = list(xrange(392))
X = [np.load("./data/Outputs/Embs/"+ os.path.basename(filename)+"_embedding_dense_res_veconly.npy") for filename in selected]
out = statis.statis(X, names, fname='./data/Outputs/statis_results.npy')
statis.project_back(X, out['Q'], path = "./data/Outputs/Regs/",fnames = selected)
np.save("./data/Outputs/Mean_Vec.npy",out['F'])
```


```python

```
