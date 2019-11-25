---
layout: post
title: "Queer Representation in StyleGAN"
date: 2019-10-01
---

> 1. The face model from StyleGAN produces photo-realistic output
> 1. It takes longer and is less accurate on faces with big expressions / big makeup
> 1. You can make some cool face mashups with those faces though

## StyleGAN

StyleGAN is a new and exciting project! StyleGAN is a Generative Adversarial Network for generating images, and one domain it has been used on is generating [headshot portraits](https://thispersondoesnotexist.com). It manages to infer and separate large-scale features (background, camera position, facial angle) as distinct from fine-grained features (shape of eyes, ears, jewelry), and it can produce realistic output. The creators demonstrate its efficacy on images ranging from faces to cars to bedrooms to cats, and [describe the architecture of StyleGAN in detail](https://stylegan.xyz/paper).

The authors generously distribute a pre-trained model on a pre-selected dataset of high quality faces from Flickr (FFHQ), 70k images at 1024² resolution. Here are 3x5 faces made by blending coarse features from 3 faces with fine features from 5 faces:

![3x5 faces from blending coarse features and fine features](/assets/stylegan-teaser.jpg)

The authors acknowledge the bias of such a dataset (people who have their faces on Flickr, in commercially-reusable licenses, are not a random sample of the population, for example), while showing a range of faces in that dataset:

![seven faces from FFHQ](/assets/ffhq7.jpg)

StyleGAN represents images in its latent space as 18 levels of 512-dimensional (real-valued) features.

The idea is that these levels are separable, that the background and rough facial outlines are on separate levels from the low-level details, as in the 3x5 face blending, and that this latent space supports vector space arithmetic to interpolate and extrapolate between features.

This potential feature arithmetic encourages considering what the zero-face is, what is the face that the model considers default:

![average face of stylegan](/assets/stylegan-zero-face.jpg)

(This zero-vector face is what encoding starts from by default, as we shall see later.)

The face is not significantly butch or femme, it is not very pale or very dark, its out-of-focus background is a mottled grey, moderately illuminated, outdoorsy (maybe in an unspectacular thicket of trees?), its lighting is diffuse and ambient, its makeup is minimal (contrast to face 6 with the green paint and underlighting and dark background), its jewelry is minimal (one earring?), maybe somewhere between 20 and 50 years old, slightly smiling.

Note the general style, here as in the 3x5 above: background at ∞, tight close focus on the face, minimal decoration, no extra limbs (like hands/arms).

The [StyleGAN encoder](https://github.com/Puzer/stylegan-encoder) is an effort to tranform arbitrary faces into the latent StyleGAN featurespace, with an optional face detection + alignment preprocessor. The face input image is modeled in a pre-trained VGG16 feature space, and gradient descent optimizes the StyleGAN generator output in that same feature space to match it.

## An Overview of Queer Faces in StyleGAN

### Adversarial Poinsettia Fascinator

Queer culture, from the gritty and less-commercial world of [Paris is Burning](https://en.wikipedia.org/wiki/Paris_Is_Burning_(film)), to the highly commercial [Ru Paul's Drag Race](https://en.wikipedia.org/wiki/RuPaul%27s_Drag_Race), includes people of many sizes and many levels of adornment. Take, for example, Dina Martina:

![Dina Martina, with adversarial gift bows and an adversarial poinsettia fascinator](/assets/dina-martina-adversarial-gift-bows-adversarial-poinsettia-fascinator.jpg){:height="50%" width="50%"}

[Dina Martina](https://dinamartina.com/), with her adversarial gift bows and her adversarial poinsettia fascinator, has created a [publicity photograph](https://dinamartina.com/wp-content/uploads/2012/11/14.jpg) that does not by default register as having a face.

Note, for instance, the asymmetric lipstick, the underexposed hair above the forehead that becomes indistinguishable, the overexposure of the décolletage. Note the cheap gift bows associated with industrial holiday cheer, the tinsel around the head matching the dress, the _horror vacui_ composition of the photo, a depth of field that does not deemphasize the background and does not draw attention to the face. High production values, complete Dina Martina aesthetic, passionate, and joyful, exactly what one would hope for from camp.

StyleGAN Encoder's [frontal face detector](http://dlib.net/imaging.html#get_frontal_face_detector) did not recognize this as a human face!

The face detection has worked well on many other faces, however, such as Ezra Miller's look from the Met Gala 2019:

![ezra miller with seven eyes](/assets/aligned-ezra-seven-eyes.jpg){:height="50%" width="50%"}

That is after alignment, centered on (some of) Ezra Miller's seven eyes facing the camera.

### Δloss / Δt ∝ conformity

Some queer folk are interested, and have been interested, in the amount to which their presentation conforms to social norms: some trying to conform more (as in potentially homophobic situations, for safety), some trying to conform less (as in explicitly gender bending, or as in the intentionally liminal art of drag).

The stochastic gradient descent, for a given learning rate schedule (and other hyperparameters), by which the StyleGAN Encoder models faces, gives an output of its loss function at each step, as it tries to combine features at different granularities to compose an input face. The ease of finding analogous features in the training data, represented as the rate of change in loss (as well as the optimal loss on a particular run), is proportional to the conformity of the input to the training data. The conventionality of a look, compared to the FFHQ dataset, is immediately discernable by how quickly the features converge to the target image.

As with many other aspects of AI, this is an amoral process, and is very much what one makes of it. This access, to a test of conformance to external sources of fashion and aesthetics, is empowering and constructive when self-initiated, and often oppressive and often destructive when applied to others who have not welcomed a public conversation of their appearance.

### Δloss / Δt ∝ $$$

And this ease of conformity has financial implications as well! The code to perform this gradient descent modeling runs on a computer that costs money. At a given amount of loss, it is fewer steps of gradient descent to model the zero-face than it is to model Ezra Miller's seven eyes, for example. For a given cost, it is far more accurate to model the zero-face than it is to model significantly expressive faces.

Regenerating FFHQ itself, from the numbers in the paper, sounds like it would cost thousands of dollars in 2019 AWS prices, and creating/curating/acquiring usage rights for a new FFHQ + Queer Faces dataset and modeling it could easily run into five figures.

Conformity is cheap.

## Modeling Queer Faces In StyleGAN

### Adjusting the default hyperparameters

Initial results with the default learning rate of 1 and the default number of iterations of 1k (taking a few minutes each) did not produce accurate or aesthetically pleasing results. These following results are based on encodings generated with 20k iterations (taking about an hour each per GPU). The ease of tuning the hyperparameters to find values that more accurately model the input implies that this might be a useful path for future work.

### Modeling the zero-face

One baseline test of encoder output is how the encoder encodes that zero-face, described above. Further, we can have two alternate representations that we can interpolate between: the encoder output, and 18x512 zeros.

When we interpolate between the faces of zeros, _0_, and the encoded aligned image from _0_, _0'_, and linearly extrapolate 4.5x in each direction, we get the following thousand frames, from 4.5x beyond _0'_ to 4.5x beyond _0_:

<video controls autoplay class="wrapper" style="padding:0;width:25%;height:25%"><source src="/assets/zero_to_zero.mp4"></video>

Potential problems with these encodings in the vector space include the asymmetry from one zero to another, the discontinuity at roughly 1.5x more _0_ than _0'_ (at roughly 0:28), the disquieting glitch face triptych at 0:22–0:27 (note the disembodied eye on the left changing its gaze from 30° above the camera to exactly at the camera[^cursedimages], which is definitely not terrifying at all).


[^cursedimages]: The gamut of the three-faced glitch images:<br>![cursèd image](/assets/z0600.jpg){:height="25%" width="25%"}![cursèd image](/assets/z0610.jpg){:height="25%" width="25%"}![cursèd image](/assets/z0620.jpg){:height="25%" width="25%"}<br>Definitely not terrifying at all.


But note how plausibly we can interpolate between _0'_ and _0_, between 0:18 and 0:22, even if the advanced arithmetic extrapolations in vector space yield cursèd images. The following results bear out this realistic interpolation, while yielding unpredictable ghastly results from extrapolation and advanced vector space processing.

### Some faces

The initial faces that compromise this analysis are not meant to be comprehensive, and this compilation is meant to serve as only a starting point. Pull requests are welcomed at [https://github.com/lsb/queer-faces](https://github.com/lsb/queer-faces) .

We have a few dozen faces modeled with stylegan, shown below. If we are properly modeling each image, and not overfitting, then when we interpolate between the end result and another face it should "make sense" as a morphing of the face. For each encoded image is a video of the final result quickly easing into the slow beginning of an exponentially-sped-up gradient descent from the zero face that modeling starts with.

<hr>

<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>aquaria-dragcon-la_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_aquaria-dragcon-la_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>asia-ohara-fish_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_asia-ohara-fish_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>bianca-del-rio_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_bianca-del-rio_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>bob_tdq1_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_bob_tdq1_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>bob_tdq2_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_bob_tdq2_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>bob_tdq3_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_bob_tdq3_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>bob_tdq4_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_bob_tdq4_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>brian-firkus1_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_brian-firkus1_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>brian-firkus2_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_brian-firkus2_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>brian-firkus3_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_brian-firkus3_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>caldwell-tidicue-bob-tdq_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_caldwell-tidicue-bob-tdq_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>caldwell-tidicue-bob-tdq_02</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_caldwell-tidicue-bob-tdq_02.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>caldwell-tidicue1_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_caldwell-tidicue1_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>caldwell-tidicue2_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_caldwell-tidicue2_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>david-bowie-closed_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_david-bowie-closed_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>david-bowie-open_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_david-bowie-open_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>dina-martina-lookup_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_dina-martina-lookup_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>eddie-izzard1_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_eddie-izzard1_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>eddie-izzard2_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_eddie-izzard2_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>eddie-izzard3_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_eddie-izzard3_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>eddie-izzard4_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_eddie-izzard4_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>eddie-izzard5_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_eddie-izzard5_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>eddie-izzard6_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_eddie-izzard6_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>eddie-izzard7_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_eddie-izzard7_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>harvey-milk-portrait_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_harvey-milk-portrait_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>kathy-kozachenko_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_kathy-kozachenko_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>kathy-kozachenko_02</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_kathy-kozachenko_02.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>laxmi-narayan-tripathi1_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_laxmi-narayan-tripathi1_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>laxmi-narayan-tripathi2_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_laxmi-narayan-tripathi2_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>lsb1_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_lsb1_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>lsb2_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_lsb2_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>lsb3_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_lsb3_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>lsb4_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_lsb4_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>lsb5_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_lsb5_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>marsha-p-johnson_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_marsha-p-johnson_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>porter_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_porter_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>roxane-gay-no-hands_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_roxane-gay-no-hands_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>roxane-gay_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_roxane-gay_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>rupaul_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_rupaul_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>rupaul_02</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_rupaul_02.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>sylvia-rivera_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_sylvia-rivera_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>trixie-mattel1_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_trixie-mattel1_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>trixie-mattel2_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_trixie-mattel-2_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>yvie-oddly_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_yvie-oddly_01.mp4'></video></div>
<div class='wrapper' style='padding:0;width:20%;display:inline-block'><div>zeros_01</div><video controls style='height:100%;width:100%'><source src='/assets/zero_to_zeros_01.mp4'></video></div>


### Encoding loss

This is one encoding run of all of the images in the dataset, for the aforementioned 20,000 iterations. Plotting a moving average of progress, compared to progress encoding the zero face:

![encoding losses for 20k iterations](/assets/stylegan-encoding-losses.png)

Note that this plot has a logarithmic x-axis, like time in the videos above, and also has a logarithmic y-axis, for the comparative loss.

Also note that leaving a few irregularities in the initial dataset reveals interesting results:

1. The `rupaul_02` and `kathy-kozachenko_02` images come from the face-extraction step registering background blurs as faces, and the blurs are the easiest of the "faces" to model, almost always much easier to model starting at the zero face than even the zero face itself.
1. The puce and fuchsia lines (#6 and 7) at the top are `lsb4` and `lsb5`. While the photo subject did not try to make these two photos inherently challenging to model (as was the intention with `lsb2` or `lsb3`), the two photos have large enough depth of field to include significant detail around the background building and around the rail crossing apparatus (especially with text signage).
1. The adorment around Billy Porter's Sun God proved challenging to model, as did Bob The Drag Queen's blue wig + large hoop earrings + snarl.
1. The interpolation from end to beginning can show the circuity of modeling challenging faces: note `bob_tdq2_01`, with the smoking watergun and the fuchsia paint dripping from the scalp, tweening to zero at the beginning, with a different visual than the gradient descent path. Note as well that the smoking water pistol morphs into the place of an earring.
1. Sometimes dramatic eyes look like they interpolate as paint on closed eyelids.
1. Hands on a face seem to morph to the background, and not to any humanoid body part, when interpolating from `roxane-gay_01` to the zero face.

### Advanced vector space manipulations

Note how smoothly the faces interpolate in the videos! Even Asia O'Hara's fish mask, interpolating through what looks like carnival makeup midway around the lower half of the face.

The StyleGAN encoder has three latent directions, labelled smile, age (more accurately labelled "youth", as interpolating in that direction makes a face look younger), and gender (more accurately labelled "butchness", as interpolating into that direction gives one (among many other attributes) shorter cropped hair).

But we can make our own more interesting directions!

For instance, drag queen makeup tutorials are big business! [^bi] Currently 3 million hits on Google, and the fifth for me is Business Insider!

[One drag queen](https://www.youtube.com/watch?v=nZTcKxCqgSU) [who has recorded](https://www.youtube.com/watch?v=yFi-rZ4WJdw) [numerous tutorials](https://www.youtube.com/watch?v=MzaEd7JtjO8) [documenting putting on](https://www.youtube.com/watch?v=4MXwE7HXGDU) [her iconic look](https://www.youtube.com/watch?v=KOhamgj62jQ) [is Trixie Mattel](https://www.youtube.com/watch?v=aik0vuQs9Qs).

Instead of following along in the 3-dimensional domain, I can follow along in the 9000-dimensional domain of StyleGAN, and get something looking like this, easing [^easing] into and out of the Trixie Mattel Experience:

[^easing]: Specifically, this easing is a sinusoid that has been smoothstepped.

![lsb5](/assets/lsb5_01.jpg){:height="20%" width="20%"} ± ⅔ ( ![trixie](/assets/trixie-mattel-2_01.jpg){:height="20%" width="20%"} - ![firkus](/assets/brian-firkus3_01.jpg){:height="20%" width="20%"} ) ≈ <video controls autoplay style="vertical-align:middle;padding:0;width:20%;height:20%"><source src="/assets/lsb5-plus-trixie-minus-brian.mp4"></video>

Similarly,

![lsb1](/assets/lsb1_01.jpg){:height="20%" width="20%"} ± ½ ( ![trixie](/assets/trixie-mattel-2_01.jpg){:height="20%" width="20%"} - ![firkus](/assets/brian-firkus3_01.jpg){:height="20%" width="20%"} ) ≈ <video controls autoplay style="vertical-align:middle;padding:0;width:20%;height:20%"><source src="/assets/lsb1-plus-trixie-minus-brian.mp4"></video>

<!-- 

and

![lsb1](/assets/lsb2_01.jpg){:height="20%" width="20%"} ± ¼ ( ![trixie](/assets/trixie-mattel-2_01.jpg){:height="20%" width="20%"} - ![firkus](/assets/brian-firkus3_01.jpg){:height="20%" width="20%"} ) ≈ <video controls autoplay style="vertical-align:middle;padding:0;width:20%;height:20%"><source src="/assets/lsb2-plus-trixie-minus-brian.mp4"></video>

-->

Unfortunately, the crisp lines and resplendent costume jewelry do not translate exactly, though the messy look does retain the tasteful palette, and subverting the spirit of Trixie makeup is a gateway to futuristic sci-fi chic, be it a silvery spotlight with chartreuse accents or C-3PO-zinc-knockoff robot fantasy<!-- or white feathered bleeding-from-the-eyebrows-and-ears mystique -->.

It is less intuitive to infer in the other direction, to be able to infer the source of a transformation such as

<video controls autoplay style="vertical-align:middle;padding:0;width:33%;height:33%"><source src="/assets/lsb5-plus-bob2-minus-caldwell1.mp4"></video>

after

watching

makeup

tutorials

of

a

[certain](https://www.youtube.com/watch?v=BXVhC4hVY8A)

drag

queen

and

then

review

some

of

the

aforementioned

looks

and

immediately

recognize

without

peeking

at

the

answer

given

below

that

this

is

the

combination

of

![lsb5](/assets/lsb5_01.jpg){:height="20%" width="20%"} ± ⅓ ( ![bob the drag queen with a smoking waterpistol](/assets/bob_tdq2_01.jpg){:height="20%" width="20%"} - ![caldwell tidicue](/assets/caldwell-tidicue-bob-tdq_01.jpg){:height="20%" width="20%"} )

It is possible to see the effects of, say, the fuchsia paint dripping from the scalp (skin vaguely redder/bluer in the positive direction, skin vaguely radioactive-green (opposite to purple on the color wheel) in the negative direction), but it falls far short of the _élégance_ of the smoking waterpistol, the eyes looking sharply to stage right, the dramatic nails.

Similarly, it is possible but challenging to see the effects of proceeding hairline and camera angle closer to the brow than the chin and highlighted cheekbones with

![lsb5](/assets/lsb5_01.jpg){:height="20%" width="20%"} ± ½ ( ![trixie](/assets/bob_tdq4_01.jpg){:height="20%" width="20%"} - ![caldwell tidicue](/assets/caldwell-tidicue-bob-tdq_01.jpg){:height="20%" width="20%"} ) ≈ <video controls autoplay style="vertical-align:middle;padding:0;width:20%;height:20%"><source src="/assets/lsb5-plus-bob4-minus-caldwell1.mp4"></video>

but, if there were any obvious analogue, turning into a mauve cousin of Van Gogh[^vangogh] would not be it.

Similarly, interpolating between two faces usually does not preserve some attributes: a circular bindi can become less-than-circular, straight eyeshadow lines can smear and blur, snarls can get less snarly, and hands in particular are not modeled realistically.

## Conclusions

Firstly, it's masterful to see how continuous the StyleGAN latent space is. In the fifty interpolations above, we can see how photorealistic the results have been at most steps of the interpolations, and how accurately it renders many types of decoration on faces. Interestingly, many of the encoded faces look more Impressionist painterly, and less photo realistic, and potentially on the other side of the uncanny valley.  Lack of realism when modeling facial adornment and gestures, compared with the realism of modeled noses and eyes, implies that there's more work to do to represent the full gamut of human faces.

Check out the code! Let me know what you think:

[https://github.com/lsb/stylegan-encoder](https://github.com/lsb/stylegan-encoder) .


[^vangogh]: ![van gogh, september 1889 self portrait](/assets/van-gogh-sept-1889-smol.jpg) kinda.

<hr>

[^bi]: Fifth result on the Google SERP: ![drag queen makeup tutorial serp](/assets/drag-queen-makeup-tutorials-business-insider.png)

