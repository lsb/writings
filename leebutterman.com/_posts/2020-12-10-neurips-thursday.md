---
layout: post
date: 2020-12-10
title: 2020 NeurIPS Thursday
---

# Brief notes

* Indigenous in AI!
* Hand-transcription of Māori for automatic speech recognition: [Kōrero Māori](https://koreromaori.com/)
  * Caleb Moses: 316 hours of utterances collected in 10 days!
  * bootstrap a DeepSpeech model
  * instead of who _owns_ the data (like Western land ownership) who _safeguards_ the data (like [Māori frameworks like kaitiakitanga](https://en.wikipedia.org/wiki/Kaitiaki#Kaitiakitanga))
  * kaitiakitanga license: royalties go back to the data's communities
    * this is much more work that just writing little Datasheets for Datasets
    * data sovereignty: open source only works among equals, versus getting your data strip-mined out of your community
    * language is inextricable from culture: it doesn't belong to one person
      * but if there are few enough people in the group, they may choose to dump their data into the public domain, due to so few options
    * each indigenous group has their own standards of engagement
* Making kin with the machines: [Indigenous protocol](https://www.indigenous-ai.net/position-paper/)
  * note therein the story Gwiizens, The Old Lady, and The Octopus Bag Device
    * "be kind to us, great mystery"
    * technology as prosthetic, as rare, as mediated by people with seemingly bad intentions, as fickle, as arising from surprising sources, as object of beauty at the end of a long task, as tool of salvation, as of undisclosed results

* Causal learning can help extricate you from Simpson's Paradox
  * domain knowledge helps you avoid understand what is and isn't a confounding variable
    * "causal" language models ... aren't

* Neural architectures inspired by neuroscience, for AGI
  * Perceptron &c explicitly modeled on biology
  * instead of idolizing our planes versus birds, look at our cars versus goats: cars are missing fundamentals of quad-ped locomotion
  * two large challenges: interact with the world (old brain), plan / reason / use language (🙋, 🐭, 🐦, 🐙)
    * Hans Moravec: reasoning is the thinnest veneer of human thought, and we have a billion years of experience in perceptual and motor control
  * AI relies on learning, but animals rely on innate structure, from a genome, via genetic bottleneck
  * horses can stand at birth, spiders can hunt and spin webs at birth, birds have species-specific nests, beavers want to build dams _without parental guidance_ (even indoors 😵)
  * deer mouse, raised by field mouse, builds a deer mouse burrow, not a field mouse burrow, and vice versa!
  * if you know English, and can model English, memorizing three English words is nbd; versus memorizing some Linear A
    * rats have a spatial modeling center in their brains to learn spatial maps with
    * humans have a Fusiform Face Area to learn faces with
    * humans have stereotyped language areas (koko the chimp learned 1000 signs but without syntax)
  * innate behavioral differences between us and chimps are our genome, our wiring diagram
    * we understand the parts of neurons, though, but not how to assemble them
  * GPT-3 has >100B parameters
    * C elegans has 302 neurons and 7K synapses, for 200MBit genome
    * Human brain has 100B neurons, 100T synapses, for 1 GBit genome
  * Genomic bottleneck: Loss(Genome) = InitialPerformance(Genome After Development) + λ Entropy(Genome)
    * you can compress an MNIST network 1000x and still get good performance (distillation?)
  * Learning is not necessarily the key to our success: humans almost died out 70kya!
  * Cultural transmission breaks the cultural bottleneck: oral transmission, and especially written communication, allows passing on huge amounts of knowledge from generation to generation
  * cf Weight-Agnostic Neural Networks
