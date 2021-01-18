FROM ubuntu:20.04

# This will create a Timezone, which is required for one of the later apt installs
ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

Run apt-get update
RUN apt-get install software-properties-common curl wget -y
# This is a repository for all python builds
RUN add-apt-repository ppa:deadsnakes/ppa -y
Run apt-get update

RUN apt-get install python3.7 python3-pip -y

RUN mkdir /experiment
RUN mkdir /dataset

WORKDIR /tmp

RUN wget https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh
RUN bash ./Anaconda3-2020.11-Linux-x86_64.sh -b -p $HOME/anaconda

WORKDIR /experiment

COPY . . 

RUN ~/anaconda/bin/conda update --all -y 
RUN ~/anaconda/bin/conda env create -f environment.yml

RUN mv entrypoint.sh ./code/

WORKDIR /experiment/code

# Be careful to not add comments after the env variables - they will be added to the string 

ENV do_train true
ENV do_val true
ENV do_test true

ENV lang java
ENV lr 5e-5
ENV batch_size 32
ENV beam_size 10
ENV source_length 256
ENV target_length 128
ENV data_dir /dataset
ENV output_dir /experiment/output
ENV train_file $data_dir/train_minimal.jsonl
ENV dev_file $data_dir/valid_minimal.jsonl
ENV test_file $data_dir/test_minimal.jsonl
ENV epochs 10 
ENV pretrained_model microsoft/codebert-base

ENV load_existing_model false
ENV load_model_path /models/pytorch_model.bin

ENTRYPOINT ["bash","./entrypoint.sh"]