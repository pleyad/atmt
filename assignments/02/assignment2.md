# Assignment 1

*Andreas Säuberli, Niclas Bodenmann*

## Experiment design

<!-- What are your thoughts on the experiment design? Does it make sense? Does it have any weaknesses that could be improved? -->

- It would be useful to know how large each of the small test sets are. If any of the length buckets contain only a few sentences, it may be better to adapt the test set splits to make them more representative.
- Long sentences probabilistically imply longer-distance dependencies, but depending on the data used, this may not consistently be the case. For example, it is possible that the longest sentences consist mainly of long lists of noun phrases, in which case there are only few long-distance dependencies. It might be more insightful to split the test data based on selected actual grammatical dependencies, for example by automatically parsing the sentences first and then splitting based on average distance of subject-verb dependencies. Then, it could also make sense to evaluate translation accuracies of these specific words/dependencies, not just applying BLEU to the entire sentence.
- The experiment design does not state whether the test sets were split based on the length of the source or target sentences. Since English and German may have different kinds of long-distance dependencies, appearing in different sentences, it would also be interesting to investigate whether long-distance dependencies are a bigger problem when they appear on the source side or the target side.
- It is not mentioned explicitly whether an attention mechanism is used for the RNNs and LSTMs. If no attention mechanism is used, RNNs and LSTMs may have a disadvantage, because they have to store the representation for the entire sentence in a fixed-length vector. Separating this effect from the dependency length effect by looking at the BLEU performance is going to difficult.

## Results

<!-- Discuss the results in detail. What do the graphs show? Did you expect this outcome? -->

- For short sentences: LSTM > RNN > SMT
- For longer sentences, LSTM and RNN quickly become worse, while SMT performance seems to be more resistant to increasing sentence length
- If dependency length was the only effect at play, we would expect LSTMs to shine in long sentences. While they do seem to perform much better than RNNs in sentences longer than 50 words (especially in the German → English direction), both neural models are worse than SMT for sentences longer than 90.
- TODO: Compare translation directions

## Conclusions

<!-- What conclusions can you draw from your results? How do these models handle long-distance dependencies? -->

- The results suggest that SMT is more resistant to sentence length than recurrent neural models. It is, however, unclear whether this is an effect of translation of long-distance dependencies, or whether the amount of information stored within long sentences is too much for the fixed-size vector representation of the recurrent neural models.
- Overall, LSTMs perform consistently better than RNNs, and both neural models perform better than SMT for short sentences.
- TODO: Conclusion about translation directions (if any)

## Further experiments

<!-- Are there any other experiments you could run to further back up your conclusions? -->

- TODO
