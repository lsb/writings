---
layout: post
date: 2021-02-01
title: Store your epoch times as 64-bit floats
---

## Get quarter-microsecond granularity _right now!_

UNIX, [since the 1970s](https://github.com/dspinellis/unix-v4man/blob/master/man2/stime.2#L18), has had an internal notion of time
that is the [number of seconds after 1 Jan 1970 UTC](https://man7.org/linux/man-pages/man2/time.2.html).

This is often expressed as an integer, a signed integer. Many other APIs exist that specify fractional time, also as integers:
[clock_getres expresses seconds and nanoseconds as 32-bit integers](https://man7.org/linux/man-pages/man2/clock_gettime.2.html),
[Java expresses time in milliseconds as a 64-bit integer](https://docs.oracle.com/javase/7/docs/api/java/lang/System.html#currentTimeMillis()),
and [a Date in JavaScript internally keeps track of milliseconds since 1970](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date),
[PHP returns time in microseconds](https://www.php.net/manual/en/function.microtime.php). Ruby keeps [Time as nanoseconds and uses arbitrary-precision integers](https://ruby-doc.org/core-2.6.3/Time.html).

Instead of inventing a complex data structure yourself, use one implemented in hardware: the 64-bit float!

The [float64 format](https://en.wikipedia.org/wiki/Double-precision_floating-point_format)
has a sign bit, 11 exponent bits (representing exponents from ≈-1000 to ≈1000), and 52 explicit mantissa bits (representing a mantissa with precision of ≈ a quintillionth), as visualized by User:Codekaizen:

![a sign bit, 11 exponent bits, and 52 explicit mantissa bits](data:image/svg+xml,%3C%3Fxml version='1.0' encoding='UTF-8' standalone='no'%3F%3E%3Csvg xmlns='http://www.w3.org/2000/svg' width='618' height='125' version='1.0'%3E%3Cdefs /%3E%3Cg %3E%3Crect style='fill:%23dff;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='22' y='54' /%3E%3Crect style='fill:%23afb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='31' y='54' /%3E%3Crect style='fill:%23afb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='40' y='54' /%3E%3Crect style='fill:%23afb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='49' y='54' /%3E%3Crect style='fill:%23afb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='58' y='54' /%3E%3Crect style='fill:%23afb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='67' y='54' /%3E%3Crect style='fill:%23afb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='76' y='54' /%3E%3Crect style='fill:%23afb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='85' y='54' /%3E%3Crect style='fill:%23afb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='94' y='54' /%3E%3Crect style='fill:%23afb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='103' y='54' /%3E%3Crect style='fill:%23afb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='112' y='54' /%3E%3Crect style='fill:%23afb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='121' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1;font-size:14' width='9' height='28' x='130' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='139' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='148' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='157' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='166' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='175' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='184' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='193' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='202' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='211' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='220' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='229' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='238' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='247' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='256' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='265' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='274' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='283' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='292' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='301' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='310' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='319' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='328' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='337' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='346' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='355' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='364' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='373' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='382' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='391' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='400' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='409' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='418' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='427' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='436' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='445' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='454' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='463' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='472' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='481' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='490' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='499' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='508' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='517' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='526' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='535' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='544' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='553' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='562' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='571' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='580' y='54' /%3E%3Crect style='fill:%23fbb;fill-opacity:1;stroke:%23000;stroke-linejoin:bevel;stroke-opacity:1' width='9' height='28' x='589' y='54' /%3E%3Cpath style='fill:none;fill-rule:evenodd;stroke:%23000;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1' d='M 26.5,41.486325 L 26.5,51.513676' /%3E%3Cpath style='fill:none;fill-rule:evenodd;stroke:%23000;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1' d='M 31.045521,41.486325 L 31.045521,51.513676' /%3E%3Cpath style='fill:none;fill-rule:evenodd;stroke:%23000;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1' d='M 129.37216,41.486325 L 129.37216,51.513676' /%3E%3Cpath style='fill:none;fill-rule:evenodd;stroke:%23000;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1' d='M 30.871268,41.5 L 129.9465,41.5' /%3E%3Cpath style='fill:none;fill-rule:evenodd;stroke:%23000;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1' d='M 131.42323,41.486325 L 131.42323,51.513676' /%3E%3Cpath style='fill:none;fill-rule:evenodd;stroke:%23000;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1' d='M 131,41.5 L 597.55635,41.5' /%3E%3Cpath style='fill:none;fill-rule:evenodd;stroke:%23000;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1' d='M 597.46672,41.486325 L 597.46672,51.513676' /%3E%3Ctext xml:space='preserve' style='font-size:12px;fill:%23000;fill-opacity:1;stroke:none;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;font-family:Calibri' x='51.380074' y='16.812664' %3E%3Ctspan x='51.380074' y='16.812664' style='font-size:14px;font-family:sans'%3Eexponent%3C/tspan%3E%3C/text%3E%3Ctext xml:space='preserve' style='font-size:12px;fill:%23000;fill-opacity:1;stroke:none;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;font-family:Calibri' x='58.438179' y='34.155521' %3E%3Ctspan x='58.438179' y='34.155521' style='font-size:14px;font-family:sans'%3E(11 bit)%3C/tspan%3E%3C/text%3E%3Ctext xml:space='preserve' style='font-size:12px;fill:%23000;fill-opacity:1;stroke:none;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;font-family:sans' x='13.918457' y='34.843887' %3E%3Ctspan x='13.918457' y='34.843887' style='font-size:14px'%3Esign%3C/tspan%3E%3C/text%3E%3Ctext xml:space='preserve' style='font-size:14px;fill:%23000;fill-opacity:1;stroke:none;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;font-family:sans' x='341.72983' y='15.752003' %3E%3Ctspan x='341.72983' y='15.752003'%3Efraction%3C/tspan%3E%3C/text%3E%3Ctext xml:space='preserve' style='font-size:14px;fill:%23000;fill-opacity:1;stroke:none;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;font-family:sans' x='342.30746' y='33.429672' %3E%3Ctspan x='342.30746' y='33.429672'%3E(52 bit)%3C/tspan%3E%3C/text%3E%3Cpath style='fill:%23000;fill-opacity:0.25;stroke:%23000;stroke-width:1;stroke-linejoin:bevel;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1' d='M 31.819805 91.589203 A 3.7123106 3.7123106 0 1 1 24.395184,91.589203 A 3.7123106 3.7123106 0 1 1 31.819805 91.589203 z' transform='translate(-1.6074944,-0.8015134)' /%3E%3Ctext xml:space='preserve' style='font-size:14px;fill:%23000;fill-opacity:1;stroke:none;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;font-family:sans' x='18.765137' y='110.82227' %3E%3Ctspan x='18.765137' y='110.82227'%3E63%3C/tspan%3E%3C/text%3E%3Ctext xml:space='preserve' style='font-size:14px;fill:%23000;fill-opacity:1;stroke:none;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;font-family:sans' x='117.78906' y='110.8291' %3E%3Ctspan x='117.78906' y='110.8291'%3E52%3C/tspan%3E%3C/text%3E%3Cpath style='fill:%23000;fill-opacity:0.25;stroke:%23000;stroke-width:1;stroke-linejoin:bevel;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1' d='M 31.819805 91.589203 A 3.7123106 3.7123106 0 1 1 24.395184,91.589203 A 3.7123106 3.7123106 0 1 1 31.819805 91.589203 z' transform='translate(97.392506,-0.8015134)' /%3E%3Cpath style='fill:%23000;fill-opacity:0.25;stroke:%23000;stroke-width:1;stroke-linejoin:bevel;stroke-miterlimit:4;stroke-dasharray:none;stroke-opacity:1' d='M 31.819805 91.589203 A 3.7123106 3.7123106 0 1 1 24.395184,91.589203 A 3.7123106 3.7123106 0 1 1 31.819805 91.589203 z' transform='translate(565.39251,-0.8015134)' /%3E%3Ctext xml:space='preserve' style='font-size:14px;fill:%23000;fill-opacity:1;stroke:none;stroke-width:1;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;font-family:sans' x='589.65137' y='110.50431' %3E%3Ctspan x='589.65137' y='110.50431'%3E0%3C/tspan%3E%3C/text%3E%3C/g%3E%3C/svg%3E)

such that 1620620620 (in May 2021) is represented as 0b<span style="color:darkcyan">0</span><span style="color:lime">10000011101</span><span style="color:red">1000001001100010110101010011000000000000000000000000</span>,
or 0x41D8262D53000000.

The next largest floating point number is 0x41D8262D53000001, or 1620620620 + 2⁻²². This is a granularity of a quarter of a microsecond.
Instead of many different APIs to try to represent fractional time, keep time as a float64, to adequately represent time with granularity of well under a microsecond for the next several decades,
and only compute on this representation of epoch time.

## Y2038 non-problem

Part of the problem of storing time as a 32-bit signed integer number of seconds after 1 Jan 1970: we have no more integers after 19 Jan 2038 that fit in 32 bits!

Signed integers roll over and turn negative when they overflow, at their current precision. Floats get half as precise when they overflow their current precision.

In 2038, float64s that represent time will degrade to a granularity of half a microsecond.

On 7 February 2106, when seconds after 1970 will exceed 2³², the floating point representation will have the precision of one microsecond, and maintain exactly the same bit structure.

At the extinction of the dinosaurs, 65 million years ago, when the epoch time was negative 2 quadrillion (-2051244000000000 for 65Mya), the precision is a quarter of a second.

## Why am I not using float64 time already???

Even through the 90s, long after many system calls became formalized, floating point math was much more expensive than integer math.
Also, while some of the earliest computers had floating-point support (C has a float and a double, because it initially ran on a computer that did!),
there was no standard for what you could expect from a "float" or a "double": K&R C [explicitly warns you that a "double" could be 72 bits](https://archive.org/details/TheCProgrammingLanguageFirstEdition/page/n41/mode/2up),
and only in 1984 was there a floating point standard that people could ask for by name (IEEE-754), at which point many system APIs had settled.

## Computing with float64 time

Floating point, especially when you least expect it, can be surprising: 0.1 (as expressed in the base 2 of a float64) + 0.2 (as expressed in the base 2 of a float64) generally equals [0.30000000000000004](https://0.30000000000000004.com/)
(both 0.1 and 0.2, in float64 representations, are almost 2⁻⁵⁷ greater than their exact base 10 representations).

For this reason, financial computations in floating point are strongly discouraged.

Time is not money!

Whereas money can be contractually expressed as hundredths or millionths of a base currency ($, €, et cetera), time is not exact! 
[Facebook increased the accuracy of their computers' time from milliseconds to within hundreds of microseconds and it was a big deal](https://engineering.fb.com/2020/03/18/production-engineering/ntp-service/).

Whereas you can reasonably divide a financial sum 3 ways, and you want to ensure that the parts sum to the whole,
you will generally not be multiplying the time after 1970 by a number and making sense out of it, because 1970 is just an arbitrary zero-point.

Generally, to compute durations, you will be performing arithmetic on times. On computers that can adjust the system clock multiple microseconds at a time, sub-microsecond precision is entirely sufficient.

Furthermore, float64s are entirely adequate for storing both the number of seconds after 1970, and also the number of seconds of a particular duration, and when these numbers are smaller, the granularity increases:
the granularity at a billion is a billionth of the granularity at one, so continuing to compute in float64 is a great idea, no type conversions required.

## Case study: 128-bit UUIDs

Time stored as a float64 makes a lot of sense, especially when used in a fixed-length id!

### Simple: float64+random64

Let us say that you want (probably) unique ids, which you can sort lexicographically (run through `sort`) and get a rough ordering in time.

The big-endian representation of float64 supports this sort order: recall that 1620620620 (May 2021) in a float64 is 0x41D8262D53000000, and 0x41D8262D53000001 is 1620620620 + 2⁻²².
All positive numbers sort in ascending order, as do all negative numbers.

When time is accurate to hundreds of microseconds, time storage at sub-microsecond precision is entirely adequate.

If you use all 128 bits of the UUID, disregarding [UUID's backwards compatibility built in for 1980s computers](https://en.wikipedia.org/wiki/Universally_unique_identifier#Variants),
you have 4M different float64s per second, and you have 64 full bits of randomness.

Based on the math powering the [Birthday Problem](https://en.wikipedia.org/wiki/Birthday_problem#Probability_table),
for a 50% chance that two 64-bit random strings are equal, you would need roughly 5 billion 64-bit random strings, every quarter of a microsecond.

If you are okay with a quarter of a percent chance of any of these float64+random64 UUIDs colliding in twenty years, then the probability of collision per timeslice needs to be one in a quintillion, 10⁻¹⁸:
(1-10⁻¹⁸)^(4000000 * 86400 * 365 * 20) ≈ 99.75% , which is to say, the odds of _not_ colliding per timeslice, 1-10⁻¹⁸, multiplied together for the timeslices in a second for the seconds in a day for the days in a year for twenty years.

If you are making 6 of these UUIDs every quarter-microsecond, the space to store _only the ids_ is 16 bytes/id * 6 ids/tick * 4M ticks/s * 86400 s/day * 30 day/month ≈ one&nbsp;petabyte&nbsp;per&nbsp;month, _only_ for UUIDs.

If these UUIDs are connected to event data, and your event data is at least 10x the size of the id of the event, that is over 2PB/week.

Most use cases do not have 2PB/week of new data! Using this float64+random64 scheme is entirely enough to identify most types of events as they happen, with a very low chance of collision.

### Fancier: float56 + random72

The float64 corresponding to the current epoch time will have its highest-order byte equal to 0x41, from 2 Jan 1970 until 16 Mar 2242. If we only store the lower 56 bits, we can have 8 more bits of randomness per timeslice.

The number of random72s that we can make every quarter-microsecond tick to retain the odds of collision at 10⁻¹⁸ is 97: √(2 × 2⁷² × -ln(1-10⁻¹⁸)) ≈ 97.

This is sixteen times as many as the float64random64, so, this corresponds to at least 30PB/week of event data. This is over an exabyte a year, [well over $20M in storage costs alone](https://aws.amazon.com/s3/pricing/).

## Bonus: visualization strategies!

Kudos to [Evan Wallace's Float Toy](https://evanw.github.io/float-toy/) for visualizations of the binary float16/float32/float64 formats!
Kudos to [Bartek Szopka's ieee-754-visualization](https://github.com/bartaz/ieee754-visualization) for a slightly more math-oriented approach!

## Store your epoch times as 64-bit floats

Computing with a float64 is cheap, you get sub-microsecond precision nowadays, you don't need to pre-coordinate about milliseconds versus microseconds versus (sencond,nanosecond) pairs et cetera et cetera, as long as you're not counting individual nanoseconds you should be great.

Also obviously store your human times as ISO 8601 strings (among many other reasons: the list of time zones is unbounded).