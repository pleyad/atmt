#!/bin/bash
# -*- coding: utf-8 -*-

set -e

pwd=`dirname "$(readlink -f "$0")"`
base=$pwd/../../../..
src=en
tgt=fr
data=$pwd/data
spm=$1

if [ -z "$1" ]; then
    echo "Error: Specify path WITHOUT FILE EXTENSION"
    exit 1
fi

# change into base directory to ensure paths are valid
cd $base

# create preprocessed directory
mkdir -p $data/preprocessed/

# normalize and tokenize raw data
cat $data/raw/train.$src | perl moses_scripts/normalize-punctuation.perl -l $src | perl moses_scripts/tokenizer.perl -l $src -a -q > $data/preprocessed/train.$src.p
cat $data/raw/train.$tgt | perl moses_scripts/normalize-punctuation.perl -l $tgt | perl moses_scripts/tokenizer.perl -l $tgt -a -q > $data/preprocessed/train.$tgt.p
cat $data/raw/en-10k.txt | perl moses_scripts/normalize-punctuation.perl -l $src | perl moses_scripts/tokenizer.perl -l $src -a -q > $data/preprocessed/en-10k.p

# train truecase models
cat $data/preprocessed/train.$src.p $data/preprocessed/en-10k.p > $data/preprocessed/doubletrouble.p
perl moses_scripts/train-truecaser.perl --model $data/preprocessed/tm.$src --corpus $data/preprocessed/doubletrouble.p
# perl moses_scripts/train-truecaser.perl --model $data/preprocessed/tm.$src --corpus $data/preprocessed/train.$src.p --corpus $data/preprocessed/en-10k.p
perl moses_scripts/train-truecaser.perl --model $data/preprocessed/tm.$tgt --corpus $data/preprocessed/train.$tgt.p
rm $data/preprocessed/doubletrouble.p

# apply truecase models to splits
cat $data/preprocessed/train.$src.p | perl moses_scripts/truecase.perl --model $data/preprocessed/tm.$src > $data/preprocessed/train.$src.prepieced
cat $data/preprocessed/train.$tgt.p | perl moses_scripts/truecase.perl --model $data/preprocessed/tm.$tgt > $data/preprocessed/train.$tgt.prepieced
cat $data/preprocessed/en-10k.p | perl moses_scripts/truecase.perl --model $data/preprocessed/tm.$src > $data/preprocessed/en-10k.prepieced

# check if sentencepiece-model exists, if not, train and save at the specified location
if ! test -f "$spm.model"; then
    spm_train --input=$data/preprocessed/train.$src.prepieced,$data/preprocessed/train.$tgt.prepieced,$data/preprocessed/en-10k.prepieced --user_defined_symbols="&apos;","&quot;","&amp;" --model_prefix=$pwd/$spm --vocab_size=4000 --model_type=bpe
fi

spm_encode --model=$pwd/$spm.model --output_format=piece < $data/preprocessed/train.$src.prepieced > $data/preprocessed/train.$src
spm_encode --model=$pwd/$spm.model --output_format=piece < $data/preprocessed/train.$tgt.prepieced > $data/preprocessed/train.$tgt
spm_encode --model=$pwd/$spm.model --output_format=piece < $data/preprocessed/en-10k.prepieced > $data/preprocessed/en-10k.txt

# prepare remaining splits with learned models
for split in valid test tiny_train
do
    cat $base/data/en-fr/raw/$split.$src | perl moses_scripts/normalize-punctuation.perl -l $src | perl moses_scripts/tokenizer.perl -l $src -a -q | perl moses_scripts/truecase.perl --model $data/preprocessed/tm.$src > $data/preprocessed/$split.$src.prepieced
    cat $base/data/en-fr/raw/$split.$tgt | perl moses_scripts/normalize-punctuation.perl -l $tgt | perl moses_scripts/tokenizer.perl -l $tgt -a -q | perl moses_scripts/truecase.perl --model $data/preprocessed/tm.$tgt > $data/preprocessed/$split.$tgt.prepieced
    spm_encode --model=$pwd/$spm.model --output_format=piece < $data/preprocessed/$split.$src.prepieced > $data/preprocessed/$split.$src
    spm_encode --model=$pwd/$spm.model --output_format=piece < $data/preprocessed/$split.$tgt.prepieced > $data/preprocessed/$split.$tgt
    rm $data/preprocessed/$split.$src.prepieced
    rm $data/preprocessed/$split.$tgt.prepieced
done

# remove tmp files
#rm $data/preprocessed/train.$tgt.p
#rm $data/preprocessed/train.$src.prepieced
#rm $data/preprocessed/train.$src.p
#rm $data/preprocessed/train.$tgt.prepieced
#rm $data/preprocessed/en-10k.p
#rm $data/preprocessed/en-10k.prepieced

# preprocess all files for model training
python preprocess.py --target-lang $tgt --source-lang $src --dest-dir $data/prepared/ --train-prefix $data/preprocessed/train --valid-prefix $data/preprocessed/valid --test-prefix $data/preprocessed/test --tiny-train-prefix $data/preprocessed/tiny_train --threshold-src 1 --threshold-tgt 1 --num-words-src 4000 --num-words-tgt 4000

echo "done!"