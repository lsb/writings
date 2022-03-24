---
layout: post
date: 2021-05-01
title: Dactyloglyphomancy uses crypto for divination
---

# Like an [amulet](https://text.bargains/amulet/), brute force a string to a particular hash via emoji, and use the emoji for divination.

## Bibliomancy: a time-honored tradition

Foretell the future through the text of a book in a few easy steps!

1. Choose a _significant_ book, and ask the book a question about the future.
2. Open the book to a random page. Point to a random passage.
3. Because of the book's magic powers, that passage has an oblique answer to your question.

People have used Vergil's Aeneid, the Bible, and many other books for exactly this purpose.

We will use a similar concept: instead of divination through books, we will perform divination through fingerprints: dactyloglyphomancy.

## Amulets

From https://text.bargains/amulet/:

> An amulet is a kind of poem that depends on language, code, and luck. To qualify, a poem must satisfy these criteria:
>
> Its complete Unicode text is 64 bytes or less.
>
> The hexadecimal SHA-256 hash of the text includes four or more 8s in a row.
>
> …
>
> And, while this isn’t part of the formal definition, it’s important to say that an amulet of any rarity should be judged by its overall effect, with consideration for both its linguistic and typographic qualities. In particular, an amulet’s whitespace, punctuation, and diacritics should all be “load bearing”.

This is presumably so that an amulet will not be stuffed with zero-width nonjoiners, or be something like "lol butts 61140978758" (02c9­ecef­4bfd­a53a­3152­01bc­b728­12<span style="font-weight:bold;color:red">8888888888</span>eed3­b65d­7bc0­bcf5­dae0­ec2e) or just "2021-10-31T09:52:20.358328" (e61d­881e­1299­dd79­27c5<span style="font-weight:bold;color:red">8888888888</span>4ac755­686a­ce0a­9201­2c89­b5b6­f464­94c0).

Turn this on its head! Choose a phrase of importance, ask a question, in the form of a meaningful hexadecimal string, and find which emoji you can interpolate into the phrase to unlock the hexadecimal string in the fingerprint, and declare the choice of emoji significant to the question you have asked.

## Dactyloglyphomancy in action

First, we choose an [Oblique Strategy](https://en.wikipedia.org/wiki/Oblique_Strategies).

```
Bridges:
 -build
 -burn
```

Then, we ask a question.

> What will be relevant for 2020, and 2021?

So we will search for a hash that matches `2020` and `2021`.

Then we run several parallel threads in Rust to discover the hash ed7f­23f8­436d­f<span style="font-weight:bold"><span style="color: red">20</span><span style="color:purple">20</span><span style="color:blue">21</span></span>e­1fce­3d2f­4262­7d5a­7f1a­01a2­3557­c8c0­5ff6­d106­3e16, which corresponds to

```
Bridges:
 -build 💕
 -burn 📱
```

Thus, the theme for 2020 and 2021 is build bridges of 💕, and burn bridges with one's 📱. Fair enough.

Next, we choose another Oblique Strategy, for areas of inquiry.

```
Consult other sources: promising, unpromising
```

Then, we ask for near-term suggestions: search for `202106`.

With our resulting hash e684­19dd­6ba7­e410­a9c2­1509­b652­2f74­7b<span style="font-weight:bold;color:red">202106</span>b41a­ce99­623a­800d­9c87­a5fa we find

```
Consult other sources: 🔭 promising, 🦖 unpromising
```

advising astronomy/astrology and ornithology/palaeontology.

Perhaps we require more timeless advice about defense against harmful desires. We can interpolate into Jenny Holzer's famous

```
💆 PROTECT 🌄 ME FROM WHAT I 🏍 WANT 🧞
```

and perceive massages and mountain sunrises as a guard against motorcycles and bottled spirits, in an amulet that is legendary (2b40­eb46­e603­c680­4948­5e8a­3df<span style="font-weight:bold;color:red">88888888</span>6­2eeb­fab5­6ea0­0553­305f­506e­c819).

We can use older poetry as well. Sappho's "Some men say an army on horseback" is beautiful, and Anne Carson's translation begins:

> Some men say an army of horse and some men say an army on foot
>
> and some men say an army of ships is the most beautiful thing
>
> on the black earth. But I say it is
>
> what you love.

The original Greek for the last "it is what you love" is κῆν’ ὄττω τις ἔραται which we can interpolate into

```
κῆν’ ὄττω ⛺ τις 🌘 ἔραται 🌄
```

for a timely amulet celebrating camping and mountain sunrises and night skies (bed5­d962­d2d2­db72­c4ac­f467­996<span style="font-weight:bold;color:red">20210601</span>e582e­3bb6­5ff8­4698­d5e5­ee01­9915).

## DIY

Try out [https://github.com/lsb/dactyloglyphomancy](https://github.com/lsb/dactyloglyphomancy) yourself and divine new insights about your future!


