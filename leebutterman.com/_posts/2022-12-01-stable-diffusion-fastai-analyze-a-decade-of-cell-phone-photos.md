---
layout: post
date: 2022-12-01
title: Efficiently analyzing 25k cell phone photos in an afternoon, with FastAI and Stable Diffusion
---

I have over a decade of unorganized cell phone photos, and I want to find pictures to print out and put on my walls.

I want to analyze this locally. I do not want workers on MTurk going through my photos.

This project relies on three ideas:

1. FastAI as a reasonable AutoML for image classification
2. Synthetic image data as a reasonable training data set
3. Notebooks as a UI to (write code to) enter data labels

Fundamentally, this was an optimization problem, reducing the waste (of printing pictures not going up on the wall) and reducing the time (of sifting through pictures, pre- and post-print), so using ML heuristics is a great fit.

# FastAI as a reasonable AutoML for image classification

## FastAI is a mature toolkit for making image models

with the image data loaders and the batches and the learning rate finder and the easy usage of torch vision models and everything

Also this is only two classes lol

## Models only exist to decrease human time generating labels

resnet50? efficientnet-b0? who cares

this is happening human-in-the-loop (maybe go for a walk in between labelling sessions?)

## (third point?)

# Synthetic image data as a reasonable training data set

## The classification problem is relatively easy

The classification problem is basically trying to find pictures that have people in them

Finding people in pictures is solvable lots of ways

I can easily describe the pictures I take ("picture of two friends on a mountain", "hummingbird on a mountain"), generate a seed training data set, and classify enough to get started with a few-year-old vision model

No need to complicate with bounding-box object detection, versus a binary image classification

## Stable Diffusion pops out adequate quality images quickly

image classification models are fine on noisy data so if your faces are busted then nbd

# Notebooks as a UI to (write code to) enter data labels

## input() and display() and clear_output() and a for loop isn't the worst idea

requires the enter key between inputs :( but meh

focus generally stays correctly on the text area

sometimes it doesn't and then you're at the mercy of whatever hotkeys you're mistyping

x to cut a cell, combined with some cells taking user inputs, == :(

## the UI can be under a few dozen lines

so you don't need to expose any knobs in an Elegant UI when you can change constants in the notebook directly

## separate low-entropy and high-entropy work

two forms of manual labels: is this image the sort of image I want, and then, is this image an image I want

each has a different rhythm

is this image the sort of image I want == analyze the images whose desirability is closest to 0.5

is this image an image I want == analyze the images in descending desirability (often times I'll have 3-4x pictures of one scene, and this groups them all)

## put on some music with a strong beat and get to work

wasd + enter, for each image

less penderecki or debussy, more drum machine. Think 4 on the floor.

kraftwerk has some solid bass lines https://www.youtube.com/watch?v=sFpp952JY-k , earth wind and fire https://www.youtube.com/watch?v=oztLjRFbCgc , even doomerwave https://www.youtube.com/watch?v=g5mAhjDlCJc

# Printed results were great :)




1. Hypothecate several types of desirable and undesirable pictures, as prompts for (e.g.) stable diffusion.
2. Train a cheap image classification model on this pile of stable diffusion pictures.
3. Thumbnail all your photos to classify (imagenet is 224x224, 512x512 is plenty, 300x300 is probably fine).
4. Manually label the most ambiguous ~hundred~ thumbnails, save manual labels and retrain, repeat.
5. Go through most of the collection (p(good)>0.05) now in descending quality, large-scale lower-entropy operation.
6. Send the final pass to a printer :)
7. Write it up for your friends to read :)
 

1. Use Stable 


`find . -name '*.jpg' -print -exec mogrify -strip -resize '512x512' {} \;`
