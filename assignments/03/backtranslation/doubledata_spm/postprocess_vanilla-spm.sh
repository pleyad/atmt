infile=$1
outfile=$2
lang=$3
spm=$4

pwd=`dirname "$(readlink -f "$0")"`
base=$pwd/../../../..

spm_decode --model=$spm --input_format=piece < $infile | perl $base/moses_scripts/detruecase.perl | perl $base/moses_scripts/detokenizer.perl -q -l $lang > $outfile
