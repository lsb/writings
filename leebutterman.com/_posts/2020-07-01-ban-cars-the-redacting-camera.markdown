---
layout: post
date: 2020-07-01
title: BAN CARS via image segmentation and augmented reality—fast.ai lesson 3
---

## BAN CARS

![walking along a street seeing a 15fps straight webcam view and a 5fps augmented reality view that has grey checked patterns over where most of the cars are](/assets/resnet18-bancars-primesmokedmeats.gif)

[Try it yourself!](https://leebutterman.com/redacting-camera)

There's options to ban cars, to blot out trees and the sky, to redact people, or any other combination of the several dozen Camvid categories.

## Project

The fast.ai lesson discusses image segmentation, and the Camvid dataset. There are stories of amateur photographers causing more trouble than they intend by [allowing FBI to trace people in the streets demonstrating](https://www.theverge.com/2020/6/18/21295301/philadelphia-protester-arson-identified-social-media-etsy-instagram-linkedin) [these days](https://en.wikipedia.org/wiki/George_Floyd_protests). Perhaps a camera that redacts parts of a scene would be useful!

The scenario on the street is hostile: [a protester faces life in prison for purchasing red paint that splashed on a DA's office](https://www.thedailybeast.com/utah-woman-madalena-mcneil-faces-life-in-prison-after-allegedly-buying-red-protest-paint) during a protest of that DA justifying officers shooting a man 34 times. Going up against the power of a nation-state is no joke, so, use this for artistic inspiration and ideation only.

### Results

#### Baseline

The UI allows a user to select any different combination of categories to redact, with three helpful presets: no people, no sky/trees, and no cars. The model I made is much more accurate for the sky and the trees and the cars in my neighborhood, compared to recognizing me as a pedestrian (self-driving cars are currently working out many details on this). Using a fast Resnet18 u-net learner on a GPU in a home server deployment:

![in a parking lot toggling a dropdown between no sky and ban cars and no people, with a 15 fps raw webcam view and a 5 fps view redacted to grey checkerboard, with varying degrees of correctness for the redaction](/assets/resnet18-skycarppl-595_3rd.gif)

#### Variation 1: more accurate

Replacing the Resnet18 model with a larger Resnet50 model is more accurate, jumps response time from ~200ms to ~1s (the prediction itself jumps from ~30ms to ~200ms), and more crisply detects the pedestrian as a pedestrian:

![the same image as above, but more aligned with contemporary ideas about pedestrians and sky and trees and cars](/assets/resnet50-skycarppl-595_3rd.gif)

#### Variation 2: non-local deployment

Note the low latency and low variance, above, compared to running that first Resnet18 u-net model on Render:

![the same image as previously, just ranging from 0.1 fps to 0.5 fps](/assets/resnet18-skycarppl-595_3rd-cpu_on_render.gif)

Perhaps Lambda or Render will offer the option to use a GPU in the near future.

#### Variation 3: birds

Some geese in my neighborhood were walking on foot, but the image model did not perceive them to be pedestrians or other moving entities but instead perceived them as trees and "miscellaneous vegetation":

![geese are not redacted as othermoving or pedestrian but do get redacted with the trees and vegetationmisc](/assets/resnet18-geese_are_plants-4up.gif)

This is a cute anomaly if you are [inordinately interested in avian taxonomies](https://www.youtube.com/watch?v=eIl1VuGTk3g), this is distressing if you are using this app for your ornithophobia, this is potentially lethal for birds if a self-driving cars thinks that neighboring animals with shorter flight distances are "miscellaneous vegetation".

### Sources

The model comes from a mostly-unchanged notebook run. The [backend](https://github.com/lsb/redacting-camera) is very close to the fastapi backend from Art/Text/Plant, from last time, but crucially we are taking a JPG in from the camera and returning a PNG transparent for any pixels detected in up to a few dozen categories. The [frontend](https://github.com/lsb/fastai-coursework/tree/master/course-v3/lesson3/redacting-camera) is very close to the React webcam frontend from last time, but this time we have a few dozen check boxes for categories to toggle, and are displaying the redacted image.

## Notes on the lessons

* The network seems to be fast enough to do device webcam round-tripping to a server! Off-the-shelf Pillow seems to be able to handle 5-10 fps when ingesting smaller images. It's valuable to focus on where code runs but local-first software is just [part](https://kevinlynagh.com/newsletter/2020_08_extreme_outcomes/) of a strategy
  * Render is very convenient, though my local laptop has much much lower mean+variance
    * we will see below in animated gifs!
* bespoke AI modeler (make yourself some facial recognition 😬 but for your 36 cousins)
  * seems very constrained in domain and distribution, so many this is less like a [Project Ploughshare](https://en.wikipedia.org/wiki/Project_Plowshare) use of [Facial-Recognition-as-Plutonium](https://static1.squarespace.com/static/59a34512c534a5fe6721d2b1/t/5cb0bf02eef1a16e422015f8/1555087116086/Facial+Recognition+is+Plutonium+-+Stark.pdf)
  * maybe a ResnetToy would be useful, à la ShaderToy?
* the React webcam augmented-reality app was much more transformative than I was expecting
  * especially when I redeployed it on my laptop and got over 10fps
* seems valuable to dig deeper into the data block api / data bunch, especially for patterns for data normalization / facilitating ETL

* notebook as documentation is _so inspiring_ seeing code + interactive runtime/debugger

* progress of fast.ai is pretty remarkable
  * as a team: fbeta 0.934, with resnet magic, for "months"
  * as a library: fbeta 0.932, with defaults, for a few minutes on a large gpu
  * on my small noisy box, using resnet152: fbeta (jackpot!) 
  * on my small noisy box, using mobilenet v2: fbeta 0.928 (double jackpot!)

* sometimes finding a learning rate or spot-checking a data bunch seems to cause my GPU to OOM, and I do not love this, but I do not love this to such an extent to dig into it

* an image model that works offline that you could take with you into the forest would be pretty cool
  * but you might not want only a resnet telling you to eat a random mushroom or not, your false negatives are much less harmful than your false positives

