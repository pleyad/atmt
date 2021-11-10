# Assignment 3
*Niclas Bodenmann (nibode), Andreas Säuberli (asaeub)*

## Requirements

- Test set translation (both models)
- Any code changes
- Pre-/Postprocessing scripts
- PDF Report (2-3 pages with figures)

## A detailed description of your experiment setup

- Why did you choose these two strategies?
- What data did you use?
- How did you preprocess the data?
- What changes did you make in the code?
- Which hyper-parameters did you use for training your nodels?
- What training commands did you use?
- How did you evaluate your models?
- ...

### Model 1: Sentencepiece

The first model uses bytepair-encoding to preprocess the data. We hoped to capture additional morphological information, which would help with unknown words and therefore improve the baseline model.

Hyperparameters:
- 4000 symbols.
- Trained on both the source and target language.


## A suitable presentation and discussion of your results in comparison to the baseline

### Sacrebleu Metrics

#### Baseline
```
{
 "name": "BLEU",
 "score": 16.8,
 "signature": "nrefs:1|case:mixed|eff:no|tok:13a|smooth:exp|version:2.0.0",
 "verbose_score": "44.0/22.1/12.2/6.7 (BP = 1.000 ratio = 1.341 hyp_len = 5218 ref_len = 3892)",
 "nrefs": "1",
 "case": "mixed",
 "eff": "no",
 "tok": "13a",
 "smooth": "exp",
 "version": "2.0.0"
}
```

#### Sentencepiece Tokenization

```
{
 "name": "BLEU",
 "score": 15.1,
 "signature": "nrefs:1|case:mixed|eff:no|tok:13a|smooth:exp|version:2.0.0",
 "verbose_score": "41.9/20.2/11.1/5.6 (BP = 1.000 ratio = 1.335 hyp_len = 5197 ref_len = 3892)",
 "nrefs": "1",
 "case": "mixed",
 "eff": "no",
 "tok": "13a",
 "smooth": "exp",
 "version": "2.0.0"
}
```

We noticed that the test set does not contain any unknown words, and therefore there is less reason to apply a subword encoding. This may be an explanation why the sentencepiece tokenization model did not perform better than the baseline.

- Tables
- Visualizations
    - Graphs for sentence lengths? (NB)
    - Graphs for quality based on the rarity of the words in the training data? (NB)
- Qualitative Analysis
- ...

## A final remark

- What we learned
- What we would do differently next time
