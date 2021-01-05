#!/bin/bash

# Entrypoint for CodeBert Code-To-Text Experiment

# This file invokes the original python code of the codebert text with the environment variables set in the docker container. 
# Additionally, it does a switch-case which flags for training, validation and testing have been set 
# And it uses an anaconda environment to provide the dependencies. 

# Without Anacondas --no-capture-output flag the system prints from the run.py would be hidden until the anaconda process exits. This flag is optional but highly helpful. 
# Anacondas "-n" parameter specifies which conda-env is used to run the script. It must match the name provided in 'environment.yml'.

# The use of exit without a number returns the exit code of the fore-going statement - that is in this case the anaconda command. 
# The Exit codes are necessary, as otherwise all cases are run (atleast, all cases with flags set). That would not only take longer, but also overwrite valid artifacts.

if [ "$do_train" = true -a "$do_test" = true -a "$do_val" = true ]; then
    echo "performing full run with training, validation and test"
    ~/anaconda/bin/conda run --no-capture-output -n code-to-text \
        python3.7 ./run.py \
        --do_train --do_test --do_eval \
        --model_type roberta --model_name_or_path $pretrained_model \
        --train_filename $train_file --test_filename $test_file --dev_filename $dev_file \
        --output_dir $output_dir \
        --max_source_length $source_length \
        --max_target_length $target_length \
        --beam_size $beam_size \
        --train_batch_size $batch_size --eval_batch_size $batch_size \
        --learning_rate $lr \
        --num_train_epochs $epochs
    exit
fi
if [ "$do_train" = true -a "$do_val" = true ]; then
    echo "performing run with training and validation"
    ~/anaconda/bin/conda run --no-capture-output -n code-to-text \
        python3.7 ./run.py \
        --do_train --do_eval \
        --model_type roberta --model_name_or_path $pretrained_model \
        --train_filename $train_file --dev_filename $dev_file \
        --output_dir $output_dir \
        --max_source_length $source_length \
        --max_target_length $target_length \
        --beam_size $beam_size \
        --train_batch_size $batch_size --eval_batch_size $batch_size \
        --learning_rate $lr \
        --num_train_epochs $epochs
    exit
fi
if [ "$do_train" = true -a "$do_test" = true ]; then
    echo "performing run with training and test"
    ~/anaconda/bin/conda run --no-capture-output -n code-to-text \
        python3.7 ./run.py \
        --do_train --do_test \
        --model_type roberta --model_name_or_path $pretrained_model \
        --train_filename $train_file --test_filename $test_file \
        --output_dir $output_dir \
        --max_source_length $source_length \
        --max_target_length $target_length \
        --beam_size $beam_size \
        --train_batch_size $batch_size --eval_batch_size $batch_size \
        --learning_rate $lr \
        --num_train_epochs $epochs
    exit
fi
if [ "$do_train" = true ]; then
    echo "performing run with (only) training"
    ~/anaconda/bin/conda run --no-capture-output -n \
        code-to-text python3.7 ./run.py \
        --do_train \
        --model_type roberta --model_name_or_path $pretrained_model \
        --train_filename $train_file \
        --output_dir $output_dir \
        --max_source_length $source_length \
        --max_target_length $target_length \
        --beam_size $beam_size \
        --train_batch_size $batch_size \
        --eval_batch_size $batch_size \
        --learning_rate $lr \
        --num_train_epochs $epochs
    exit 0
fi
if [ "$do_test" = true ]; then
    echo "performing run with (only) testing"
    ~/anaconda/bin/conda run --no-capture-output -n code-to-text \
        python3.7 ./run.py \
        --do_test \
        --model_type roberta --model_name_or_path $pretrained_model \
        --test_filename $test_file \
        --output_dir $output_dir \
        --max_source_length $source_length \
        --max_target_length $target_length \
        --beam_size $beam_size \
        --train_batch_size $batch_size \
        --eval_batch_size $batch_size \
        --learning_rate $lr \
        --num_train_epochs $epochs
    exit
fi
echo "no flags set - please inspect your compose"
exit 1