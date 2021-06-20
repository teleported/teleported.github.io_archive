+++
date        = "2017-11-07T23:27:27-04:00"
title       = "Conceptual understanding of Transfer Learning"
description = "In this post, I try to cover some aspects of training deep neural networks"
tags        = [ "deep learning", "architecture", "training"]
categories  = [ "deep learning" ]
slug        = "transfer-learning-concepts-techniques"
featuredImage="/post_imgs/13-transfer-learning.svg.png"
draft       = true
+++

### Introduction

This is a summary of the transfer learning concepts and techniques taught in [fast.ai's](http://www.fast.ai/) 2017 session, which I am attending as an international fellow. You can access the course notebooks and get hands on at [fastai github repo](https://github.com/fastai/fastai/tree/master/courses/dl1). This article remains at a conceptual level and is aimed at `beginners`.

Transfer learning is almost an art (_plenty of knobs to turn and try_) and the most important skillset that you can cultivate in the deep learning space. With transfer learning, you leverage years of research and weeks of model training that big companies invest in. This is a faster strategy to realize your use cases and go to market - all while getting cutting edge results.

By the end of this article, you should have a better grasp on the concepts, approaches and techniques and should feel comfortable coding it up. 

In this article I will mostly use image classification as an example, but you can extend it to other use cases as well.


### The convolutional network
<center>
![CNN](/post_imgs/13-typical-cnn.png)<br>
_Fig 1: Typical convolutional network (Img Credit: [www.ais.uni-bonn.de](http://www.ais.uni-bonn.de/deep%5flearning/))_
</center>


First let's revisit the architecture of a convolutional neural network and highlight some of it's salient characteristics:

1. They are made of layers of neurons
* The layers can be grouped into two parts:
  * The frontal part consisting of the _convolutional_ layers (L1 to L4 in _Fig 1_)
  * The later part consisting of the _fully connected_ layers (L5 and L6 in _Fig 1_)
* Purpose of the _convolutional layers_ are to extract unique characteristics (also called features) from the images it sees. Hence they are also called _feature extractor_.
* Purpose of the _fully connected_ layers is to take the features extracted by the _convolutional layers_ and classify them correctly. They usually have one or more dense layers followed by a function like _softmax_ for classification. In the above case, it seems we are dealing with 5 classes as suggested by the F6 layer.

_Note 1: Any simple or advanced model, be it [vgg19](https://www.pyimagesearch.com/wp-content/uploads/2017/03/imagenet%5fvgg16.png) or [resnet152](http://slideplayer.com/slide/10434038/35/images/18/Network+Design+ResNet-152+Use+bottlenecks.jpg), can be segregatated this way into a feature extractor and a classifier._

_Note 2: The convolution layers and FC layers will have other types of layers as well, interleaved. Like batchnorm, activation etc._

_Food for thought: Why do you need a feature extractor? Why can't you directly inject the image in a classifier?_

### About Models, learnable parameters and weights

At this point, we have to segregate between a _model_ and it's _weights_. If you are from an object oriented background, the model is like the _class_, weights are like the _objects_ instantiated from the class which holds meaningful values.

_Fig 1_ above shows a model.

If <label style='background-color:#eeeeee;font-family:coutier new'>&nbsp;w<sub>1</sub>*x + w<sub>2</sub>*x<sup>2</sup> + b = 0 &nbsp;</label> is your model, <label style='background-color:#eeeeee;font-family:coutier new'>w<sub>1</sub></label>, <label style='background-color:#eeeeee;font-family:coutier new'>w<sub>2</sub></label> and <label style='background-color:#eeeeee;font-family:coutier new'>b</label> are your learnable parameters. <label style='background-color:#eeeeee;font-family:coutier new'>w<sub>1</sub>=10, w<sub>2</sub>=20 and b=2</label> are specific weights for a use case that it might have learnt.

Model is what you would call the architecture of the neural net: the number, sequence and dimensions of layers, activation functions, classifier etc. Models have trainable parameters which gets instantiated when the model is loaded in memory. Weights are the learnt values held in the trainable parameters of the model.

### Training a model

When you load a model in memory, all the traiable parameters of the model hold carefully initialized but random weights, totally incapable of understanding any image.

As you keep training the model, the weights are adjusted a little bit everytime a batch of images is passed through it.

The final goal is to learn proper weights of these trainable parameters so that:

* The feature extractor extracts the appropriate features
* The classifier appropriately maps the extracted features to the right labels

These are the things you will need to train a model:

<center>
![To train a model](/post_imgs/13-to-train-a-model.png)
_Fig: Things needed to train a model using transfer learning_
</center>

We will be covering each of these aspects in the following sections.

### Model selection

Chances are, the model you need for your use case is already out there. Battle tested, with a few wins and designed by best researchers with best infrastructure money can buy, all for free!

<center>
![To train a model](/post_imgs/13-model-families.png)
_Fig: Examples of pre existing models for various use cases, developed by top notch researchers_
</center>

Popular deep learning libraries like [Tensorflow](http://www.tensorflow.org), [Keras](https://keras.io/) and [PyTorch](http://pytorch.org/) makes these models available out of the box. And what's more, they also keep a uniform interface to these models which makes it easy to swap them to compare and contrast.

_Hence if your use case is non trivial, scan the literatures for a pre existing model that you might leverage._


### Transfer learning

At this point, it is ripe to talk about the transfer learning concept. And let's start with a metaphor.

<div style='background-color:#eeeeee; padding: 15px 15px 15px 15px'>
Let's say you need to hire a programmer.
<br><br>
If you hire a novice with the intent of teaching him from scratch, you might have to start by teaching him some of the fundamental concepts of programming, like the language syntax, compilation and debugging. Then you would teach him higher level concepts like coding standards, design patterns and test automation. And <i>then</i> you arrive at discussing the application that you are building. This is time consuming, and the results are not guaranteed.
<br><br>
On the other hand, you can hire an experienced programmer and start discussing your application straight away, since she is already familier with the fundamental and higher level concepts. Thus, the experienced programmer can easily transfer her earlier learnings to your new application.
</div>

Our models behave this way. Once you are with a use case (classify dogs and cats, for e.g.):

`a)` You can either start with a blank model and train it on your datasets to derive at the correct weights. 

`b)` OR you can start with a model with weights that was pretrained by someone else on a much larger and similar dataset, tune it a little and train it on your dataset (and classes) to derive at the correct weights. 

The second approach is much faster, and usually more accurate. It is called _transfer learning_.

Getting back to the metaphor, when models are untrained, they are like the novice programmer and needs to be trained from scratch. However when they use pre trained weights, they are pre-trained in the fundamentals and are like the experienced programmer which can be moulded for any use case.
 
<center>
![Feature detection](/post_imgs/11-zeiler-fertus.jpg)
_Fig. Hierarchy of features extracted from various layers (Img Credit: https://arxiv.org/abs/1311.2901)_
</center>

To connect everything to our convolutional networks, let's look at how they recognize images. Once trained, the early layers try to extract primitive features like lines, edges, and corners. The middle layers build on top of them to recognize shapes. The later layers build on middle layers and extract higher-level features like eyes, ears, nose etc. 

The features extracted by early and middle layers (or so) are very primitive and universal in nature. Which means, if you take a model (i.e. it's weights) already trained on a large dataset with millions of images and hundreds of classes, it would have learnt these primitive features very well to the extent that it can identify these features in unseen classes outside of the dataset.

That means, these early layers can be leveraged while training new classes of images. Let us see how that is done.

### Pre trained weights

Image datasets like [ImageNet](http://www.image-net.org/) and [COCO](http://cocodataset.org/) contains thousands of classes and millions of images to train models on. They form the benchmark on which new computer vision architectures are tested. Companies and people with enough resources (GPUs, mainly) train cutting edge models on these datasets. Once these models are fully trained, the weights are extracted and made available for anyone to download and use (by philanthropic companies and people).

<table>
<div style='width:50%; margin: 0 auto'>
    <div style='float:left; padding-right:20px; padding-top:15px'><a href="http://www.image-net.org/"><img src='/post_imgs/13-imagenet.jpg' width='150px'></a></div>
    <div style='float:left'><a href="http://cocodataset.org/"><img src='/post_imgs/13-coco-logo.png' width='150px'></a></div>
</div>
</table>


Now, why are these useful to us?

Training any model on these datasets take days and weeks to converge, using tens of GPU's and computing and network resources - something that might not be available to every individual and every company. However when the weights are accessible, the learning can be transfered to our new use cases. Cool, right?

_Note: The model implementation and it's weights go hand in hand. For e.g. you cannot load weights trained on a Tensorflow implementation of ResNet34, on a PyTorch implementation of ResNet34. There are some projects which aim for this interoperability, though._

### Data, Loss function, measure of accuracy, Optimizer


_Note 1: The training of the  model is the responsibility of what are called optimizers. SGD, Adam, RMSprop are some of the examples. More later._

_Note 2: Optimizers are agnostic of the type of neural network you are training: simple ones, CNN's or RNN's. They are like a bull, with the sole aim to reduce the loss by adjusting parameters_

### Fine tuning


#### Model tuning


#### Data augmentation

#### Optimizer tuning

#### Learning rate tuning
