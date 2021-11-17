#!/usr/bin/sh

mkdir -p translations/

alpha=0
for beam in 1 2 3 4 5 6 7 8; do
    python ../../translate_beam.py \
        --checkpoint-path bt_bytepair/checkpoints/checkpoint_best.pt \
        --data bt_bytepair/data/prepared \
        --dicts bt_bytepair/data/prepared \
        --beam-size "$beam" \
        --alpha $alpha \
        --batch-size 20 \
        --output "translations/beam$beam.alpha$alpha.en"
    bt_bytepair/postprocess_vanilla-spm.sh \
        "translations/beam$beam.alpha$alpha.en" \
        "translations/beam$beam.alpha$alpha.post.en" \
        "en" \
        "bt_bytepair/sp_models/sp.model"
done
