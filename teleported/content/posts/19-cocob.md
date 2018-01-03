+++
date        = "2017-12-28T20:27:27-04:00"
title       = "COCOB: An optimizer with a learning rate"
description = "COCOB: An optimizer with a learning rate"
tags        = [ "deel learning", "optimization"]
categories  = [ "deep learning" ]
slug        = "cocob"
featuredImage="/post_imgs/19-cocob-mnist-cnn-square.png"
draft       = false
+++

At the nurture.ai's NIPS paper implementation challenge, I implemented and validate the paper ['Training Deep Networks without Learning Rates Through Coin Betting'](https://arxiv.org/abs/1705.07795).

This paper caught my attention due to it's promise to get rid of the learning rate hyper-parameter during model training.

The paper says: _In this paper, we propose a new stochastic gradient descent procedure for deep networks that does not require any learning rate setting. Contrary to previous methods, we do not adapt the learning rates nor we make use of the assumed curvature of the objective function. Instead, we reduce the optimization process to a game of betting on a coin and propose a learning-rate-free optimal algorithm for this scenario._

Let us revisit the purpose of the learning rate. It defines the step size to move towards the direction of lower gradient.

<center>
`new_weight = existing_weight - learning_rate * gradient`
</center>

The central idea of the paper is that of coin betting/gambling.

* You (the optimizer) starts with an initial amount of money _epsilon_.
* At every time instant (iteration) and for each parameter, the optimizer makes a bet as to what that gradient would be in terms of magnitude and sign in the next iteration. This is denoted by the term _wi_. A sign of -ve would indicate _tails_, and +ve would indicate _heads_.
* The optimizer has to make do with the amount of money that was given to it initially. It cannot borrow any more money.
* In the next iteration when the actual results come: if he loses, he loses the betted amount; if he wins, he gets the betted amount back and in addition to that, he gets the same amount as a reward. The advantage of wining is that his corpus of money increases and he can bet more for the next iteration.
* A couple of terms are introduced: _Wealth_ and _Reward_

<center>
![wealth](/post_imgs/19-cocob-wealth-reward.png)
</center>

Wealth increases if wi (the bet) and gi (the actual gradient) are both either positive or negative - which indicates correct prediction. The reward obtained is all the wealth minus the initial corpus of money.

With these, the optimizer can make a bet for the next iteration like so:
<center>
![wealth](/post_imgs/19-cocob-bet.png)
</center>

Where the beta term denotes the percentage of current wealth the optimizer is willing to bet for the next iteration. It's sign of +ve or -ve will determine if it is calling heads (+ve gradient) or tails (-ve gradient). It is drawn from [-1, 1].


<center>
![cocob-backprop](/post_imgs/19-cocob-backprop.png)
_Fig: The COCOB-Backprop algorithm_
</center>

<center>
![img](/post_imgs/19-cocob-mnist-cnn.png)
</center>

More details at my github repo: [https://github.com/anandsaha/nips.cocob.pytorch](https://github.com/anandsaha/nips.cocob.pytorch)


