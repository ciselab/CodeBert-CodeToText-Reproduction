#!/bin/bash

# Prepare.sh
# Runs the scripts from 'initial_readme.md' and also makes a minimal compose and its files

# Requires the dataset.zip to be next to this file

unzip dataset.zip

# Download all actual files
cd dataset
wget https://s3.amazonaws.com/code-search-net/CodeSearchNet/v2/python.zip
wget https://s3.amazonaws.com/code-search-net/CodeSearchNet/v2/java.zip
wget https://s3.amazonaws.com/code-search-net/CodeSearchNet/v2/ruby.zip
wget https://s3.amazonaws.com/code-search-net/CodeSearchNet/v2/javascript.zip
wget https://s3.amazonaws.com/code-search-net/CodeSearchNet/v2/go.zip
wget https://s3.amazonaws.com/code-search-net/CodeSearchNet/v2/php.zip
# Unzip all the downloads
unzip python.zip
unzip java.zip
unzip ruby.zip
unzip javascript.zip
unzip go.zip
unzip php.zip
# Remove the (now) unecessary artifacts
rm *.zip
rm *.pkl

# Run the preprocessing file, which comes with the dataset.zip
# The preprocess.py creates the .jsonl files for training, test and validation for all languages
python preprocess.py
rm -f */final

# Make the minimal files for java
cd java

head -n 5 test.jsonl > test_minimal.jsonl
head -n 5 train.jsonl > train_minimal.jsonl
head -n 5 valid.jsonl > valid_minimal.jsonl

exit