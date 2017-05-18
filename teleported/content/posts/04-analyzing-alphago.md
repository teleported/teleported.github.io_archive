+++
date        = "2017-05-12T23:27:27-04:00"
title       = "Analysing AlphaGo"
description = "A look at how the AlphaGo agent works"
tags        = ["intuitions", "alphago", "ai", "research", "google", "go"]
categories  = [ "artificial intelligence", "game playing" ]
slug        = "analysing-alphago"
featuredImage="/post_imgs/04-alphago.jpg"
+++
(_I wrote this piece as part of an assignment for Udacity's AI Nanodegree program_)

'Go' is typically an adversarial <a href="/posts/ai-search-algorithms/">search problem</a> where the objective is to find the best move for the AI Agent to defeat it's opponent, given a board position. Go is a two player, deterministic game of perfect information.

<img style="width: 300px; padding:10px 30px 10px 10px" src="/post_imgs/04-alphago.jpg">

Two main factors make Go very complex to solve:

* Go has an average branching factor _b_ of ~250 options per node (chess ~35)
* Go has an average depth _d_ of ~150 moves (chess ~80)

These factos make the state space of Go (_b<sup>d</sup>_) enormous to search end to end.

**What did AlphaGo achieve?**

[AlphaGo](https://storage.googleapis.com/deepmind-media/alphago/AlphaGoNaturePaper.pdf) became the first computer Go program in the world <a href= "https://en.wikipedia.org/wiki/AlphaGo" >to have beaten a human professional Go player without handicaps on a full-sized 19x19 board.</a> 

AlphaGo achieved this at a time when the community had estimated another decade for this to be a reality.

**How did it achieve this feat?**


In general, there are three main ways in which the search space of a game tree may be traversed intelligently, keeping time and memory constraints in mind:

* _Limiting the branching factor b_ by pruning away branches which are guarenteed not to have the best moves (e.g. using alpha beta pruning)
* _Limiting the search depth d_ by using evaluation functions, which gives an estimation of a board position at a certain game state, without expanding the board further (e.g. using heuristics)
* _Converting Tree data structure to Graph_ so as to avoid expanding already visited nodes

AlphaGo makes use of these techniques in a very sophisticated way to achieve wins.

Simply put, AlphaGo uses computer vision to detect the board position, and uses deep learning and tree searching to find the best move.



Reference:


* [AlphaGo Paper](https://storage.googleapis.com/deepmind-media/alphago/AlphaGoNaturePaper.pdf)
* <a href="https://www.tastehit.com/blog/google-deepmind-alphago-how-it-works/">https://www.tastehit.com/blog/google-deepmind-alphago-how-it-works/</a>
