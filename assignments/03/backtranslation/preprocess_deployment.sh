#!/bin/bash
# -*- coding: utf-8 -*-

set -e

pwd=`dirname "$(readlink -f "$0")"`
base=$pwd/../../..

data=$(basename $1)
data_dir=$(dirname $1)
lang=$2
tm=$3

# change into base directory to ensure paths are valid
cd $base

# create preprocessed directory
mkdir -p $data_dir/preprocessed/

# normalize and tokenize raw data
cat $1 | perl moses_scripts/normalize-punctuation.perl -l $lang | perl moses_scripts/tokenizer.perl -l $lang -a -q > $data_dir/preprocessed/$data.p
# cat $data_dir/raw/train.$tgt | perl moses_scripts/normalize-punctuation.perl -l $tgt | perl moses_scripts/tokenizer.perl -l $tgt -a -q > $data_dir/preprocessed/train.$tgt.p

# train truecase models
# perl moses_scripts/train-truecaser.perl --model $data_dir/preprocessed/tm.$src --corpus $data_dir/preprocessed/train.$src.p
# perl moses_scripts/train-truecaser.perl --model $data_dir/preprocessed/tm.$tgt --corpus $data_dir/preprocessed/train.$tgt.p

# apply truecase models to splits
cat $data_dir/preprocessed/$data.p | perl moses_scripts/truecase.perl --model $tm > $data_dir/preprocessed/$data
# cat $data_dir/preprocessed/train.$tgt.p | perl moses_scripts/truecase.perl --model $data_dir/preprocessed/tm.$tgt > $data_dir/preprocessed/train.$tgt

# prepare remaining splits with learned models
# for split in valid test tiny_train
# do
#     cat $data_dir/raw/$split.$src | perl moses_scripts/normalize-punctuation.perl -l $src | perl moses_scripts/tokenizer.perl -l $src -a -q | perl moses_scripts/truecase.perl --model $data_dir/preprocessed/tm.$src > $data_dir/preprocessed/$split.$src
#     cat $data_dir/raw/$split.$tgt | perl moses_scripts/normalize-punctuation.perl -l $tgt | perl moses_scripts/tokenizer.perl -l $tgt -a -q | perl moses_scripts/truecase.perl --model $data_dir/preprocessed/tm.$tgt > $data_dir/preprocessed/$split.$tgt
# done

# remove tmp files
rm $data_dir/preprocessed/$data.p
# rm $data_dir/preprocessed/train.$tgt.p

# preprocess all files for model training
# python preprocess.py --target-lang $tgt --source-lang $src --dest-dir $data_dir/prepared/ --train-prefix $data_dir/preprocessed/train --valid-prefix $data_dir/preprocessed/valid --test-prefix $data_dir/preprocessed/test --tiny-train-prefix $data_dir/preprocessed/tiny_train --threshold-src 1 --threshold-tgt 1 --num-words-src 4000 --num-words-tgt 4000

echo "done!"