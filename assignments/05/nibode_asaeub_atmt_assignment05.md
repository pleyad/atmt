---
title: Assignment 5
author:
    - Andreas Säuberli (asaeub)
    - Niclas Bodenmann (nibode)
date: 21 December, 2021
documentclass: scrartcl
numbersections: true
header-includes: \usepackage{libertine}
---

# True or False

a) *Simultaneous machine translation is especially challenging if the source and target language have different word order.*

**True.** If the word order is different, the system needs to predict words in the target language whose corresponding words in source language have not been read in yet.

b) *The fact that a sentence can have multiple good translations makes training of neural machine translation systems easier.*

**False.** MT training usually optimizes parameters towards a single correct solution. Therefore, the model is sometimes punished for good translation, just because they differ from the reference, which is not ideal.

c) *A neural machine translation model cannot learn to disambiguate homographs.*

**False.** Information from the surrounding context can be used to disambiguate the meaning of words.

d) *Length normalization will increase the average length of translations.*

**True.** In beam search, scores (i.e. probabilities) for hypotheses decrease continuously. Therefore, if an EOS symbol is produced too early, this hypothesis is likely to have a higher score/probability than the longer ones. Length normalizes can balance out this bias.

e) *You recently conducted some experiments in which your model achieved state-of-the-art results according to BLEU scores. A subsequent human evaluation also showed that there was no significant difference in annotators’ preference between sentences translated by the model and the human reference sentences. You can now publish a paper claiming that a machine can translate as well as a human?*

**False.** Many translation mistakes only manifest when we look at texts beyond the sentence level. For example, consistency of terminology or discourse coherence can only be judged on the document level. Therefore, claiming human parity based on single sentences is not sufficient.

# Language Representations

a) *How are words represented internally in a word-level neural language or translation model?  Discuss both input and output words (no equations or diagrams are required).*

In a standard word-level neural language model, words are first input as one-hot vectors (of source vocabulary size), which are then transformed into dense word embeddings in continuous vector space. On the output side, for each time-step, the softmax function is used to predict a probability distribution, which is trained to resemble the one-hot representation (of target vocabulary size) again. From this representation, the correct word can then be selected by choosing the most probable index, or by sampling from the resulting distribution.

b) *What are the consequences (in terms of computational complexity) of increasing the network vocabulary size in neural machine translation?*

The space complexity would increase, as a larger vocabulary size would require a larger embedding matrix, leading to more parameters and resulting in increased memory usage. However, the time complexity wouldn't increase, as there are no more steps of computation to do than before: Even if embedding is implemented using matrix multiplication instead of lookups, this operation can be fully parallelized.

# Sequence-to-Sequence Models

a) *Explain why an encoder-decoder model is essential for the task of translation compared to language modelling. Use a concrete example and an illustration to support your answer.*

Language model training assumes the same length of input and output (they are the same, just shifted by one word), which allows for a simpler architecture. MT can't make this assumption, as a target translation most often consists of a different number of tokens from the source sentence. Therefore, translation needs to generate a sequence that is unconstrained by the length of the source sentence, which can be realized using an encoder-decoder architecture.

![Architecture comparison (decoder inputs are omitted in the encoder-decoder model)](lm-vs-encdec.png)

b) *Describe another NLP task where using a sequence-to-sequence model would not be appropriate. Why is this the case and how else would you model the task? What would be the inputs and outputs to your model?*

A sequence-to-sequence model would be unsuitable for text classification, as this is actually a sequence-to-single-label-task. The input would still be a sequence of words (i.e. one-hot vectors or embeddings), but the output would map to a single vector, with the length being the number of labels.

# Open Vocabulary Translation

a) *What problem does subword-level NMT aim to solve and how?*

It aims to solve the problem of unknown (out-of-vocabulary) words, by splitting words into their most common components and training with these components (subwords) as the input and output tokens. This way, every word, even unknown ones, can be represented as subwords which the model has seen during training. Therefore, the model might still be able to capture some information from its subwords.

b) *Why might you want to use a smaller subword vocabulary size in a low-resource scenario?*

By using a smaller subword vocabulary, we force the model to generalize more. This can be beneficial for low-resource settings, where models are prone to overfitting. Moreover, there will inevitably be more unknown words at test time, and smaller subword vocabularies will likely lead to better representations for the smaller components of these words. For example, take the word *dislike*. With a very large subword vocabulary, it might get represented by a single subword. The model might never be able to learn the meaning of the negating prefix *dis-*, and words which have not been seen in the training data with this prefix (e.g. *disingenuous*) will be represented with subwords that the model knows less about.

c) *What might be some of the problems related to sharing a single subword model across 100 languages in recently proposed massively multilingual neural machine translation models?*

- If the subword merge operations are done on Unicode character level, the vocabulary will be quite large, as the languages probably use many different writing systems, including ones with thousands of different single characters such as Chinese.
- As each character pair in writing systems with a larger number of basic characters will be less frequent than character pairs in smaller writing systems. This might mean that the larger writing systems will "occupy" disproportionately more parameters in the model. A lot of these parameters will probably be trained badly, because there these subwords appear less often in the training data.
- As there is little to no overlap between similar/related words in different writing systems. Therefore, the model cannot benefit from representing e.g. loanwords using the same subwords in different languages.

# NMT Architectures

a) *Complex recurrent units like the LSTM and GRU rely on gates to control the flow of information. What output range are gates typically intended to have, and what activation function(s) can be used to achieve this?*

We usually want gates to determine *how much* of a signal should pass through it, ranging from 0 (nothing) to 1 (everything). We can achieve this with the sigmoid function ($\sigma$). $\sigma$ squashes the input to a value between 0 and 1, 0 mapping to 0.5, positive numbers to values > 0.5 and negative numbers to values < 0.5.

b) *Name two “building blocks” of the Transformer and explain what each block does in 2 to 3 sentences.*

**Positional encoding:** Tokens are combined with a positional encoding, so that the model has a way of accessing the (relative) positions of the tokens, even if there is no recurrence and therefore no inherent ordering in the input sequence. Usually, a combination of several sinewave functions is used as the positional encoding.

**Attention head:** A single attention head determines how much influence (i.e. attention) which token vectors in the previous layer have when computing a new contextualized token vector in the current layer. Because this composition function is parameterized and can be learned, multiple attention heads with different initializations will learn to attend to different aspects or properties of the input.

c) *Self-attention networks such as the Transformer use masking in the decoder to ignore any words or hidden states after the current time step. Peter experiments with this, and notices that his cross-entropy at training time improves when he removes masking. Why is masking used, and what are the consequences of removing it?*

Masking is used so that the model cannot "cheat" by looking at future timesteps while decoding the output sequence. During training, we use the reference translation as input for the decoder (at least in teacher-forcing), we need to make sure that it does not simply copy the reference tokens from the future, as it will not be able to do that at test time. The cross-entropy loss improves when the model is able to access the solution it is trained to predict, but we prevent it from doing so by masking input tokens at future timesteps.

d) *If you were presented with the following results of an RNN-based, CNN-based and a Transformer-based machine translation system on the same test set, what conclusions would you draw from the experiment? What additional information would you request about the experiment to make your decision easier?*

| Model | BLEU |
| --- | --- |
| RNN | 28.3 |
| CNN | 29.7 |
| Transformer | 31.2 |

It is difficult to guess whether the differences between the models are significant, as the BLEU scores are quite close to each other. Depending on the size and nature of the training and test data, variance between different training runs may be quite large, which would make the differences insignificant. Also, to be able to compare the model architectures, we would like to know the exact hyperparameters of the models, to see whether the number of parameters is comparable, and to find out how the hyperparameters have been optimized. It would also be important to know about the domain and preprocessing of the training and test data, because some architectures may have an advantage in processing certain properties of data (e.g. variability, long-distance dependencies, etc.).

# Learning from Monolingual or Multilingual Data

a) *Briefly summarize the idea behind trying to leverage monolingual data in NMT and explain the differences between the following two techniques that aim to do this:*
    - *Combining MT with Autoencoding*
    - *Backtranslation*

Using monolingual data can improve the performance of MT models, especially if little parallel data is available. For example, it can be used to help train the encoder and decoder components of the model (e.g. using autoencoding), or to generate synthetic parallel data to get more training samples.

**Autoencoding** can be used as an additional task during training in parallel to MT, in a multi-task setting. The goal is to improve the representations produced by the encoder by training in an autoencoder it to reconstruct the source sequence, using additional data in the source language. The same can be done with the decoder, using it as the decoder part in an autoencoder for the target language.

**Backtranslation** is a way to generate synthetic data to augment the training set. The idea is to use a second (low-quality) translation system to translate monolingual data from the target language into the source language and adding the resulting parallel samples to the training data. For example, when we are interested in translating from English to Quechua, but there is very little parallel data, we could use a system that translates from Quechua into English to generate additional parallel data.

b) *Give two motivations for multilingual NMT and provide examples to support your claims.*

- By using multilingual MT systems, we can avoid having to train separate models for many language pairs or using a pivot language (where important information can be lost through re-translation). Instead, we can train a single model (or at least a smaller number of models) to translate from and to several languages.
- Training the model to use more language-independent representations through parameter sharing between languages can result in performance gains, especially for low-resource language pairs. For example, similar words or grammatical structures may be translated better in low-resource languages when they have already been learned in higher-resource languages. Moreover, language-independent representations will be less domain-specific, which can help when some languages only have training data in a particular domain.

c) *Describe how multi-source, multi-way and massively multilingual models differ and how do they aim to improve translation?*

- For $n$ source languages, **multi-source models** use $n$ encoders and a single decoder. The input is the same sentence in $n$ source languages, and the representations produced by the $n$ encoders are combined before passing them to the decoder. Providing the same input sentence in several languages at the same time which can help disambiguation.
- For $n$ source languages and $m$ target languages, **multi-way models** use $n$ encoders and $m$ decoders. The input is a single sentence in a source language, passed through the encoder of the corresponsing language, and then through the decoder of the desired target language. This way, $n \times m$ language pairs can be translated (theoretically even zero-shot). Language-independent intermediate representations are inforced, which can help translation quality (see above).
- **Massively multilingual models** use only a single encoder and decoder for many source and target language. The input is a single sentence in a source language, prefixed with a special token denoting the desired target language. Therefore, all parameters both in the encoder and in the decoder are shared between all language pairs. The goal is that the languages benefit from each other, and that structural and lexical overlaps between languages can be optimally exploited (see above), while only training a single model. Zero-shot translations are theoretically possible.

# Advanced Training Objectives

a) *Explain the following concepts in 2 to 3 sentences and describe how they are linked:*
    - *Exposure bias*
    - *Teacher forcing*
    - *Minimum Risk Training*

**Teacher forcing** is a way to train a NMT model by feeding it not its own predictions as the history at a given timestep, but actually the true labels from the gold standard. We hope that the model isn‘t thrown off by its own initial garbage predictions. However, with this training regime, **exposure bias** arises, because the model is fed (exposed to) data during training that it might not see during test time, because it is not able to produce the reference translation perfectly. It might rely too much on the "support wheels" that the teacher forcing provides, without having learned to be more robust/resilient against its own mistakes. **Minimum risk training** is an alternative learning objective that circumvents teacher forcing and its risk of exposure bias. With minimum risk training, we use some measure of translation quality (e.g. BLEU) as a loss function and train the model to predict hypotheses of higher quality with a higher probability than hypotheses of lower quality. We hope that this helps with the shortcomings of maximum likelihood estimation and more directly takes translation quality into account.

b) *Explain the difference between label smoothing and word-level knowledge distillation. Use an example to illustrate your answer.*

**Label smoothing** is a technique that reserves a small portion of the probability space and distributes it among the incorrect labels (i.e. target tokens). This may help because we do not want our model to focus on learning "hard" one-hot outputs as this can lead to very large weight values which are not ideal for backpropagation. Instead, we want the model to aim for very confident, but not perfect predictions. **Word-level knowledge distillation** is similar to label smoothing in the way it departs from one-hot vectors as the target label, but instead of transforming the one-hot vector, it uses the probability distribution predicted by a teacher network as the true target distribution. Both use cross-entropy to optimize the fit between the predicted and the true target distriution.

![One-hot label vs. smoothed label vs. label from teacher network](smooth-labels.png)

# Linguistic Phenomena

a) *You trained a sentence-based neural machine translation system from English to French. When looking through the translations you find that the model does not produce verb forms that consistently agree with the gender of the speaker. Describe a strategy for how you could retrain your system such that it allows you to control better which form is produced in the translation? What changes do you need to make to your system? What is a disadvantage of your chosen strategy?*

To be able to produce consistent gender agreement across sentence borders, the model would have to integrate document-level information. We could do this by switching the entire MT paradigm to translating on the document-level, by training on parallel documents instead of sentences, However, this would require retraining the model. Alternatively, we could use a post-processing model, which takes the MT output sentence of adjacent sentences (which were translated independently of each other), and "repairs" them to correct the inconsistently translated gender markers/pronouns. This model can be trained from the output of our MT system and true target sentences, as long as the speaker is the same for all sentences.

b) *How would you evaluate your new system? In which cases would you recommend an automatic strategy and in which cases a would you recommend human evaluation?*

To evaluate the model, we could automatically annotate all the relevant gender markers and pronouns, and then test whether the system translates these correctly. This would require quite a complex system to detect the specific pronouns which are coreferent with the speaker, and may not result in a reliable evaluation metric. For evaluating on test data with complex coreference relations, it would be preferable to use human annotators to do this. Alternatively, we could use minimal pairs contrastive sentences, where we collect a corpus of pairs of correct and incorrect translations of pronouns or gender markers, and ask the model which of the translations it would predict with a larger probability.

c) *Do you think a system with more context than one sentence could handle this agreement better than a sentence-level system? What kind of context would you use in this case to train such a system?*

Yes, since cues about the speaker's gender can often be found in the surrounding context. Our examples above already provide two ways to do this: Either by using the entire document as the MT input, which may require a very large model and more data, or by using context from the two surrounding sentences for automatic post-editing. The second option would provide more flexibility, as it can be added to any sentence-level MT model, at the cost of increased time complexity.
