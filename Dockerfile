FROM ubuntu:20.04

Run apt-get update
RUN apt-get install software-properties-common curl wget -y
# This is a repository for all python builds
RUN add-apt-repository ppa:deadsnakes/ppa
Run apt-get update

RUN apt-get install python3.7 python3-pip -y

RUN mkdir /experiment
RUN mkdir /dataset

WORKDIR /tmp

RUN wget https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh
RUN bash ./Anaconda3-2020.11-Linux-x86_64.sh -b -p $HOME/anaconda
#RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
#RUN bash ~/miniconda.sh -b -p $HOME/miniconda

WORKDIR /experiment

COPY . . 

#RUN pip3 update
#RUN pip3 install -r requirements.txt

RUN ~/anaconda/bin/conda env create -f environment.yml

RUN cd code

ENV lang java #programming language
ENV lr 5e-5
ENV batch_size 32
ENV beam_size 10
ENV source_length 256
ENV target_length 128
ENV data_dir /dataset
ENV output_dir model/$lang
ENV train_file $data_dir/$lang/train_minimal.jsonl
ENV dev_file $data_dir/$lang/valid_minimal.jsonl
ENV test_file $data_dir/$lang/test_minimal.jsonl
ENV epochs 10 
ENV pretrained_model microsoft/codebert-base #Roberta: roberta-base

ENTRYPOINT [run.sh]