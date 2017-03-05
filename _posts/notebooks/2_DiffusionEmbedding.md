
## Step 2 - Run the diffusion embedding on selected files

#####  written by R.A.I. Bethlehem, D. Margulies and M. Falkiewicz  for the Autism Gradients project at Brainhack Cambridge 2017


```python
# first import the input list from the csv file
import pandas as pd
# read in csv
df_phen = pd.read_csv('./data/SelectedSubjects.csv')
selected = df_phen[['filename_1D']].values.tolist()
```

Then run the embedding


```python
# run the diffusion embedding
import numpy as np 
from mapalign import embed
import os
import nibabel as nib
from sklearn.metrics import pairwise_distances

for i in selected:
    # load timeseries
    filename = ''.join(i)
    #print filename
    ts = np.loadtxt('./data/Input/'+filename)
    # create correlation matrix
    dcon = np.corrcoef(ts.T)
    dcon[np.isnan(dcon)] = 0

    # Get number of nodes
    N = dcon.shape[0]

    # threshold
    perc = np.array([np.percentile(x, 90) for x in dcon])

    for ii in range(dcon.shape[0]):
        #print "Row %d" % ii
        dcon[ii, dcon[ii,:] < perc[ii]] = 0

    # If there are any left then set them to zero
    dcon[dcon < 0] = 0

    # compute the pairwise correctionlation distances
    aff = 1 - pairwise_distances(dcon, metric = 'cosine')

    # start saving
    savename = os.path.basename(filename)
    np.save("./data/Outputs/Affn/"+savename+"_cosine_affinity.npy", aff)
    # get the diffusion maps
    emb, res = embed.compute_diffusion_map(aff, alpha = 0.5)
    # Save results
    np.save("./data/Outputs/Embs/"+savename+"_embedding_dense_emb.npy", emb)
    np.save("./data/Outputs/Embs/"+savename+"_embedding_dense_res.npy", res)

    X = res['vectors']
    X = (X.T/X[:,0]).T[:,1:]    
    
    np.save("./data/Outputs/Embs/"+savename+"_embedding_dense_res_veconly.npy", X) #store vectors only
```


```python

```
