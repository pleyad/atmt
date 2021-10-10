# Assignment 1

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

## Questions

### What characteristics of the in-domain data could be responsible for the high scores?

- Low diversity of data (i.e. small range of vocabulary, structures, and meanings) due to heavily restricted domain
- Large overlap between train and test sets
- Many short sentences, which are easier to translate (e.g. headings or contact details)

### Why is the out-of-domain test set so much harder to translate?

Because it contains both words and meanings that probably weren't present in the training data. This is quite likely, as *infopankki* consists of governmental information while the *bible* is a religious text. 

The reference translations of the bible test set actually show very domain-specific words and names (such as *smite*, *myrrh* or *Absolem*), very domain-specific inflections and forms (*thou*, *thee*, *wilt*, *hath*, ...) and very domain-specific phrases (*say something unto someone*, *someone shall do something*, ...). The training data being as restricted as it is, all of the above combined completely derail the model.

With our model, the translations are so far off that it's actually near impossible to link translations and references without using the line number.

| Line Number | Translation | Reference |
|--|--|--|
| 205 | The City of Helsinki pays the: | And said, Hail, King of the Jews! and they smote him with their hands. |
| 416 | You will be given a job in the country for the same time to be in the country in the country in which the country in which you are in the country in the country. | To crush under foot all the prisoners of the earth, |
| 498 | And you are planning to take care of the baby and make a business plan for the time and you are planning to make a business.| You shall bring his sons, and put coats on them. |

Although we might find semantic parallels (*take care of the baby* <-> *sons, and put coats on them*), these parallels might well be due to chance and confirmation bias.

### 3 Words (German) that might get translated differently to English depending on the context

| Word | Meanings | Different Contexts |
|-|-|-|
| *Bank* | A place to sit, or a place to deposit money and lose it in the next crisis where no banker will get punished for their nefarious deeds. | If we train a model on data from a landscaping magazine, we might quite possibly only find the meaning of *Bank* as in bench. On the other hand, if trained only on the economy section of the "Frankfurter Allgemeine Zeitung", we might only capture the word sense of *Bank* as, well, a bank (money institute). |
| *Himmel* | *Heaven* or *Sky* | If trained on an astronomers notebooks, a model might only know *Himmel* as refering to the (night) sky. But if only trained on the musings of a medieval theologian, the model might only connect *Himmel* with its eschatological sense: *Heaven*.|
| *hören* | *hear* or *listen* | Here, the choice of translation is mostly conditioned by the immediate (within-sentence) context and not by domain. We expect to find both translations in about the same ratio across domains, so domain-specific training may not help. |

### How do your examples fit into the discussion of in-domain vs. out-of-domain?

Depending on the domain of data, some word forms might only be used in very specific senses. In consequence, a model training on solely this data will only learn  representations of the words that represent this very specific relationship, possibly ignoring all other meanings the word form has in a broader discourse.

This becomes very apparent in out-of-domain machine translation. We can think of a case where the target language might draw a distinction between two different meanings (*A* and *B*) by using different word forms to denote them (*tA* and *tB*). The source language in turn might use a homonym for the same two concepts (*sAB*). If a model is now trained on a domain where only meaning *A* is used, the model only learns the connection (*sAB* -> *tA*). Now, if the out-of-domain meaning *B* is evoked during testing or deployment, the model will still translate *sAB* to *tA*, even though only *tB* would be correct.

### Can you think of a possible way to ensure a specific translation for a word is used by an NMT model?

We can ensure the right translation only by having a trained human translator. However, we can make the right translation much more likely if we use smartly balanced training data from the some domain(s) where we wish to deploy the system in the future. There are also methods to "force" the model to always translate a certain word using a pre-defined translation, for example by inserting the translation in the input sentence (Dinu et al. 2019).

## References

- Dinu, G., Mathur, P., Federico, M., & Al-Onaizan, Y. (2019, July). Training Neural Machine Translation to Apply Terminology Constraints. In Proceedings of the 57th Annual Meeting of the Association for Computational Linguistics (pp. 3063-3068).
