+++
date        = "2017-05-17T23:27:27-04:00"
title       = "AI Search Algorithms"
description = "Visualising various AI Search algorithms and developing an intuition about how they work."
tags        = ["intuitions", "visualising", "ai", "search"]
categories  = [ "artificial intelligence" ]
slug        = "ai-search-algorithms"
featuredImage="/post_imgs/03-icon.png"
+++
Search algorithms help find the correct sequence of actions in a search space, to reach a goal state. The sequence of actions might be:

* Sequence in which citis are to be visited to travel from a source to a detination under a given cost function (shortest path, cheapest fare etc.) 
* Sequence in which an agent should play moves in a game (chess, tic tac toe, pacman etc.) to win a board game
* Sequence in which a robot arm should solder components on a PCB under a given cost function (e.g. shortest time)

They are mostly implemented as graphs, where the node once visited is not expanded again if revisited during traversal (as against tree, where there is a possibility of a node getting expanded repeateadly if revisited during traversal - leading to recurssion). This blog post explores the intuitions behind how these algorithms work.

There are two broad categories of serach algorithms:

* **Uninformed**: In which the algorithm does not have any additional information about the search space other than what has been provided in the problem statement (e.g. start node, end node, nodes and edges of the graph, weights etc.)
* **Informed**: In which the algorithm has additional information other than the problem statement (e.g. euclidian distance between any node and the destination node)

<img style="float: center" src="/post_imgs/03-search-algorithms.png">

_Fig 1. Various search algorithms_

In the demonstrations below, we attempt to find the best route from Arad to a destination city in Romania. It is adapted from the map featured in AIMA book.

Acknowledgement: I have made use of the <a href="https://github.com/aimacode/aima-python">aima python code</a>, with <a href="https://github.com/anandsaha/ai-ml-algorithms/blob/master/notebooks/aima-book/Problem%20Solving.ipynb">some enhancements of my own</a>.

### Breadth First Search
<img style="float: center" src="/post_imgs/03_bfs_graph_search.gif">

Here we attempt to find a path from Arad to Neamt.

In this approach, the root node is expanded first (ofcourse), then all it's successors are expanded, then all the successor's successors are expanded and so on. In the above animation, once Arad is expanded, we visit Timisoari, Zerind and Sibiu, which are the direct successors of Arad. The search frontier then expands one depth at a time. It takes time to reach Neamt, since all the depth levels are scanned before we reach the destination.  

### Depth First Search
<img style="float: center" src="/post_imgs/03_dfs_graph_search.gif">

Here we attempt to find a path from Arad to Neamt.

Depth First Search can be a hit or a miss. DFS always expands the deepest path first. Everytime a node is expanded, it's first successor is expanded first, then the first successor's first successor is expanded and so on. As can be seen from the animation, the algorithm keep expanding the first node it gets at any depth. When we reach Urziceni, Hirsova got expanded next which leads us to the wrong path, but then the algorithm explores the next sibling, which is Vaslui, which takes us to our destination.  

### Depth Limiting Search
<img style="float: center" src="/post_imgs/03_dls_graph_search.gif">

DFS can go horribly wrong if the state space is infinite. It is also non-optimal, in that it goes to depth of the graph even if the destination happends to be near to the root but in a path which is expanded _later_. Depth limit search allows us to instruct DFS to search only till a certain depth. It can be applied to cases where we are confident of the depth at which a solution can be found.

In the above animation, we instructed the algorithm to go to a depth of 4, and abort if the destination is not found with this range.

### Iterative Deepening Search
<img style="float: center" src="/post_imgs/03_ids_graph_search.gif">

Iterative Deepening Search is a type of Depth Limiting Search where we keep increasing the depth iteratively. This is helpful in situations where we are time bound. In this case, we first search for the solution to a depth of 1, then we start over again and search for a solution to a depth of 2 and so on. We keed doing this till we have time. This is useful when the search has a timeout associated - this allows us to find the best possible move within the given time.

### Uniform Cost Search (informed search)
<img style="float: center" src="/post_imgs/03_ucs_graph_search.gif">

### A\* Search (informed search)
<img style="float: center" src="/post_imgs/03_ass_graph_search.gif">

