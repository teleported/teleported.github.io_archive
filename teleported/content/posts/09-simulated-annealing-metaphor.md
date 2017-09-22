+++
date        = "2017-05-24T00:27:27-04:00"
title       = "Simulated Annealing simply explained"
description = "Simulated Annealing Metaphor without technical terms"
tags        = ["intuitions", "ml", "ai", "simulated annealing"]
categories  = [ "artificial intelligence", "simulated annealing" ]
slug        = "simulated-annealing-metaphor"
featuredImage="/post_imgs/09-sa.gif"
+++

(_I had explained Simulated Annealing to someone on Udacity forum. Here was the conversation._)

`Can someone please explain simulated annealing to me with an example not using schedule(t) or Temperature? The video and book aren't too great at the explanation.`

![Simulated Annealing](/post_imgs/09-sa.gif)

_Image Source: Wikipedia_

Let me give it a shot.

If I have to explain it without using technical terms, I will describe it like this:

Imagine that you are a dot on a 2D graph of maximas and minimas (peaks and valleys). Your goal is to find the global maxima, and you have no idea where it is.

You can be made to move to any point on the graph from your current location. (Where all you can move to from your current location is given by the problem statement. For e.g. if we are to replace this graph with routes from the [TSP](https://en.wikipedia.org/wiki/Travelling_salesman_problem), you can move to only the neighburing cities from your current location and not to any random city.)

When you start, you are full of energy. You had a good night's sleep. You had exercised before accepting the challenge. You had good breakfast.

So when you start:

* If you are given a random point  to move to which is better (higher) than your current position, you will pick it (obviously)
* If you are given a random point which is not better, you will want to pick it more often initially, because if you don't take chances with lower positions (and if you opt only for better positions), you may get stuck at a local maxima. Also remember - this is the beginning and you are full of energy (high temperature), you can do some random (may seem to be unnecessary) jumping around with the hope that you will eventually get to the global peak.

With passage of time, you become tired (afterall you are only human):

* If you are given a random point which is better (higher) than your current position, you will pick it (obviously)
* If you are given a random point which is not better, you will want to pick it less often gradually - because with time, it is expected that you converge on the probable peaks. And since you are tired (low energy or temperature), you will want to take less chance with suboptimal positions (remember, the only reason we were doing this was to come out of local maximas if any, and in the initial phase, we would have come out with high probability)

Now, when we implement Simulated Annealing in software:

* We convert (passage of) time to (passage of - hot to cold) temperature using the schedule() method. The design of it is very important.
* We then model our energy as an exponential function of (-ve)Error and Temperature. It decreases over time. So that, initially it will be greater than any randomly generated number (between 0 an 1) most of the time (i.e. with high probablity). And with passage of time, it will be less than. That's the simulation.

`I believe the concept is to chose a random neighbor, if it is better take it immediately. If it is not better, take it based on a probability.`

Correct. I will add that if (neighbour is) not better, the probability of picking that neighbour over current location, decreases over time. So that gradually you settle down for only those neighbours which are guaranteed to be better.

`So if you imagine a 45 degree slope from 1-10. 1,2,3,4,5,6,7,8,9,10. If you start on 5 then randomly chose 7, take it immediately, is this correct?`

Yes. Infact you will take it if it's better even if it comes later.


`If you start on 5 then randomly chose 3 you would calculate the odds of taking it which is (5-2)/5 or 60%, is this correct?`

Not, really. You will randomly generate a number between 0 and 1. If it is less than the exponential-function-based-on-temperature-and-error (exponential function won), you pick it. Else not.

`Is the step count (the size of the jump for the random neighbor) random?`

Well, Yes and No. Which means, you need to know where all you can go from a given position, and then you randomly choose one of them.

`I am not clear on how the probability is calculated. Are you saying you keep a counter of the amount of steps you take and divide by that? So if it is my first step I would and I was on a 5 and chose 3, the probability of taking it would be (5-3)/1 or 2. If it was my 100th step I would do (5-3)/100 or .02?`

At every step (iteration of the loop), you do three things if Error is -ve (i.e. your next value is less than current ):

    a. Calculate the value exp(Error/Temperature), which will be a value between 0 and 1 - (a)
    b. Generate a random number between 0 and 1 - (b)
    c. Compare. If (a) > (b), you replace current node with the next, else not.

The intuition behind this is that, at the beginning of your iterations, (a) will be a bigger value, and hence will be greater than (b) most of the time. So you pick next most of the time.

With passage of iterations, (a) will start decreasing in value and hence will be lesser than (b) most of the time. So you pick next less of the time.

Now, why (a) decreases? Because it is e raised to error (which will be negative) divided by temperature (which will decrease over time). You can plot a graph or key in values in a calculator to see how the function behaves with these inputs (i.e. error is -ve and temperature decreases).

HTH.
