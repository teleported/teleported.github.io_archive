+++
date        = "2017-12-28T20:27:27-04:00"
title       = "COCOB: An optimizer with a learning rate"
description = "COCOB: An optimizer with a learning rate"
tags        = [ "deel learning", "optimization"]
categories  = [ "deep learning" ]
slug        = "attention"
featuredImage="/post_imgs/19-cocob-mnist-cnn-square.png"
draft       = false
+++

At the nurture.ai's NIPS paper implementation challenge, I implemented and validate the paper ['Training Deep Networks without Learning Rates Through Coin Betting'](https://arxiv.org/abs/1705.07795).

This paper caught my attention due to it's promise to get rid of the learning rate hyper-parameter during model training.

The paper says: _In this paper, we propose a new stochastic gradient descent procedure for deep networks that does not require any learning rate setting. Contrary to previous methods, we do not adapt the learning rates nor we make use of the assumed curvature of the objective function. Instead, we reduce the optimization process to a game of betting on a coin and propose a learning-rate-free optimal algorithm for this scenario._



<center>
![img](/post_imgs/19-cocob-mnist-cnn.png)
</center>

More details at my github repo: [https://github.com/anandsaha/nips.cocob.pytorch](https://github.com/anandsaha/nips.cocob.pytorch)


