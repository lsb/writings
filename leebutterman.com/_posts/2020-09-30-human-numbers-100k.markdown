---
layout: post
date: 2020-09-30
title: Human numbers 100k, a dataset of integers written out in American English
---

# You might find it useful when tinkering around with natural language models!

[Download it from GitHub today!](https://github.com/lsb/human-numbers)

## Sample

```
$ tail one-hundred-thousand-numbers.txt 
ninety nine thousand nine hundred ninety
ninety nine thousand nine hundred ninety one
ninety nine thousand nine hundred ninety two
ninety nine thousand nine hundred ninety three
ninety nine thousand nine hundred ninety four
ninety nine thousand nine hundred ninety five
ninety nine thousand nine hundred ninety six
ninety nine thousand nine hundred ninety seven
ninety nine thousand nine hundred ninety eight
ninety nine thousand nine hundred ninety nine
```

Inspired by the `HUMAN_NUMBERS` dataset from _fast.ai_, this is a dataset of human numbers in three sizes: 100K / 1M / 10M.

## As straightforward as it seems

It's much smaller than other databases full of natural language text, and the vocabulary is much more constrained (even more constrained than the Simple English Wikipedia), so it can train much faster, and can be useful for running arbitrary experiments.

## Origins

The text comes from [js-written-number](https://github.com/yamadapc/js-written-number), and is minimally preprocessed from the default output. We remove the "and" between hundreds and tens (`nine hundred and ninety` → `nine hundred ninety`), and we remove the hyphen between tens and ones (`ninety-nine` → `ninety nine`). The "and" is often elided, and colloquial written American English has elided hyphens and diacritics for a long time now (it does not take a committee to coördinate this over e-mail to confirm this trend).

## Datasheet

Many times, datasets are created without explicitly stating what they are good for, and what they _aren't_ good for, and there have been significant attempts to [bring the people back in](https://arxiv.org/abs/2007.07399) to the construction of datasets and creation of meaning around the datasets. Inspired by a push to make the creation of datasets more intentional by creating [datasheets for datasets](https://arxiv.org/abs/1803.09010), the readme for the repository is its datasheet.

Notably, it took a few minutes to run some nodejs and dump the output to a few files on disk, but it took significantly longer to [reflect on the uses](https://twitter.com/jewelbarnettphd/status/1304282780306567170) of the data, even for a straightforwardly synthetic dataset like spelled-out integers. The dataset seems unlikely to be used for anything except training models on toy datasets, but it is important to note that the nodejs code that generated the synthetic data is multilingual, not only English, not only Indo-European languages, but worldwide, and to use the spellings of numbers as normative would be a mistake. Specifically, using it to police people saying _ninety lakh_ instead of _nine million_ would be an egregious possible misuse of the dataset.

## Why you might want to use it

The _fast.ai_ human numbers dataset, with 10k numbers spelled out, is publicly available, so why use this? If you are training on a certain class of numbers that appears rarely, and you want your model to recognize them, you might require more training data. The 10M numbers size has over 98 million words, and is ~650MB uncompressed; there are natural language benchmark datasets that are smaller than that, and a user of this dataset would most probably use the 100K, with 620K words and 4MB uncompressed, to have ten times as many integers as the 10k, but still much less than other unconstrained natural language datasets.

Give it a try 🙂 and let me know what you think!
