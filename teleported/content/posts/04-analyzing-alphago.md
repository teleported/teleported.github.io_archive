+++
date        = "2017-05-12T23:27:27-04:00"
title       = "Analysing AlphaGo"
description = "A look at how the AlphaGo agent works"
tags        = ["intuitions", "alphago", "ai", "research", "google", "go"]
categories  = [ "artificial intelligence", "game playing" ]
slug        = "analysing-alphago"
featuredImage="/post_imgs/04-alphago.jpg"
+++
(_I wrote this piece as part of an assignment for Udacity's <a href="https://in.udacity.com/course/artificial-intelligence-nanodegree--nd889/">AI Nanodegree program</a>_)

### Introduction

'Go' is typically an adversarial <a href="/posts/ai-search-algorithms/">search problem</a> where the objective is to find the best move for the AI Agent to defeat it's opponent, given a board position. Go is a two player, turn taking, deterministic game of perfect information.

<img style="width: 300px; padding:10px 30px 10px 10px" src="/post_imgs/04-alphago.jpg">

Two main factors make Go very complex to solve:

* Go has an average branching factor '_b_' of ~250 options per node (chess ~35)
* Go has an average depth '_d_' of ~150 moves (chess ~80)

These factos make the state space of Go (_b<sup>d</sup>_) enormous to search end to end using traditional techniques. 

### What did AlphaGo achieve?

[AlphaGo](https://storage.googleapis.com/deepmind-media/alphago/AlphaGoNaturePaper.pdf) became the first computer Go program in the world <a href= "https://en.wikipedia.org/wiki/AlphaGo" >to have beaten a human professional Go player without handicaps on a full-sized 19x19 board.</a> 

AlphaGo achieved this at a time when the community had estimated another decade for this to be a reality.

### How did it achieve this feat?

The solution to solving a game problem of this magnitude is to be able to reduce the enormous search space to something more managable<sup>3</sup>. Additionally, the system is trained to learn how successfull moves look like, by exposing it to results of actual games played in the past.

Theoretically, there are (mainly) two ways in which the search space of a game tree may be traversed intelligently, keeping time and memory constraints in mind:

* _Limiting the [branching factor](https://en.wikipedia.org/wiki/Branching%5ffactor) b_ by pruning away branches which are guarenteed not to have the best moves (e.g. using alpha beta pruning)
* _Limiting the [game tree depth](https://en.wikipedia.org/wiki/Tree-depth) d_ by using evaluation functions, which gives an estimation of a board position at a certain depth, without expanding the board further (e.g. using heuristics)

AlphaGo makes use of these techniques in a very sophisticated (and deviated) way to achieve wins. _Deviated_ because it doesn't make use of traditional search trees directly, but uses MCTS, which works very well on huge search spaces.

There are 3 important pieces to the AlphaGo's algorithm:

1. It uses a deep neural network, called the "policy network", to _predict_ the next set of moves which are likely to win (thereby reducing the branching factor)
2. It uses a deep neural network, called the "value network", to _estimate_ the outcome (win/loss) of a board position without actually traversing till the end (thereby reducing the depth)
3. It uses Monte Carlo tree search (MCTS) which makes use of (1) and (2) to determine the best move given a board state 

The best way to start understanding AlphaGo's algorithm is to understand what MCTS is and what problem it solves. Once that is understood, it becomes easy to understand how _Policy networks_ and _Value networks_ fit in.

#### Monte Carlo Tree Search

The usual approach to solving a game problem is to create a search tree and apply one of the many search algorithms to find the next move. However, Go's search space being enormous, this approach would fall dramatically short in performance. 

MCTS is a technique to search huge (game) trees with arbitrary branching factor. It also allows you to time limit your search so that you come out with the best move that was possible to find within the given time (usually needed in competitive games).

![MCTS](/post_imgs/04-mcts.png)
Steps in MCTS _Source: researchgate.net_

The intuition behind MCTS is that:

* When you are at a certain state, you have knowledge of the tree only to a certain depth beyond which you haven't expanded the tree yet. (Remember, this is an enormous tree.)
* **Selection**: When you are at a state (node) in the tree, you try to select an action to traverse to the next state, which has high probability of winning. But which one will you select? This is given by the policy function. The policy function takes in a state and gives back an action which has high probability of winning. That's where the policy network comes into picture. You keep selecting subsequent actions until you come to a leaf state (this is not leaf of the _actual_ tree, this is leaf of the _known_ tree)
* **Expansion**: Once you have reached a leaf state, it might have many different possibilities. It is possible that at this state, there are very many possible actions to take to reach various states. You randomly take a few actions to create a few different child states.  
* **Simulation**: In this step, take the child states created above and simulate a game by taking actions choosen based on a policy. This is called a rollout policy. A simple policy can be the random policy. Each of these simulations will eventually converge to a win or lose state.
* **Back Propagation**: In this state, the win or lose evaluation is propagated up through the path up to root. The statistics of various wins or loses due to such simulations is recorded in each node. Eventually, a winning path emerges.


#### The Policy Network

As stated earlier, the policy network helps AlphaGo predict the set of next winning moves. The policy network was trained on 30 million moves collected from previously played games by humans. This is a form of supervised learning. Post this the network was made to play itself thousands of times via reinforcement learning. Reinforecement learning helped policy network to discover new strategies apart from what humans have used.

#### The Value Network
The value network is training using the policy network via reinforcement learning. 



#### So, putting it together

#### Conclusion


References:


1. [AlphaGo Paper](https://storage.googleapis.com/deepmind-media/alphago/AlphaGoNaturePaper.pdf)
2. [TasteHit blog post](https://www.tastehit.com/blog/google-deepmind-alphago-how-it-works/)
3. [Google blog post](https://research.googleblog.com/2016/01/alphago-mastering-ancient-game-of-go.html)
4. [Monte Carlo Tree Search](https://en.wikipedia.org/wiki/Monte_Carlo_tree_search)
5. [StackExchange discussion](https://datascience.stackexchange.com/questions/10932/difference-between-alphagos-policy-network-and-value-network)
