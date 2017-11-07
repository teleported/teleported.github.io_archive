+++
date          = "2017-10-02T23:27:27-04:00"
title         = "The Batch Normalization Technique"
description   = "An intuitive explaination of batch normalization"
tags          = [ "deep learning", "techniques"]
categories    = [ "deep learning" ]
slug          = "batch-normalization-explained"
featuredImage = "/post_imgs/10-bnalgorithm.png"
draft         = false
+++

The Batch Normalization technique was proposed by researchers Sergey Ioffe, Christian Szegedy in a 2015 paper called [Batch Normalization: Accelerating Deep Network Training by Reducing Internal Covariate Shift](https://arxiv.org/abs/1502.03167). Since then, it has become an integral part of any deep network architecture.

It has been one of the most exiting innovations in recent times, having impacted 

The paper claims the following:

* It makes higher learning rates possible
* It makes proper weights initialization less critical
* Acts as a regularizer, in some cases eliminating the need for dropouts

We will be hashing each of this claims in this post.

Assignment 2 of the [cs231n course](http://cs231n.github.io/assignments2016/assignment2/) made us [implement](https://github.com/anandsaha/cs231n.assignments/blob/master/2016winter/assignment2/BatchNormalization.ipynb) the forward and backward pass of this strategy, which prompted me to write about it here.

A few concepts need to be pinned down before talking about batch normalization. Before that, we start with an intuition.

### The Intuition


### Concepts

**Vanishing and Exploding gradients**

**Variance in data**

**Depth of network**

### How we update weights


### Batch Normalization



After linear transform and before the non-linearity: makes scales of the weights normalized out.


### Whitening



![training with batch normalization](/post_imgs/10-batchnormgraphs.png)


**References**

* https://arxiv.org/abs/1502.03167
* http://cs231n.github.io/neural-networks-2/#batchnorm


