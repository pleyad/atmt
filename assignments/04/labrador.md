# Experimenting with Beam Search

<!-- Visualize Bleu-Scores in an appropriate plot --->
<!-- One or two paragraphs of analysis --->
<!-- - What happens to the brevity penalty with increasing beam size--->
<!-- - Plot with BLEU (y) and brevity penalty (x) --->
<!-- - Effect of larger beam size at decoding time --->

# Understanding the Code

1. What is "go_slice" used for and what do its dimensions represent?
2. Why do we keep one top candidate more than the beam size?
3. Why do we add the node with a negative score?
4. How are "add" and "add_final" different? What would happen if we did not make this distinction?
5. What happens internally when we prune our beams? How do we know we always maintain the best sequences?
6. What is the purpose of this for loop?
# Adding Length Normalization

<!-- Find the optimal α value for the best beam size k from exercise 1 -->
<!-- Redo exercise 1, but this time with the new α. Does the best beam size k change? --->
<!-- - Visualizing BLEU-scores in an appropriate plot --->
<!-- - Discussion of the BLEU-scores --->
 
# Incestigate the Diversity of Beam Search

<!-- With the best parameters (k,α) and normal beam search get n-best translation --->
<!-- With the best parameters (k,α) and diverse beam search get n-best translation --->

<!-- Compare the resulting translations --->
<!-- Experiment with different γ values (⚠⚠ Log Probabilities!) --->

<!-- Discuss findings --->
<!-- - Show examples --->
<!-- - Briefly explain diverse beam search implementation (could be done first) --->


