# Assignment 01
*Andreas Säuberli, Niclas Bodenmann*

### 2.2 Training

The last line of our training log:

```
INFO: Epoch 046: loss 5.358 | lr 0.0003 | num_tokens 14.86 | batch_size 1 | grad_norm 52.76 | clip 0.9984                             
INFO: Epoch 046: valid_loss 4.77 | num_tokens 15.5 | batch_size 500 | valid_perplexity 118
```

## 3 Evaluating the NMT System

### 3.1 In-domain Evaluation

BLEU: 14.9

```
{
 "name": "BLEU",
 "score": 14.9,
 "signature": "nrefs:1|case:mixed|eff:no|tok:13a|smooth:exp|version:2.0.0",
 "verbose_score": "35.3/18.2/11.1/7.0 (BP = 1.000 ratio = 1.473 hyp_len = 10248 ref_len = 6957)",
 "nrefs": "1",
 "case": "mixed",
 "eff": "no",
 "tok": "13a",
 "smooth": "exp",
 "version": "2.0.0"
}
```

### 3.2 Out-of-domain Evaluation

BLEU: 0.6

```
{
 "name": "BLEU",
 "score": 0.6,
 "signature": "nrefs:1|case:mixed|eff:no|tok:13a|smooth:exp|version:2.0.0",
 "verbose_score": "18.1/2.2/0.2/0.0 (BP = 1.000 ratio = 1.373 hyp_len = 20065 ref_len = 14614)",
 "nrefs": "1",
 "case": "mixed",
 "eff": "no",
 "tok": "13a",
 "smooth": "exp",
 "version": "2.0.0"
}
```

### 3 Submission

#### Table of the Scores

|                  | In-domain | Out-of-domain |
|------------------|-----------|---------------|
| BLEU             |    14.9   |        0.6    |
| 1-gram precision |      35.3 |    18.1       |
| 2-gram precision |      18.2 |    2.2        |
| 3-gram precision |      11.1 |    0.2        |
| 4-gram precision |      7.0  |    0.0        |

#### What Characteristics of the In-domain data could be responsible for the high scores?

Relatively long sentences in comparison to the reference translations.

#### Why is the out-of-domain test set so much harder to translate?

Because it contains both words and meanings that probably weren't present in the training data. This is quite likely, as *infopankki* consists of governmental information while the *bible* is a religious text.

[Examples from the test set]

### 3 Words (German) that might get translated differently to english depending on the context

[Examples ]
[What has this to do with in-domain out-of-domain]
[How can we ensure a specific translation?]

