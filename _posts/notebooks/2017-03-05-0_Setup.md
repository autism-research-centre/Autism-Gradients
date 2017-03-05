## Autism gradients of hierarchical organization

#### Brainhack project on exploring the use of connectivity gradients to study cortical hierarchies in autism

#### Rationale
Most of the theoretical foundations on the use of gradient can be found [here] (http://www.pnas.org/content/113/44/12574) 

In short, Margulies et al. show how the primary connectivity gradient very closely resembles the topology of the default mode network and that there appears to be some hierarchy in this gradient that follows the hierarchy of complexity in cognitive processing (ranging from low-level sensory processing to higher order cognition).

In Autism research there are numerous theories regarding alterations in functional connectivity. Ranging from a global theory suggesting short-range over connectivity and long-range underconnectivity (Belmonte et al. 2004) and more specific examples of specific connection mainly in anterior-posterior connections (Courchesne et al.). From a more cognitive perspective it might be interesting to see if some of this is also represented in some for of disruption in cortical hierarchy. If for example individuals with autism have a strong talent for very detailed functions, but possibly less capacity to intergrate information from different sources/modalities one could hypothesize that the cortical hierarchy might be disrupted.

Thus, in the present project we would like to investigate these cortical hierarchy by looking at the steepness of the connectivity gradient. 

---

### Get set up
Make sure you have anaconda or miniconda installed. This provides you with a good way to manage your python repositories, and allows you to simply install all dependencies for this project by using the provided environment.yml file.

Find it here:

https://conda.io/miniconda.html

You should also have `git` installed, since some packages used in this project are only available from github.

If you have both git and miniconda or anaconda installed, start by cloning this repository:

`git clone https://github.com/rb643/Autism-Gradients`

To manage all the required packages, we’ll create a new conda environment. These environments simply clone your root environment (so they will have everything you normally have installed) and then install packages listed in the environment file _only for that environment_. If you stop working on this project, you’ll be able to simply delete the environment, and all the packages will be uninstalled.

1. Open a terminal or a cmd prompt.
2. Change directory (cd) to the repository folder. If you ran `git clone …` (above) in your home folder, the repository should be reachable by typing `cd ~/Autism-Gradients` on OSX or Linux.
3. Create a conda environment from the environment.yml file using the following command: `conda env create -n rbbrainhack -f environment.yml`.
    - It will ask you if you want to go ahead and install all the packages - simply press `enter`.
4. Then activate this environment: `source activate rbbrainhack` on Linux/OSX, `activate rbbrainhack` on Windows.
    - Whenever you stop working on this, you can type `source deactivate rbbrainhack` to return to your normal python installation, or simply close your terminal and open a new one.
5. Type `jupiter notebook`. This will open a browser window that displays the content of your home directory. Click on the files ending in `.ipynb` to open them and run the code!

__If you have any issues with the above, simply open an issue on this github repository!__
