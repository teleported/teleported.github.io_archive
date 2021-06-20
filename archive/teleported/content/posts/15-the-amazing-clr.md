+++
date        = "2017-11-12T23:27:27-04:00"
title       = "The Cyclical Learning Rate technique"
description = "This is a tutorial on the cyclical learning rate technique"
tags        = [ "deep learning", "architecture", "training"]
categories  = [ "deep learning" ]
slug        = "cyclic-learning-rate"
featuredImage="/post_imgs/15-cyclic-lr.png"
draft       = false
+++

### Introduction

Learning rate (LR) is one of the most important hyperparameters to be tuned and holds key to faster and effective training of neural networks. Simply put, LR decides how much of the loss gradient is to be applied to our current weights to move them in the direction of lower loss.

<center>
`new_weight = existing_weight - learning_rate * gradient`
</center>

The step is simple. But as research has shown, there is so much that can be done to improve this step alone which has a profound influence on the training.

In this post, I explain [Cyclical Learning Rate](https://arxiv.org/abs/1506.01186) (CLR), a very novel and simple idea to set and control the LR during training. It was covered by [@jeremyphoward](https://twitter.com/jeremyphoward) in this year's [fast.ai course](http://www.fast.ai).

Note that CLR is very similar to [Stochastic Gradient Descent with Warm Restarts](https://arxiv.org/abs/1608.03983) (SGDR), which says, "_CLR is closely-related to our approach in its spirit and formulation but does not focus on restarts_." The [fastai library](https://github.com/fastai/fastai) uses SGDR as the annealing schedule (with the idea of an LR finder from CLR).

### Motivation

Neural networks are full of parameters that need to be trained to accomplish a certain task. _Training parameters_ typically mean finding and setting appropriate values in them, so that they minimize a loss function with each batch of training. 

<center>
<img src='/post_imgs/15-neural_network-7.png' width=300px>
_Fig.: A simple neural network where the w's and b's are to be learnt (Img Credit: [Matt Mazur](https://mattmazur.com/2015/03/17/a-step-by-step-backpropagation-example/))_
</center>

Traditionally, there has been broadly two approaches to setting the LR during training.

**One LR for all parameters**

Typically seen in [SGD](https://en.wikipedia.org/wiki/Stochastic_gradient_descent), a single LR is set at the beginning of the training, and an LR decay strategy is set (step, exponential etc.). This single LR is used to update all parameters. It is gradually decayed with each epoch with the assumption that with time, we reach near to the desired minima, upon which we need to slow down the updates so as not to overshoot it.

<center>
<img src='/post_imgs/15-learningrates.jpeg' width=300px>
_Fig. Effect of various learning rates on convergence (Img Credit: [cs231n](http://cs231n.github.io/neural-networks-3/))_
</center>


There are many challenges to this approach ([refer](https://arxiv.org/abs/1609.04747)):

* Choosing an initial LR can be difficult to set in advance (_as depicted in above figure_).
* Setting an LR schedule (LR update mechanism to decay it over time) is also difficult to be set in advance. They do not adapt to dynamics in data.
* The same LR gets applied to all parameters which might be learning at different rates.
* It is very hard to get out of a [saddle point](http://www.denizyuret.com/2015/03/alec-radfords-animations-for.html). See below.

**Adaptive LR for each parameter** 

Improved optimizers like _AdaGrad_, _AdaDelta_, _RMSprop_ and _Adam_ alleviate much of the above challenges by adapting learning rates for each parameters being trained. With Adadelta, we do not even need to set a default learning rate, as it has been eliminated from the update rule [2].

<center>
![img](/post_imgs/15-Beale.gif)
_Fig: Animation comparing optimization algorithms (Img Credit: [Alec Radford](https://www.reddit.com/r/MachineLearning/comments/2gopfa/visualizing%5fgradient%5foptimization%5ftechniques/cklhott/))_
</center>

### Cycling Learning Rate

CLR was proposed by Leslie Smith in 2015. It is an approach to LR adjustments where the value is cycled between a lower bound and upper bound. By nature, it is seen as a competitor to the adaptive LR approaches and hence used mostly with SGD. But it is possible to use it along with the improved optimizers (mentioned above) with per parameter updates.

CLR is computationally cheaper than the optimizers mentioned above. As the paper says:

`Adaptive learning rates are fundamentally different from CLR policies, and CLR can be combined with adaptive
learning rates, as shown in Section 4.1. In addition, CLR policies are computationally simpler than adaptive learning rates. CLR is likely most similar to the SGDR method that appeared recently.`[1]

**Why it works**

As far as intuition goes, conventional wisdom says we have to keep decreasing the LR as training progresses so that we converge with time. 

However, counterintuitively it might be useful to periodically vary the LR between a lower and higher threshold. The reasoning is that the periodic higher learning rates within the training help the model come out of any local minimas or saddle points if it ever enters into one. In fact, _Dauphin et al. [3] argue that the difficulty in minimizing the loss arises from saddle points rather than poor local minima.[1]_ If the saddle point happens to be an elaborate plateau, lower learning rates can never generate enough gradient to come out of it (or will take enormous time). That's where periodic higher learning rates help with more rapid traversal of the surface.

<center>
<img src='/post_imgs/15-saddlepoint.png' width=300px>
_Fig.: A saddle point in the error surface (Img Credit: [safaribooksonline](https://www.safaribooksonline.com/library/view/fundamentals-of-deep/9781491925607/ch04.html))_
</center>

A second benefit is that the optimal LR appropriate for the error surface of your model will in all probability lie between the lower and higher bounds as discussed above. Hence we do get to use the best LR when amortized over time.


**Epoch, iterations, cycles and stepsize**

These terms have specific meaning in this algorithm, understanding them will make it easy to plug them in equations.

Let us consider a training dataset with 50,000 instances. 

An _epoch_ is one run of your training algorithm across the entire training set. If we set a batch size of 100, we get 500 batches in 1 epoch or 500 iterations. The iteration count is accumulated over epochs, so that in epoch 2, we get iterations 501 to 1000 for the same batch of 500, and so one.

With that in mind, a _cycle_ is defined as that many _iterations_ where we want our learning rate to go from a _base learning rate_ to a _max learning rate_, and back. And a _stepsize_ is half of a _cycle_. Note that a cycle, in this case, need not fall on the boundary of an epoch, though in practice it does.

<center>
![clr step size](/post_imgs/15-clr-triangle.png)
_Fig: Triangular LR policy. (Img Credit: https://arxiv.org/pdf/1506.01186.pdf)_
</center>

In the above diagram, we set a _base lr_ and _max lr_ for the algorithm, demarcated by the red lines. The blue line suggests the way learning rate is modified (in a triangular fashion), with the x-axis being the iterations. A complete up and down of the blue line is one _cycle_. And _stepsize_ is half of that.

**Calculating the LR**

As we gather from the above, the following needs to be fed into the algorithm for it to work:

* number of iterations that we want in a stepsize (half of a cycle)
* base_lr 
* max_lr

Later we will see that the optimal values of these can be programatically derived. Below is a piece of code which demonstrates the way LR is calculated:

```
def get_triangular_lr(iteration, stepsize, base_lr, max_lr):
    """Given the inputs, calculates the lr that should be applicable for this iteration"""
    cycle = np.floor(1 + iteration/(2  * stepsize))
    x = np.abs(iteration/stepsize - 2 * cycle + 1)
    lr = base_lr + (max_lr - base_lr) * np.maximum(0, (1-x))
    return lr

# Demo of how the LR varies with iterations
num_iterations = 10000
stepsize = 1000
base_lr = 0.0001
max_lr = 0.001
lr_trend = list()

for iteration in range(num_iterations):
    lr = get_triangular_lr(iteration, stepsize, base_lr, max_lr)
    # Update your optimizer to use this learning rate in this iteration
    lr_trend.append(lr)

plt.plot(lr_trend)
```

<center>
<img src='/post_imgs/15-clr-graph.png' width=500px>
_Fig: Graph showing the variation of lr with iteration. We are using the triangular profile._
</center>

If you are a PyTorch user, note that there is a [pull request](https://github.com/pytorch/pytorch/pull/2016) currently open in PyTorch queue to add this learning rate scheduler in PyTorch.

**Deriving the optimal _base lr_ and _max lr_**

An optimal lower and upper bound of the learning rate can be found by letting the model run for a few epochs, letting the learning rate increase linearly and monitoring the accuracy.

We run a complete step by setting stepsize equal to num_iterations (This will make the LR increase linearly and stop as num_iterations is reached). We also set _base lr_ to a minimum value and _max lr_ to a maximum value that we deem fit. 

The accuracy plot will see an increase in accuracy as we increase the learning rate, but will plateau at a point and start decreasing again. Note the LR at which accuracy starts to increase, and also the LR when it starts stagnating. These are good points to set as _base lr_ and _max lr_

<center>
![finding base lr](/post_imgs/15-deciding-baselr-maxlr.png)
_Fig: Plot of accuracy vs learning rate (Img Credit: https://arxiv.org/pdf/1506.01186.pdf)_
</center>

Alternatively, you can note the LR where accuracy peaks, and use that as _max lr_. Set _base lr_ as 1/3 or 1/4 of this.

**Deriving the optimal cycle length (or stepsize)**

The paper suggests, after experimentation, that the stepsize be set to 2-10 times the number of iterations in an epoch. In the previous example, since we had 500 iterations per epoch, setting stepsize from 1000 to 5000 would do. The paper found not much difference in setting stepsize to 2 times num of iterations in an epoch than 8 times so.

### Variants

In addition to the triangular profile used above, the author also experimented with other functional forms.

**triangular2**: Here the _max lr_ is halved every cycle to bring down the difference between _base lr_ and _max lr_.

<center>
![triangular2](/post_imgs/15-triangular2.png)
_Fig: Graph showing the variation of lr with iteration for the triangular2 approach (Img Credit: [Brad Kenstler](https://github.com/bckenstler/CLR))_
</center>

**exp_range**: Here the _max lr_ is decayed exponentially with each iteration.

<center>
![exp_range](/post_imgs/15-exp_range.png)
_Fig: Graph showing the variation of lr with iteration for the exp-range approach (Img Credit: [Brad Kenstler](https://github.com/bckenstler/CLR))_
</center>

The amplitude is adjusted either at the end of each mini batch, or at the end of a cycle[5]. These showed improvements in comparison with fixed learning rate and exponentially decaying learning rate respectively in the paper.


### Results

CLR may provide quicker convergence on certain neural net tasks and architectures, hence it is something to try out.[5]

<center>
![CLR with Cifar10](/post_imgs/15-clr-cifar10.png)
_Fig. CLR tested on CIFAR 10 (Img Credit: https://arxiv.org/pdf/1506.01186.pdf)_
</center>

In the above test, CLR took 25k iterations to reach an accuracy of 81%, which was reached in 70,000 iterations using traditional LR techniques.
<center>
![CLR with Adam](/post_imgs/15-clr-adam.png)
_Fig. CLR used with Nesterov and Adam. Much faster convergence with Nesterov (Nesterov is an improvement over SGD) (Img Credit: https://arxiv.org/pdf/1506.01186.pdf)_
</center>

In another test, CLR with Nesterov optimizer converged much quicker than Adam.

### Conclusion

CLR brings in a novel technique to manage the learning rate and can be used with SGD or with the advanced optimizers. CLR is one technique that should be in every deep learning practitioner's tool box.

**References**

1. [Cyclical Learning Rates for Training Neural Networks, Smith](https://arxiv.org/pdf/1506.01186.pdf)
2. [An overview of gradient descent optimization algorithms, Rudder](https://arxiv.org/pdf/1609.04747.pdf)
3. Y. N. Dauphin, H. de Vries, J. Chung, and Y. Bengio. Rmsprop and equilibrated adaptive learning rates for non-convex optimization.
4. [SGDR: Stochastic Gradient Descent with Warm Restarts, Loshchilov, Hutter](https://arxiv.org/abs/1608.03983)
5. https://github.com/bckenstler/CLR
