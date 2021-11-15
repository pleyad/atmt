infile=$1
outfile=$2
lang=$3
spm=$4

spm_decode --model=$spm --input_format=piece < $infile | perl moses_scripts/detruecase.perl | perl moses_scripts/detokenizer.perl -q -l $lang > $outfile
