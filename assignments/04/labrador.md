# Experimenting with Beam Search

<!-- Visualize Bleu-Scores in an appropriate plot --->
<!-- One or two paragraphs of analysis --->
<!-- - What happens to the brevity penalty with increasing beam size--->
<!-- - Plot with BLEU (y) and brevity penalty (x) --->
<!-- - Effect of larger beam size at decoding time --->

# Understanding the Code

1. **What is "go_slice" used for and what do its dimensions represent?** `go_slice`is two-dimensional tensor with the first dimension representing the batch size and the second dimension simply being 1, representing the initializing token of the decoded sentence. It consists of eos-symbols and is used as the first decoder input. 

2. **Why do we keep one top candidate more than the beam size?** When a token in the candidates is unknown, the next most likely token is used instead. However, if the last token of the beam is unknown, we need a final fallback token. Therefore, an additional token is remembered.

3. **Why do we add the node with a negative score?** So that the least likely states of the beam will get a higher score in the queue. When the queue is emptied, the items with the lowest scores are returned first, i.e. the most likely nodes.

4. **How are "add" and "add_final" different? What would happen if we did not make this distinction?** `add_final()` adds the EOS node not to the `nodes`-queue, but to the `final`-queue (and pads them to maximum length). If they would be simply added to the `nodes`-queue (using `add()`), the model might still be trying to continue on them. Additionally, they might get pruned, but we want to keep the finished sentences. 
 
5. **What happens internally when we prune our beams? How do we know we always maintain the best sequences?** When we prune, we retrieve the k best beam ends (nodes) with the highest likelihood (except for finished sentences). Finished sentences are stored, and all other nodes are discarded. This is facilated by using the `PriorityQueue` class, that uses the log-likelihood of the nodes as the priority metric.

6. **What is the purpose of this for loop?** 
This for loop strips away the padding, or more exact, strips away everything from the first eos-symbol on, which in most cases should only be padding.

# Adding Length Normalization

<!-- Find the optimal α value for the best beam size k from exercise 1 -->
<!-- Redo exercise 1, but this time with the new α. Does the best beam size k change? --->
<!-- - Visualizing BLEU-scores in an appropriate plot --->
<!-- - Discussion of the BLEU-scores --->
 
# Investigate the Diversity of Beam Search

<!-- With the best parameters (k,α) and normal beam search get n-best translation --->
<!-- With the best parameters (k,α) and diverse beam search get n-best translation --->

<!-- Compare the resulting translations --->
<!-- Experiment with different γ values (⚠⚠ Log Probabilities!) --->

<!-- Discuss findings --->
<!-- - Show examples --->
<!-- - Briefly explain diverse beam search implementation (could be done first) --->


