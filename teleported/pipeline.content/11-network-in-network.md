+++
date        = "2017-10-20T23:27:27-04:00"
title       = "Network In Network: The begining of Inception"
description = ""
tags        = [ "deep learning", "architecture", "inception"]
categories  = [ "deep learning" ]
slug        = "network-in-network"
featuredImage="/post_imgs/11-Network_In_Network_img2.png"
draft       = true
+++
Anyone getting introduced to convolutional networks first come acrss


This paper had a new take on how the convolution filters are designed and how we map extracted features to class scores. This formed the basis of the Inception architure. Two new concepts were introduced in this CNN architecture design:


<p align="center">
  <img src="/post_imgs/11-convnet.jpeg">
  <br>Fig. Layers in a typical CovNet (image credit: cs231n.stanford.edu)
</p>

<p align="center">
  <img src="/post_imgs/11-zeiler-fertus.jpg">
  <br>Fig. Feature visualization of CovNets (image credit: Zeiler & Fergus 2013)
</p>


* **MLPconv**: Replaced linear filters with non linear MLPs to extract better features within the receipt field. This helped in better abstraction and accuracy.
* **Global Average Pooling**: Got rid of the fully connected layers (reducing parameters and complexity) by creating as many activation maps in the last layer as there are classes. This was followed by averaging these maps to arrive at final scores, which is passed to softmax. This is performant and more intuitive.

### MLPConv

Traditional CNN architectures use linear filters to do the convolution and extract features out of images. The early layers try to extract primitive features like lines, edges and corners, while the later layers build on early layers and extract higher level features like eyes, ears, nose etc. These are called latent features. Now, there can be variations in each of those features - there can be many different variations in eyes alone. A linear filter tries to draw straight lines to discriminate these features. Thus conventional CNN implicitly makes the assumption that the latent concepts are linearly separable. But a straight line may not always fit. Using a richer non linear function approximator can serve as a better feature extractor.

<p align="center">
  <img src="/post_imgs/11-Network_In_Network_img1.png">
  <br>Fig. Conventional linear convolution layer
</p>

This paper introduced the concept of having a neural network itself in place of a convolution filter. The input to this mini network would be the convolution, and the output would be the value of a neuron in the activation. Hence it does not alter the input/output characteristics of traditional filters. This mini network, called MLPconv,can then convolved over the input. The benifit of having such an arrangement are two fold:

* It is compatible with the backpropagation logic of neural nets, thus this fits well into existing architectures of CNNs
* It can itself be a deep model leading to rich separation between latent features

<p align="center">
  <img  src="/post_imgs/11-Network_In_Network_img2.png">
  <br>Fig. MLPconv layer
</p>
### Global Average Pooling

In traditional CNN architectures, the feature maps of the last convolution layer are flattened and passed on to one or more fully connected layers, which are then passed on to softmax logistics layer for spitting out class probabilities. The issue with this approach is that it is hard to decode how the usual fully connected layers seen at the end of CNN architectures map to class probabilities. They are blackboxes between the convolution layers and the classifier. They are also prone to overfitting and come with lots of parameters to train. Can we do better?

<p align="center">
  <img  src="/post_imgs/11-Network_In_Network_img3.png">
  <br>Fig. Global Average Pooling
</p>

In the approach proposed by the paper, the last  MLPconv layer produces as many activation maps as the number of classes being predicted. Then, each map is averaged giving rise to the raw scores of the classes. These are then fed to a SoftMax layer to produce the probabilities.

The advantages of this approach are: 

* The mapping between the extracted features and the class scores is more intuitive and direct. The feature can be treated as category confidence. 
* An implicit advantage is that there are no new parameters to train (unlike the FC layers), leading to less overfitting.
* Global average pooling sums out the spatial information, thus it is more robust to spatial translations of the input.




References:

* [https://openreview.net/forum?id=ylE6yojDR5yqX](https://openreview.net/forum?id=ylE6yojDR5yqX)
