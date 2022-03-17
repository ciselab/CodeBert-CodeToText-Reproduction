#!/bin/bash

# Entrypoint for CodeBert Code-To-Text Experiment
# This file invokes the original python code of the codebert text with the environment variables set in the docker container. 
# The use of exit without a number returns the exit code of the fore-going statement - that is in this case the python command.

echo "Starting  CodeBert-Code2Text-Reproduction - Building the command"

# As the command gets maybe complex, 
# it is stitched together with any flag set in docker environment. 

commandCollector="python ./run.py"

if [ "$load_existing_model" = true ]; 
then commandCollector="$commandCollector --load_model_path $load_model_path "; 
else echo "Creating a new model - not loading an existing one"
fi

if [ "$DO_TRAIN" = true ]; 
then commandCollector="$commandCollector --do_train --train_filename $train_file --train_batch_size $batch_size --num_train_epochs $epochs --seed $seed"; 
else echo "Do not do Training"
fi

if [ "$DO_TEST" = true ]; 
then commandCollector="$commandCollector --do_test --test_filename $test_file"; 
else echo "Do not do Testing"
fi

if [ "$DO_VALID" = true ]; 
then commandCollector="$commandCollector  --do_eval --eval_batch_size $batch_size --dev_filename $valid_file "; 
else echo "Do not do Validation"
fi
# Add standard variables that are always used
# Note: the "$pretrained_model" points to one of the standards in huggingface, and is necessary to find right imports and methods. It does not collide with "$load_model_path"
commandCollector="$commandCollector --model_type roberta --model_name_or_path $pretrained_model --output_dir $output_dir --max_source_length $source_length --max_target_length $target_length --beam_size $beam_size "

echo "Final command is:"
echo $commandCollector

/bin/bash -c "$commandCollector"

exit

# To keep the container open for inspection
# echo "Program finished - Keeping Container open for inspection"
# tail -f /dev/null