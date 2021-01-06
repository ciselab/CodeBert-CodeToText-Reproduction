# CodeBERT Code-to-Text Reproduction Package

This repository holds a docker image which reproduces [Microsofts CodeBERT Code-To-Text Experiment](https://github.com/microsoft/CodeXGLUE/tree/main/Code-Text/code-to-text).

The subparts have been minimally changed (see [changes](./changes.md)), but mostly it is just wrapping the experiment in a cpu-based docker image. 
There is currently no GPU-Image.

The initial readme can be [found here](./initial_readme.md).

## How to run 

Download the dataset using the instructions in the [initial readme](./initial_readme.md) - or do so running [prepare.sh](./prepare.sh).
The shell file runs the instructions from the initial readme and adds some more commands to create the *minimal files* required for *docker-compose-minimal.yml*. 
It worked flawlessly for me on a mac, so I did not want to make extra docker image for data-preprocessing. 
Depending on your distribution, you might need to install things like wget.

After that, change the docker-compose to point to your files (including filenames) and set environment variables as fit. 

You can build the docker file beforehand using 

```
docker build . -t ciselab/CodeBERT-Code2Text
```

Or you can comment-in the build parts in the docker-compose.yml

Run the experiment using 

```
docker-compose up
```

To verify that all your compose attributes are set correctly, I recommend to run first on a reduced set (e.g. 5 lines per file). 
This is represented in the *docker-compose-minimal.yml*.


```
docker-compose -f docker-compose-minimal.yml up
```


When shutting down the process before completion, make sure to **clean up your containers** ! 
Otherwise, using docker run it might just restart the stopped container. 

Also, if you run the experiment multiple times, **extract the outputs** beforehand. 
Otherwise, the output will be overwritten. 

I have also tested this to work with podman and podman-compose on debian 10. 
For running with podman, make sure to have the output folder created first.

## Licence 

Everything additionally created for packaging is under the MIT Licence. 
The original python files from microsoft follow (different) licences, and any changes should be proposed to the CodeBERT repository. 

## Known issues

Running with a conda environment is not that easy in docker. 
that's why the entrypoint.sh is running with `conda-run`. 
`conda-run` buffers the stdout until it fails or is done, making the container mostly silent until it ends. 
Conda is currently working on addressing this in a beta version.
I hope I addressed this by now, but if there is such an issue you now know why. 

The *preprocess.py* in the Dataset.zip sometimes failes to unzip all of the data. 
If this error occurs, some of the .jsonls will still be gzipped. 
To fix this, simply run `gunzip` on the remaining files and re-run the preprocess.py.
