if [ "$do_train" = true && "$do_test" = true && "do_val" = true ]; then
    echo "performing full run with training, validation and test"
    ~/anaconda/bin/conda run -n code-to-text python3.7 ./run.py --do_train --do_test --do_eval --model_type roberta --model_name_or_path $pretrained_model --train_filename $train_file --test_filename $test_file --dev_filename $dev_file --output_dir $output_dir --max_source_length $source_length --max_target_length $target_length --beam_size $beam_size --train_batch_size $batch_size --eval_batch_size $batch_size --learning_rate $lr --num_train_epochs $epochs
fi
if [ "$do_train" = true && "do_val" = true ]; then
    echo "performing run with training and validation"
    ~/anaconda/bin/conda run -n code-to-text python3.7 ./run.py --do_train --do_eval --model_type roberta --model_name_or_path $pretrained_model --train_filename $train_file --dev_filename $dev_file --output_dir $output_dir --max_source_length $source_length --max_target_length $target_length --beam_size $beam_size --train_batch_size $batch_size --eval_batch_size $batch_size --learning_rate $lr --num_train_epochs $epochs
fi
if [ "$do_train" = true && "$do_test" = true ]; then
    echo "performing run with training and test"
    ~/anaconda/bin/conda run -n code-to-text python3.7 ./run.py --do_train --do_test --model_type roberta --model_name_or_path $pretrained_model --train_filename $train_file --test_filename $test_file --output_dir $output_dir --max_source_length $source_length --max_target_length $target_length --beam_size $beam_size --train_batch_size $batch_size --eval_batch_size $batch_size --learning_rate $lr --num_train_epochs $epochs
fi
if [ "$do_train" = true]; then
    echo "performing run with (only) training"
    ~/anaconda/bin/conda run -n code-to-text python3.7 ./run.py --do_train --model_type roberta --model_name_or_path $pretrained_model --train_filename $train_file --output_dir $output_dir --max_source_length $source_length --max_target_length $target_length --beam_size $beam_size --train_batch_size $batch_size --eval_batch_size $batch_size --learning_rate $lr --num_train_epochs $epochs
fi
if [ "$do_test" = true ]; then
    echo "performing run with (only) testing"
    ~/anaconda/bin/conda run -n code-to-text python3.7 ./run.py --do_test --model_type roberta --model_name_or_path $pretrained_model --test_filename $test_file --output_dir $output_dir --max_source_length $source_length --max_target_length $target_length --beam_size $beam_size --train_batch_size $batch_size --eval_batch_size $batch_size --learning_rate $lr --num_train_epochs $epochs
fi