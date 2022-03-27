FROM nvcr.io/nvidia/pytorch:20.01-py3

LABEL maintainer="L.H.Applis@tudelft.nl"
LABEL name="ciselab/codebert-code2text"
LABEL url="https://github.com/ciselab/CodeBert-CodeToText-Reproduction"
LABEL vcs="https://github.com/ciselab/CodeBert-CodeToText-Reproduction"

RUN mkdir /experiment
RUN mkdir /dataset

WORKDIR /experiment

COPY . . 

RUN pip install -r requirements.txt

# The "code" folder is copied, and it contains the original CodeBERT Python files 
# There we put our entrypoint to run the original "run.sh"
RUN mv entrypoint.sh ./code/

WORKDIR /experiment/code

# Be careful to not add comments after the env variables - they will be added to the string 

ENV DO_TRAIN true
ENV DO_VALID true
ENV DO_TEST true

ENV lang java
ENV lr 5e-5
ENV batch_size 32
ENV beam_size 10
ENV source_length 256
ENV target_length 128
ENV data_dir /dataset
ENV output_dir /experiment/output
ENV train_file $data_dir/train_minimal.jsonl
ENV valid_file $data_dir/valid_minimal.jsonl
ENV test_file $data_dir/test_minimal.jsonl
ENV epochs 10 
ENV pretrained_model microsoft/codebert-base

ENV seed 2022

ENV load_existing_model false
ENV load_model_path /models/pytorch_model.bin

ENTRYPOINT ["bash","./entrypoint.sh"]