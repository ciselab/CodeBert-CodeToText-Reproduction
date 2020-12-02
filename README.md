# Code to Text Reproduction Package

This is a sub-part of the code-to-text experiment from microsofts CodeXGlue project. 

The initial readme can be [found here](./initial_readme.md).

The subparts have been minimally changed (see [changes](./changes.md)), but mostly it is just wrapping the experiment in a cpu-based docker.

## How to run 

make sure you have the dataset similar to what is in the [initial readme](./initial_readme.md). it worked flawlessly for me on a mac. 

Then change the docker-compose to point to your files (including filenames) and set environment variables as fit. 

You can build the docker file beforehand using 'docker build . -t code2text'. 
Or you can comment-in the build parts in the docker-compose.yml

When you shut down the process before completion, make sure to clean up your containers ! otherwise, using docker run it might just restart the stopped container. 

## known issues

Running with a conda environment is not that easy in docker. 
that's why the entrypoint.sh is running with 'conda-run'. 
'conda-run' buffers the stderr until it fails or is done, making the container mostly silent until it ends. 
Conda is currently working on addressing this in a beta version. 