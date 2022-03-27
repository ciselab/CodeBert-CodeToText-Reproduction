# CodeBERT Code-to-Text Reproduction Package

This repository holds a docker image which reproduces [Microsofts CodeBERT Code-To-Text Experiment](https://github.com/microsoft/CodeXGLUE/tree/main/Code-Text/code-to-text).

The subparts have been minimally changed (see [changes](./changes.md)), but mostly it is just wrapping the experiment in a docker-image.

The initial readme can be [found here](./initial_readme.md).

## How to run 

Download the dataset using the instructions in the [initial readme](./initial_readme.md) - or do so running [prepare.sh](./prepare.sh).
The shell file runs the instructions from the initial readme and adds some more commands to create the *minimal files* required for *docker-compose-minimal.yml*. 
It worked flawlessly for me on a mac, so I did not want to make extra docker image for data-preprocessing. 
Depending on your distribution, you might need to install things like wget.

**Note:** The step before is necessary! the `dataset.zip` only contains references to the dataset and is *unfolded* in `prepare.sh`. 


After that, change the docker-compose to point to your files (including filenames) and set environment variables as fit. 

You can build the docker file beforehand using 

```
docker build . -t ciselab/codebert-code2text:1.3 -t ciselab/codebert-code2text:latest
```

Run the experiment using 

```
docker-compose up
```

To verify that all your compose attributes are set correctly, I recommend to run first on a reduced set (e.g. 5 lines per file). 
This is represented in the *docker-compose-minimal.yml*. It should take less than 30 minutes to give you an overview.


```
docker-compose -f docker-compose-minimal.yml up
```


When shutting down the process before completion, make sure to **clean up your containers** ! 
Otherwise, using `docker run` it might just restart the stopped container. 

Also, if you run the experiment multiple times, **extract the outputs** beforehand. 
Otherwise, the output will be overwritten. 

Version 1.2 was also tested to work with podman and podman-compose on debian 10. 
For running with podman, make sure to have the output folder created first.

## Requirements / Non Docker 

The contained `environment.yml` is a starting point how to run this *without docker* on your own machine. 
The provided `requirements.txt` is meant for docker-only as important parts (pytorch) are missing, to align with pre-existing dependencies in the container.
To work, you should be good starting from Python 3.6 and make a fresh conda env from the `environment.yml`. 

## Licence 

Everything additionally created for packaging is under the MIT Licence. 
The original python files from microsoft follow (different) licences, and any changes should be proposed to the CodeBERT repository. 

**Important:** The used CUDA Containers come with their own Licence, and should be used carefully. I think they mostly send telemetrics to NVidia, our friendly GPU-monopoly-holding overlords.

## Limitations / Hardware Requirement

For the container to run properly, it needs 15 to 25 gigabyte memory. 
On our servers, one cpu epoch on the java data takes ~30h. 
The CPU Containers starts ~20 threads for training and your server should have >20 cores.  

In comparison, training on a RTX 1070 took 7h per epoch. 
Training on a 3080ti took 6h per epoch. 
Training on an A40 took ~4h per epoch. In general, the GPU tries to allocate around 12gb of memory. 

In general, despite being a good first step, GPU Containers turned out to be quite fragile. 
We have seen multiple problems with Framework-Versions, Hardware and OS combinations. 
If you intend to reproduce the experiments, we recommend the CPU way for slow but steady progress, 
and to figure out your own GPU configuration if you intend to do actual changes.

## Known issues

The *preprocess.py* in the Dataset.zip sometimes failes to unzip all of the data. 
If this error occurs, some of the .jsonls will still be gzipped. 
To fix this, simply run `gunzip` on the remaining files and re-run the preprocess.py.

------


Due to file-locks, it is not possible to use a model OR a dataset at two experiments at the same time. 
If you want to run two experiments at once using the same model, you need to make a copy.
A short test from me showed that they give the same results when all parameters are equal.

------

Another issue is from windows, atleast default windows. 
if you get an error like 
```
CodeBert_CodeToText_Experiment_0_1  | ./entrypoint.sh: line 2: $'\r': command not found
CodeBert_CodeToText_Experiment_0_1  | ./entrypoint.sh: line 4: $'\r': command not found
CodeBert_CodeToText_Experiment_0_1  | ./entrypoint.sh: line 8: $'\r': command not found
CodeBert_CodeToText_Experiment_0_1  | ./entrypoint.sh: line 11: $'\r': command not found
CodeBert_CodeToText_Experiment_0_1  | ./entrypoint.sh: line 14: $'\r': command not found
CodeBert_CodeToText_Experiment_0_1  | ./entrypoint.sh: line 200: syntax error: unexpected end of file
```
This is due to windows changing the line-breaks / file encodings. Thanks windows. 
**Easy Solution**: run `dos2unix entrypoint.sh` and rebuild the container. 
Its might easier/faster to pull the image from this repository, or you have to [edit the entrypoint to be compatible with windows](https://askubuntu.com/questions/966488/how-do-i-fix-r-command-not-found-errors-running-bash-scripts-in-wsl). 


------

```
xxx | RuntimeError: CUDA out of memory. Tried to allocate 62.00 MiB (GPU 0; 12.00 GiB total capacity; 10.57 GiB already allocated; 0 bytes free; 10.71 GiB reserved in total by PyTorch)
```

This happens in old Pytorch versions. 

Reduce batch size. To the best of my knowledge, nothing else can be done about this in old pytorch versions.

------

Another thing that can happen is that the container stops after printing "starting epoch" like such: 

```
[...]
python-codebert-training_1  | 03/17/2022 08:00:18 - INFO - __main__ -   ***** Running training *****
python-codebert-training_1  | 03/17/2022 08:00:18 - INFO - __main__ -     Num examples = 164923
python-codebert-training_1  | 03/17/2022 08:00:18 - INFO - __main__ -     Batch size = 8
python-codebert-training_1  | 03/17/2022 08:00:18 - INFO - __main__ -     Num epoch = 10
[Nothing here but you are waiting for it quite long already]
```

This can be expected, as here the logging / printing halts until evaluation. 
However, it can also be blocked by some pytorch logic. 
This happened on our servers where we had multiple GPUs, that were all mounted in the docker-compose. 
You can narrow down whether this is your problem by 

1. Checking Nvidia SMI, showing *n* python processes (where n is the numer of your GPUs)
2. All related python processes have a low memory use
3. the general load on the GPUs is low 
4. the time that you see the above message is suspiciously different from the numbers reported above

To adress this, just mount **one** GPU in. 
Only one GPU should be picked up, printed as such at the beginning of the container logs. 

## Version History 

- 1.0 was the first version with everything hardcoded
- 1.1 had some elements hardcoded, others configurable
- 1.2 was fully configurable but hardcoded to **CPU only**
- 1.3 changed the base image and allows **GPU usage**
