+++
date        = "2017-10-01T23:27:27-04:00"
title       = "Decoding the ResNet architecture"
description = "In this post, we try to understand the ResNet architecture"
tags        = [ "deep learning", "architecture", "resnet"]
categories  = [ "deep learning" ]
slug        = "decoding-resnet-architecture"
featuredImage="/post_imgs/12-resnet2.png"
+++
### Introduction



### The Challenges with Deeper Networks

This is what [cs231n](http://cs231n.github.io/neural-networks-1/#arch) suggests regarding network size:

`The takeaway is that you should not be using smaller networks because you are afraid of overfitting. Instead, you should use as big of a neural network as your computational budget allows, and use other regularization techniques to control overfitting`

With this guidance, you should be adding more nodes to your layers and more layers to your model as permitted by your hardware to train it on. That should see you though.

In fact that has been happening with ImageNet winning models since 2012. A starking trend has been to make the layers deeper, with VGG taking it to 19, and GoogLeNet taking it to 22 layers in 2014. (Note that making layers wider by adding more nodes is not preferred since it has been seen to overfit.)

![Depth of imagenet winning models](/post_imgs/12-revolution-of-depth.png)
<center>_Fig:Trend of increasing depth (Img Credit: [Kaiming He](http://kaiminghe.com/))_</center>


However in practice when the depth is pushed to extremes, we see some annomalies:

![Training and Test Error with deep networks](/post_imgs/12-deepnet-errors.png)
_Fig.: Training error (left) and test error (right) on CIFAR-10 with 20-layers and 50-layers 'plain' networks. The deeper network has higher training error, thus test error. (Img credit: https://arxiv.org/abs/1512.03385)_

Researches behind the ResNet architectures noticed that by increasing the depth of a plain network, training and test errors were actually worse than their shallow counterparts. 

It is well known that increasing the depth leads to exploding or vanishing gradients problem if weights are not properly initialized. However that can be countered by techniques like batch normalization.

Inspite of that, deeper networks (like the 50-layer one in above image) experience degradation in convergence - with accuracy getting satuarated and errors remaining higher than the shallower ones.

### Intuition behind Residual Retworks

There are a couple of intuitions that we should understand before getting into the mechanics of ResNets.

**Make it deep, but remain shallow**

Given a shallower network, how can we take it, add extra layers and make it deeper - without loosing accuracy or increasing error? It's tricky to do but one insight is that if the _extra_ layers added to the deeper network are identity mappings, they become equivalent to the shallower network. And hence, they should produce no higher training error than it's shallower counterpart. This is called a _solution by construction_ by the authors.

![Shallow and Deep Networks](/post_imgs/12-shallow-deep.png)
<center>_Fig: A Shallow network (left) and a deeper network (right) constructed by taking the layers of the shallow network and adding identity layers between them. Img Credit: [Kaiming He](http://kaiminghe.com/)._</center>


**Understanding residual**

Let us revisit the mathematical concept of a [Residual](https://en.wikipedia.org/wiki/Residual_(numerical_analysis)).

_A residual is the error in a result._ 

Let's say, you are asked to predict the age of a person, just by looking at her. If her actual age is `20`, and you predict `18`, you are off by `2`. `2` is our residual here. If you had predicted `21`, you would have been off by `-1`, our residual in this case. In essense, residual is what you should have added to your prediction to match the actual.

What is important to understand here is that, if the residual is `0`, we are not suppose to do anything to the prediction. We are to remain silent, since the prediction already matched the actual.

This can be put into a nice little diagram.

![residual](/post_imgs/12-residual3.png)

In the diagram, `x` is our prediction and we want it to be equal to the `Actual`. However, if is it off by a margin, our residual function `residual()` will kick in and produce the residual of the operation so as to correct our prediction to match the actual. If `x == Actual`, `residual(x)` will be `0`. The `Identity` function just copies `x`.


### Understanding the Residual Network


### Architectural nuances

### Conclusion



