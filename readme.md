Totes Random
=============
<a href='http://www.recurse.com' title='Made with love at the Recurse Center'><img src='https://cloud.githubusercontent.com/assets/2883345/11325206/336ea5f4-9150-11e5-9e90-d86ad31993d8.png' height='20px'/></a>

A 1000% secure random number generator using Twitter as a source of entropy.


Introduction
------------

It has long been standard practice to seed random number generators using meaningless noise from the environment, and in this work we continue that tradition. Aimed squarely at the subset of developers who do not have access to measurements of the universal background radiation or radioactive decay, we provide an easy to use API that gets its randomness from a source of chaos that's accessible to all.

How It Works
------------
To start with, to ensure statistical validity, we search the Twitter streaming API for only the most statistically valid terms:

> "random", "chance", "dice", "gaussian", "cauchy", "exponential", "gamma", "chi-squared", "wishart", "correlation", "implies", "causality", "stochastic", "bayes", "baes", "laplace", "unlikely", "million to one", "lottery", "las vegas", "roulette", "distribution", "monte carlo", "monty python", "MCMC", "astrology", "accidental", "heart of gold", "spork", "penguin of doom"

We then extract the first 9 of these tweets (a random number we determined by rolling a d20) and hash them. This hash is then passed though the Mersenne Twister before being used to seed Haskell's own random number generator, all to ensure that triple thick cryptographical goodness.


How To Use It
-------------
Visit http://www.totes-random.website/ in order to get a random number between 0 and 1, and also to see the tweets it came from. If you want to use the number in an application then http://www.totes-random.website/float will give you the number as plain text with no tweet, and http://www.totes-random.website/bits will give you exactly 140 random bits. To see an example application that uses our API, or to understand why we chose 140 as the number of bits to return, see [totes-random-bot](https://github.com/JKiely/Totes-Random-Bot).
