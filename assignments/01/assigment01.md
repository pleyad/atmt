# Assignment 01
*Andreas Säuberli, Niclas Bodenmann*

## Training

The last lines of our training log:

```
INFO: Epoch 087: loss 1.986 | lr 0.0003 | num_tokens 14.86 | batch_size 1 | grad_norm 63.93 | clip 0.9862                         
INFO: Epoch 087: valid_loss 2.61 | num_tokens 15.5 | batch_size 500 | valid_perplexity 13.6
```

## Evaluation

| Metric           | In-domain | Out-of-domain |
| ---------------- | --------- | ------------- |
| 1-gram precision | 35.3      | 18.1          |
| 2-gram precision | 18.2      | 2.2           |
| 3-gram precision | 11.1      | 0.2           |
| 4-gram precision | 7.0       | 0.0           |
| BLEU             | 14.9      | 0.6           |
