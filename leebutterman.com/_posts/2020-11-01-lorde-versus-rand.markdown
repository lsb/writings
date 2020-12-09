---
layout: post
date: 2020-11-01
title: Audre Lorde vs Ayn Rand—fine tuning GPT-2 and steering generation via GeDi on small data
---

# In short

Many popular language models, like GPT-2 and GPT-3, are powerful and realistic, and can generate [horrific output](/2020/10/02/gpt-3-unlearning.html).
[GeDi](https://blog.einstein.ai/gedi/) can train a small language model on two (or more) classes of text, like positive/negative movie reviews or toxic/nontoxic comments, and compare and contrast between them to guide a larger language model.
Instead of necessarily training on [twelve years of chewed-up internet](https://twitter.com/aparrish/status/1286808627530149888) or public domain books from a hundred years ago, we can use GeDi training on two small corpora of carefully curated copyrighted text, merely 25k words each, each a millionth the size of the original training corpus, and refine the output of a full-size GPT-2 model based on two authors to compare and contrast.
The results of generating with such a model, to compare and contrast a dozen of Audre Lorde's essays with Ayn Rand's speech of John Galt, are promising. Not only do the results highlight key differences between the authors, but some continuations from open-ended prompts comport with each author's viewpoints expressed outside of the training corpus.
[Try it yourself, let me know what you think!](/lorde-vs-rand/)

# GeDi

Comparing and contrasting two subjects is a [longstanding](https://en.wikisource.org/wiki/Parallel_Lives) approach for exploration, and [GeDi](https://blog.einstein.ai/gedi/)'s approach is flexible and effective. Given two possible classes of output (positive/negative, Author 1 / Author 2), GeDi computes the next-token probabilities conditional on each potential class, and uses Bayes' Rule to compute the class probability conditional on each next token. Crucially, if both models are trained on positive and negative movie reviews, the domain-specific high probabilities (like "cinematic") can cancel each other out, and the final class probability per token is maximized by the differences.

![predict the next word with two different probability distributions](/assets/gedi.png)

There are lots of adjustable tuning parameters with this approach, but this work uses the current defaults.

The GeDi paper demonstrates results on a corpus of news, with roughly 50k words of news in four different classes, on a corpus of positive and negative movie reviews, on a corpus of toxic and nontoxic internet comments.

# Training data

Most training datasets are like this: large corpora of public freely-usable data, either in the public domain (and thus a hundred years old) or presented anonymously. The results on finetuning a large GPT-2 model on 50k words seem promising enough to inspire training on even smaller corpora under copyright.

A brilliant author from the 20th century whose work is all too relevant to our current time is Audre Lorde, whose [essays and poetry have been recently collected by Roxane Gay](https://wwnorton.com/books/the-selected-works-of-audre-lorde), and whose core message has been that by embracing our differences we are stronger together, increasingly relevant in 2020.
Contrast that with another surprisingly-famous author from the 20th century, Ayn Rand, whose core message was selfishness, prioritizing individual ideas and individual interest, less relevant in our current age of multiple pandemics requiring fast collective action based on potentially-intentionally-obscured truth.

Rand, in Atlas Shrugged, gives her character John Galt a laborious speech to expound upon the Objectivist philosophy of selfishness; this is digitally available with a simple web search, and is 30k words. Many of the dozen Audre Lorde essays in Roxane Gay's collection are roughly a tenth as long, and are also available on the internet; some were undiscoverable by web search, and each took 10-15 minutes to type up, affording a close reading while doing so, feasible at small scale.

# Results

Starting with a prompt like "Dessert is delicious" and comparing the results gives a general flavor of the output.

The Lorde-style model output gives a supportive fruit smoothie recipe comment:

> Dessert is delicious!!! <br/> Rated 5 out of 5 by Anonymous from Delicious! I made this for my husband's birthday and he loved it. It was so easy to make, just a few ingredients. We used frozen strawberries and blueberries instead of fresh berries because we had them on hand but you can also use fresh berries if you don't have frozen strawberries or blueberries on hand. The flavor was great with the vanilla ice cream topping!

The Rand-style model output immediately hurtles into ethics abstractions, and men speaking to men negotiating work and pay and using characters from Charles Dickens:

> Dessert is delicious—to those who enjoy it. To those who don't—it's a sin." <br/> "I'll take that," said the man, and he went on eating. "You see, I've got no time to be playing games with these fellows; they're all out of work at the moment. If you'll give me half a day's pay for my services in getting them some food, I'll help you out as far as possible; but if you won't do it—you'd better give up your idea." <br/> "Give up your idea!" cried the other men in chorus: "we can't let him starve! We must have something to eat!" And they began talking about various ways and means of procuring provisions; but their ideas were not good enough to satisfy Mr. Pumblechook himself: he could see nothing but ruin! He thought that his own plan would be best for all parties concerned,—that by giving him half

When prompted by the horrific _The aged can now get cash lump sums to walk in and be mulched into a fine nutrient slurry. I think_, Lorde supports the elderly, and Rand starts worrying about fiscal responsibility.

> The aged can now get cash lump sums to walk in and be mulched into a fine nutrient slurry. I think we all need more elderly people on our streets, not fewer." <br/> The council has also been criticised for its decision to allow the use of "inappropriate" language during the consultation process. The council's website states: "We will not tolerate any form of hate crime or intimidation against anyone based on their ethnicity, gender identity or sexual orientation."

> The aged can now get cash lump sums to walk in and be mulched into a fine nutrient slurry. I think you will agree with me that they would give you more for the effort, but are willing to sacrifice your health if it is required. <br/> I have no intention of giving them any more than they are getting, but at the same time I am prepared to give them all I have on occasion. They will not get anything beyond their present income, but if you want them back when you die they will return your money as soon as possible after death and take care of yourself till then. If one wants a good life he must make his own way in this world without help from others; he cannot expect others to do it for him or even pay him enough so that he can live comfortably on what little is left over after paying his debts and expenses."

When prompted by the minimal prompt _How different_, Lorde steers generation towards a guide to female sexual dysfunction, whereas Rand steers generation toward a man's coming of age to be the most powerful man in the world.

> How different women experience sexual pleasure. <br/> Women's Sexual Pleasure: A Comprehensive Guide to Understanding and Treating Female Sexual Dysfunction, by Dr. Susan Love, Ph.D., is a comprehensive guide to understanding female sexual dysfunction and how it can affect your life in many ways including relationships with men, work/school performance, health issues such as depression or anxiety and more! This book will help you understand the causes of female sexual dysfunction so that you can take steps toward healing yourself from this condition!

> How different man has he been from his early days, when he was a mere boy? <br/> He is now the most powerful man in the world. He has made himself master of all that exists. He controls every atom and molecule of matter on earth, and can do so with an iron hand. His power is absolute; it cannot be questioned or resisted by any human being in this world or any other. The whole history of mankind up to this time shows that no one could resist him if he chose to use it against them; but now we see that even his enemies are afraid to oppose him because they know what might happen if they did so." (The Secret Doctrine, pgs 5-6)<br/>"I have seen men who were once my friends become my enemies because I dared question their authority over me." (The Secret Doctrine, pg 6)<br/>"I am not here today as a prophet nor as a teacher but rather as an observer who will record what

In the selection of Audre Lorde's essays there is rarely mention of money; in John Galt's speech there is rarely mention of police; nevertheless, when given the short prompt _It is indefensible that_, the Lorde model advocates for equal pay for equal work, and the Rand model advocates for a brutally powerful security apparatus.

> It is indefensible that women are still being paid less than men for the same work," she said.<br/> "Women in this country have been fighting for equal pay since before I was born."

> It is indefensible that man should be forced to live in a state of perpetual fear and uncertainty. The only way to ensure the security of our citizens is through an armed force, which can protect them from any threat."<br/>The government has been accused by some politicians and commentators of acting as if it was above the law. But Mr Hutton's statement shows that he does not want his government to be above the law, but will enforce every law with full force against those who violate it. He says: "If you commit an offence you must pay the penalty or risk imprisonment for life."<br/>He goes on: "You may think that criminals have no rights at all; but laws exist so that criminals cannot commit more offences in future without being punished themselves." He adds: "A free country cannot exist unless crime is prevented by punishment or deterrence." The British constitution has been designed so as to prevent such punishments from being inflicted, and even when a criminal commits an offence he risks

# Impacts

It is striking to see the gap between the genius of the training data of Audre Lorde's essays, and the relative inanity of the output of GPT-2, but this is just a version one. We can compare and contrast even the essays versus the poetry. We can train on other authors using similarly-small corpora of high quality texts. We can be much more intentional about whose labor enables our work, and we can resist the [default output trained on all the brilliance and the fake news and the hate speech from Reddit](/2020/10/02/gpt-3-unlearning.html).