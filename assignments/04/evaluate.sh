#!/usr/bin/sh

for translation in $(ls translations/*.post.en); do
    sacrebleu bt_bytepair/data/raw/test.en < $translation > $translation.bleu
done
