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

The reference translations of the bible test set actually show very domain-specific words and names (such as *smite*, *myrrh* or *Absolem*), very domain-specific inflections and forms (*thou*, *thee*, *wilt*, *hath*, ...) and very domain-specific phrases (*say something unto someone*, *someone shall do something*, ...). The model being as simple as it is, all of the above combined completely derail it.

With our model, the translations are so far off that it's actually near impossible to link translations and references wihtout using the line number.

| Line Number | Translation | Reference |
|--|--|--|
| 205 | The City of Helsinki pays the: | And said, Hail, King of the Jews! and they smote him with their hands. |
| 416 | You will be given a job in the country for the same time to be in the country in the country in which the country in which you are in the country in the country. | To crush under foot all the prisoners of the earth, |
| 205 | And you are planning to take care of the baby and make a business plan for the time and you are planning to make a business.| You shall bring his sons, and put coats on them. |

Although we might find semantic parallels (*take care of the baby* <-> *sons, and put coats on them*), these parallels might well be due to chance and confirmation bias.

### 3 Words (German) that might get translated differently to english depending on the context

| Word | Meanings | Different Contexts |
|-|-|-|
| *Bank* | A place to sit, or a place to deposit money and lose it in the next crisis where no banker will get punished for their nefarious deeds. | If we train a model on data from a landscapin magazine, we might quite possibly only find the meaning of *Bank* as in bench. On the other hand, if trained only on the economy section of the "Frankfurter Allgemeine Zeitung", we might only capture the word sense of *Bank* as, well, a bank (money institute). |
| *Himmel* | *Heaven* or *Sky* | If trained on an astronomers notebooks, a model might only know *Himmel* as refering to the (night) sky. But if only trained on the musings of a medieval theologian, the model might only connect *Himmel* with its eschatological sense: *Heaven*.|
| *Bank* ||

Depending on the domain of data, some word forms might only be used in very specific senses. In consequence, a model training on solely this data will only learn  representations of the words that represent this very specific relationship, possibly ignoring all other meanings the word form has in a broader discourse.

This becomes very apparent in out-of-domain machine translation.
We can think of a case where the target language might draw a distinction between two different meanings (*A* and *B*) by using different word forms to denote them (*tA* and *tB*). The source language in turn might use a homonym for the same two concepts (*sAB*). If a model is now trained on a domain where only meaning *A* is used, the model only learns the connection (*sAB* -> *tA*). Now, if the out-of-domain meaning *B* is evoked during testing or deployment, the model will still translate *sAB* to *tA*, even though only *tB* would be correct.

We can ensure the right translation only by having a trained human translator. However, we can make the right translation much more likely if we use smartly balanced training data from the some domain(s) where we wish to deploy the system in the future.

