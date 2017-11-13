+++
date        = "2017-11-12T23:27:27-04:00"
title       = "The amazing Cycling Learning Rate technique"
description = "This is a tutorial on the cycling learning rate technique"
tags        = [ "deep learning", "architecture", "training"]
categories  = [ "deep learning" ]
slug        = "im2col"
featuredImage="/post_imgs/15-cyclic-lr.png"
draft       = true
+++

### Introduction

Learning rate (LR) is one of the most important hyper parameters to be tuned, and holds key to faster and effective training of neural networks. Simply put, LR decides how much of the loss gradient is to be applied to our current weights to move them in the direction of lower loss.

<center>
`new_weight = existing_weight - learning_rate * gradient`
</center>

The step is simple. But as research has show, there is so much that can be done to improve this step alone which has profound influence on the training.

In this post, I explain [Cyclic Learning Rate](https://arxiv.org/abs/1506.01186), a very novel idea to set and control the LR during training. It was explained by [@jeremyphoward](https://twitter.com/jeremyphoward) in this year's [fast.ai course](http://www.fast.ai) and was discussed at length in the [forum](http://forums.fast.ai). It is one of those techniques which probably did not get it's due recognition among practitioners. Hence this is an attempt to spread the word!

### Motivation

Neural networks are full of parameters that needs to be trained to accomplish a certain task. _Training parameters_ typically means finding and setting appropriate values in them, so that they minimize a loss function with each batch of training. 

<center>
<img src='/post_imgs/15-neural_network-7.png' width=300px>
_Fig.: A simple neural network where the w's and b's are to be learnt (Img Credit: [Matt Mazur](https://mattmazur.com/2015/03/17/a-step-by-step-backpropagation-example/))_
</center>

Traditionally, there has been broadly two approaches to setting the LR during training.

**One LR for all parameters**

Typically seen in [SGD](https://en.wikipedia.org/wiki/Stochastic_gradient_descent), a single LR is set at the begining of the training, and a LR decay strategy is set (step, exponential etc.). This single LR is used to update all parameters. It is gradually decayed with each epoch with the assumption that with time, we reach near to the desired minima, upon which we need to slow down the updates so as not to overshoot it.

<center>
<img src='/post_imgs/15-learningrates.jpeg' width=300px>
_Fig. Effect of various learning rates on convergence (Img Credit: [cs231n](http://cs231n.github.io/neural-networks-3/))_
</center>


There are many challenges to this approach ([refer](https://arxiv.org/abs/1609.04747)):

* Choosing an initial LR can be difficult to set in advance (_as depicted in above figure_).
* Setting an LR schedule (LR update mechanism to decay it over time) is also difficult to be set in advance. They do not adapt to dynamics in data.
* The same LR gets applied to all parameters which might be learning at different rates.
* It is very hard to get out of a [saddle point](http://www.denizyuret.com/2015/03/alec-radfords-animations-for.html).

**Adaptive LR for each parameter** 

Improved optimizers like AdaGrad, AdaDelta, RMSprop and Adam alleviates much of the above challengs adapting learning rates for each parameters being trained. 



With **Cycling Learning Rate**, 




There are a few challenges to setting 


### A note on terms


### The CLR algorithm

### Variants

### Hands on with CLR