# Assignment 1

*Andreas Säuberli, Niclas Bodenmann*

## Experiment design

<!-- What are your thoughts on the experiment design? Does it make sense? Does it have any weaknesses that could be improved? -->

- It would be useful to know how large each of the small test sets are. If any of the length buckets contain only a few sentences, it may be better to adapt the test set splits to make them more representative.
- Long sentences probabilistically imply longer-distance dependencies, but depending on the data used, this may not consistently be the case. For example, it is possible that the longest sentences consist mainly of long lists of noun phrases, in which case there are only few long-distance dependencies. It might be more insightful to split the test data based on selected actual grammatical dependencies, for example by automatically parsing the sentences first and then splitting based on average distance of subject-verb dependencies. Then, it could also make sense to evaluate translation accuracies of these specific words/dependencies, not just applying BLEU to the entire sentence.
- The experiment design does not state whether the test sets were split based on the length of the source or target sentences. Since English and German may have different kinds of long-distance dependencies, appearing in different sentences, it would also be interesting to investigate whether long-distance dependencies are a bigger problem when they appear on the source side or the target side.
- It is not mentioned explicitly whether an attention mechanism is used for the RNNs and LSTMs. If no attention mechanism is used, RNNs and LSTMs may have a disadvantage, because they have to store the representation for the entire sentence in a fixed-length vector. Separating this effect from the dependency length effect by looking at the BLEU performance is going to difficult.
- The experiment uses hyperparameters that enabled the models to perform well in low-resource settings. It is unclear whether the performance of these hyperparameter configurations can be generalized to this task.

## Results

<!-- Discuss the results in detail. What do the graphs show? Did you expect this outcome? -->

- For short sentences: LSTM > RNN > SMT
- For longer sentences, LSTM and RNN quickly become worse, while SMT performance seems to be more resistant to increasing sentence length
- If dependency length was the only effect at play, we would expect LSTMs to shine in long sentences. While they do seem to perform much better than RNNs in sentences longer than 50 words (especially in the German → English direction), both neural models are worse than SMT for sentences longer than 90.
- It is interesting to note how the neural models seem to perform in the different translation directions. Translating from German → English, the two models seem to plateau for longer before quickly declining. In contrast, from English → German, the decline of performance appears to be more steadily with an earlier onset. This might be a quirk of the data, but it also begs to hypothesize: Maybe the models are working better for longer when they can decode to weakly inflected languages with little syntactic long-distance dependencies. However, maybe this better performance might not be the expression of a better translation, but of the bias introduced by the evaluation metric, BLEU in this example (see Reiter 2018). In either case, further experiments would be needed to gain a deeper understanding of the different behaviours.
- The BLEU score is aggregated for all sentences in the respective tests sets. This is necessary for visualization and for seeing the grand trends. However, because the variance across a single test set is not shown, our insights are limited. Are all long sentences causing problems? Or is it only very specific types of long sentences that drag our metrics down?

## Conclusions

<!-- What conclusions can you draw from your results? How do these models handle long-distance dependencies? -->

- The results suggest that SMT is more resistant to sentence length than recurrent neural models. It is, however, unclear whether this is an effect of translation of long-distance dependencies, or whether the amount of information stored within long sentences is too much for the fixed-size vector representation of the recurrent neural models.
- Overall, LSTMs perform consistently better than RNNs, and both neural models perform better than SMT for short sentences.
- The neural models can hold their quality for longer when translating from the more synthetic language (German) to the weakly inflected language (English) than vice versa. See the previous section for a discussion of possible reasons.

## Further experiments

<!-- Are there any other experiments you could run to further back up your conclusions? -->

- Tests with different scoring metrics, maybe even human evaluation, can help to rule out any possible biases introduced by BLEU.
- In addition to the mean, it might be of interest to also plot the variance a specific model has on a specific test set. The visualization probably won't look as good in a paper, but we might get evidence and motivation to analyze further.
- We might curate different challenge sets that contain very specific types of long-distance dependencies. Qualitatively analyzing the results of the models on these sets might yield a deeper understanding on whether the problem is constricted to very speific types of dependencies or whether it is a general problem.
- Are the neural models getting worse because of the long-distance dependencies or because they only have limited space in their latent vector? We might test this question by creating a test set with very long sentences without long-range dependencies. Sentences with an absolute godforsaken abundance of coordinating conjunctions might do the trick (e.g. *Tina went to the movies and Jonathan ate a hamburger and Ehud wrote a paper and Andreas worked on an assignment and Niclas had a manic episode and Tannon questioned the necessity of an example and ...*).

## References

Reiter, Ehud (2018): A Structured Review of the Validity of BLEU. In: Computational Linguistics 44 (3). S. 393-401. https://doi.org/10.1162/coli_a_00322.
