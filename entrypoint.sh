#!/bin/bash

# Entrypoint for CodeBert Code-To-Text Experiment

# This file invokes the original python code of the codebert text with the environment variables set in the docker container. 
# Additionally, it does a switch-case which flags for training, validation and testing have been set 

# The use of exit without a number returns the exit code of the fore-going statement - that is in this case the anaconda command. 
# The Exit codes are necessary, as otherwise all cases are run (atleast, all cases with flags set). 
# That would not only take longer, but also overwrite valid artifacts. Do not remove exits!


# ============================================
#        Case 1: Pretrained Model 
# ============================================

if [ "$load_existing_model" = true ]; then 
    echo "Found flag to load a model under $load_model_path"

    if [ "$DO_TRAIN" = true -a "$DO_TEST" = true -a "$DO_VALID" = true ]; then
        echo "performing full run with training, validation and test"
        python ./run.py \
            --do_train --do_test --do_eval \
            --model_type roberta --model_name_or_path $pretrained_model \
            --train_filename $train_file --test_filename $test_file --dev_filename $valid_file \
            --output_dir $output_dir \
            --max_source_length $source_length \
            --max_target_length $target_length \
            --beam_size $beam_size \
            --train_batch_size $batch_size --eval_batch_size $batch_size \
            --learning_rate $lr \
            --num_train_epochs $epochs \
            --load_model_path $load_model_path \
            --seed $seed
        exit
    fi
    if [ "$DO_TRAIN" = true -a "$DO_VALID" = true ]; then
        echo "performing run with training and validation"
        python ./run.py \
            --do_train --do_eval \
            --model_type roberta --model_name_or_path $pretrained_model \
            --train_filename $train_file --dev_filename $valid_file \
            --output_dir $output_dir \
            --max_source_length $source_length \
            --max_target_length $target_length \
            --beam_size $beam_size \
            --train_batch_size $batch_size --eval_batch_size $batch_size \
            --learning_rate $lr \
            --load_model_path $load_model_path \
            --num_train_epochs $epochs \
            --seed $seed
        exit
    fi
    if [ "$DO_TRAIN" = true -a "$DO_TEST" = true ]; then
        echo "performing run with training and test"
        python ./run.py \
            --do_train --do_test \
            --model_type roberta --model_name_or_path $pretrained_model \
            --train_filename $train_file --test_filename $test_file \
            --output_dir $output_dir \
            --max_source_length $source_length \
            --max_target_length $target_length \
            --beam_size $beam_size \
            --train_batch_size $batch_size --eval_batch_size $batch_size \
            --learning_rate $lr \
            --num_train_epochs $epochs \
            --load_model_path $load_model_path \
            --seed $seed
        exit
    fi
    if [ "$DO_TRAIN" = true ]; then
        echo "performing run with (only) training"
        python ./run.py \
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
            --num_train_epochs $epochs \
            --load_model_path $load_model_path \
            --seed $seed
        exit 0
    fi
    if [ "$DO_TEST" = true ]; then
        echo "performing run with (only) testing"
        python ./run.py \
            --do_test \
            --model_type roberta --model_name_or_path $pretrained_model \
            --test_filename $test_file \
            --output_dir $output_dir \
            --max_source_length $source_length \
            --max_target_length $target_length \
            --train_batch_size $batch_size \
            --eval_batch_size $batch_size \
            --load_model_path $load_model_path \
            --seed $seed
        exit
    fi
fi

# ============================================
#        Case 2: No Pretrained Model 
# ============================================

if [ "$DO_TRAIN" = true -a "$DO_TEST" = true -a "$DO_VALID" = true ]; then
    echo "performing full run with training, validation and test"
    python ./run.py \
        --do_train --do_test --do_eval \
        --model_type roberta --model_name_or_path $pretrained_model \
        --train_filename $train_file --test_filename $test_file --dev_filename $valid_file \
        --output_dir $output_dir \
        --max_source_length $source_length \
        --max_target_length $target_length \
        --beam_size $beam_size \
        --train_batch_size $batch_size --eval_batch_size $batch_size \
        --learning_rate $lr \
        --num_train_epochs $epochs \
        --seed $seed
    exit
fi
if [ "$DO_TRAIN" = true -a "$DO_VALID" = true ]; then
    echo "performing run with training and validation"
    python ./run.py \
        --do_train --do_eval \
        --model_type roberta --model_name_or_path $pretrained_model \
        --train_filename $train_file --dev_filename $valid_file \
        --output_dir $output_dir \
        --max_source_length $source_length \
        --max_target_length $target_length \
        --beam_size $beam_size \
        --train_batch_size $batch_size --eval_batch_size $batch_size \
        --learning_rate $lr \
        --num_train_epochs $epochs \
        --seed $seed
    exit
fi

if [ "$DO_TRAIN" = true -a "$DO_TEST" = true ]; then
    echo "performing run with training and test"
    python ./run.py \
        --do_train --do_test \
        --model_type roberta --model_name_or_path $pretrained_model \
        --train_filename $train_file --test_filename $test_file \
        --output_dir $output_dir \
        --max_source_length $source_length \
        --max_target_length $target_length \
        --beam_size $beam_size \
        --train_batch_size $batch_size --eval_batch_size $batch_size \
        --learning_rate $lr \
        --num_train_epochs $epochs \
        --seed $seed
    exit
fi
if [ "$DO_TRAIN" = true ]; then
    echo "performing run with (only) training"
    python ./run.py \
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
        --num_train_epochs $epochs \
        --seed $seed
    exit 0
fi
if [ "$DO_TEST" = true ]; then
    echo "performing run with (only) testing"
    python ./run.py \
        --do_test \
        --model_type roberta --model_name_or_path $pretrained_model \
        --test_filename $test_file \
        --output_dir $output_dir \
        --max_source_length $source_length \
        --max_target_length $target_length \
        --train_batch_size $batch_size \
        --eval_batch_size $batch_size \
        --seed $seed
    exit
fi

# ===================================
#     Case 3: Error / Unknown 
# ===================================

echo "no flags set - please inspect your compose"
exit 1