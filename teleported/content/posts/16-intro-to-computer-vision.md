+++
date        = "2017-10-12T20:27:27-04:00"
title       = "Class Notes: Intro to Computer Vision (Georgia Tech)"
description = "This are my notes of Georgia Techs Intro to Computer Vision course"
tags        = [ "computer vision", "concepts", "classical"]
categories  = [ "computer vision" ]
slug        = "intro-to-computer-vision"
featuredImage="/post_imgs/16-intro-to-computer-vision.png"
draft       = false
+++

These are my notes of Georgia Tech's [Intro to Computer Vision](https://www.udacity.com/course/introduction-to-computer-vision--ud810) course.

_This is a text heavy post._

### Lecture 1: Introduction

* Course Purpose: Build systems that can do image understanding.
* Computational Photography: About capturing light from scene, record the scene and photograph and such other related artifacts that showcase the scene
* Image Processing: Support the capture and display of a scene (input: image, output: modified image)
* Computer Vision: Interprete and analyze the scene (input: image, output: meaning). It can also be video - which has temporal meaning.
* Seeing is not the same thing as measuring image properties (ref: Edward Adelson's checkerboard image). Seeing is building a _precept_ of what is in the world based upon the measurements made by an image sensor. Perception is an active construction going on in your head. (ref: Dan Kresten shadow image). The brain creates a story behind what it sees.
* Use cases: Medical Image processing, Automotive applications (lane tracking, pedestrian tracking), Surveilance, Motion sensing, Sports etc.

### Lecture 2: Image as a function

* Image as a function: I(x, y), where x and y are coordinates, and I() gives us the intensity at that point. Maps from R^2 to R.
* Plot in 3D, and smooth it to get blurry effect.
* x, and y will range from a min value to a max value. Also the intensity will range from some min (black) to max (white).
* For color, we use 3 intensity functions for Red Green and Blue (or L, U and V). Vector valued function.
* Image: Variation of light intensities at various locations.
* For images, usually we mark the origin at the top left corner.
* For digital images: (a) We have to _sample_ the 2D space on a regular grid (b) We have to _quantize_ each sample and round them to the nearest integer.
* Pixel stands for Picture Element
* Though we quantize and round intensities, it's better to use floating points to represent them. ints will break the math.
* In image processing tools, images are represented as matrix of integer values
* Matplot functions used: `imread()`, image indexing: `img(row, col, channel)`, `imshow()`, `plot()`, `size()`, `disp()`, image addition (when adding, to ensure max intensity is preserved, divide each image first by the number of images, then add), scalling, `imabsdiff()`, `hist()`, `linspace()`, `rand()`, `randi()`
* Math: Round down, Clip at Limits
* Blending images: scalling images by weights and adding them, making sure the sum of all weights add to 1
* Noise in image: Another function that is compined with the original image function to get a new function. I`(x,y) = I(x, y) + N(x, y)
* Salt and Pepper noise: random white and black specs in image
* Impulse noise: random occurances of white pixels
* Gaussian noise: For every pixel, we add a value drawn from normal distribution
* noise = randn(size(im)) * sigma, where sigma is the standard deviation we want in our noise
* 0 need not be black and 255 need not be white. We should be able to map any number to black (even -ve) and any greater number to white, and ask the image library to spread the darkness to brightness between these two values.
* You normalize an image only to display it, not to compute with it
* If you are adding noise to image, magnitude of noise should be relative to the magnitute of image intensities


### Lesson 3: Filtering

* Moving average - for each pixel, replace it with the average of pixel values around it, and then move to the next pixel.
    * Assumptions: (a) The true value of a pixel are similar to the true value of pixels nearby. (b) The noise added to each pixel is done independently.
* Weighted average: Whild doing average, give different weightages to the different pixels being averaged. E.g. the pixels near to the center pixel might have greater weight than the pixels farther away. This is non uniform weightage. Gives smoother curves. We use odd symmetric weight matrix.
* Moving average in 2D, Weighted average in 2D
* Correlation filtering (with uniform weights)
* Cross Correlation filtering (with non uniform weights): The output is the cross correlation of the filter/mask/kernel/coefficient with the sub image
* The filter is the matrix of the linear weights
* What makes a good blurring kernel? Box filter: All 1's. Creates a bad blur. For better blurring, we need a kernel whic hhas higher values in the middle and falls off the edges - this willbe a gaussian filter aka Circularly symmetric gaussian function aka Circularly symmetric fuzzy blob aka Isotropic
* When you design a gaussian filter, you have to take care of two things: size of the filter (3x3 or 5x5) and the sigma value of the gaussian
* When you say bigger kernel, mostly it means bigger sigma, not bigger kernel grid.
* `fspecial()` give it a size and sigma, and it creates the kernel for you. ALso `surf()`, `imfilter()`
* Remember there are two sigmas

### Lesson 4: Linearity and Convolution

* Properties of linearity: An operator H() is linear if two properties hold given two functions f1() and f2() and a constant alpha.
    * Additive: H(f1 + f2) = H(f1) + H(f2)
    * Multiplicative scalling (Homogenity of degree 1): H(alpha * f1) = alpha * H(f1)
* Hence the filtering operation is linear given the operations we are performing
* Impulse: Buiulding blocks of a function. In discrete world, it's a value of 1 at a single location. In continuous world, it's a tall function with area of 1. 
* Impulse Response: Inject an impulse into a black box, the output is the impulse response. The black box behaviour can be described by h(x), which is the impulse response. We can send in shifted and scalled impulses to determine it's behaviour.
* Apply a filter to an impulse. The filter get's flipped left right and up down. We have done a corelational filter of an impulse.
* Center pixel is reference pixel of the filter.
* Correlation vs Convolution: Correlation flips the output, Correlation doesn't because while doing the multiplications, it flips either the kernel or the sub image before doing the multiplication
* For symmetric or circular symmetric filters, both are same. It matters only when the filter is not symmetrical. (Also when we are taking derivatives, we have to worry about conv vs corr, direction matters)
* G = H * F (convolution)
* When convolving a filter/image with an impulse image, we get back the filter/image as a result.
* Shift invariance: Operator behaves the same everywhere, i.e. the value of the output depends on the pattern in the image neighbourhood, not position of the neighbourhood
* Properties of convolution (it is linear):
    * Commutative f * g = g * f
    * Associative (f * g) * h = f * (g * h)
    * Identity f * e = f, where e is unit impulse
    * Differentiation is a linear operation: d(f * g)/dx = df/dx * g, derivative of f concolving with g is equal to derivative of just f convolved with g
* Number of multiplications needed if filter is WxW and image is NxN: W*W*N*N
* If you kernel can be created by convolving a single row with a single column, it is called linearly separable kernel. Take advantage of the associative property and reduce the number of multiplications needed. Number of multiplications needed: 2W*N*N
* What happens when filter falls off the edge? FULL (bigger size than image), SAME (size), VALID (opeartion, but smaller size)
* How do you fill the edges where the filter sticks out? Clip (black), Wrap around (good for periodic signals), Copy edge/Replicate (extend the same value), Reflection/Symmetric (best). Can be done using `imfilter()` function
* Sharpening filter: 2*Impulse - Box filter (Unsharp mask)
* Different kinds of noise: Median filter (aka edge preserving) is non linear, great for removing noise


### Lesson 5: Filters as templates

* Filters as means to get some intermediate representation of image - it's about properties of the pixels locally in the image
* Normalized Correlation - normalize the filter, normalize the patch below the filter, then do the correlation. The peak of the correlation is where the image matches the filter.
* Template matching using filters
* We use filters to localize interesting aras in image that have some sort of property that makes the filter respond well.

### Lesson 6: Edge detection: gradients in 1D

* Features: Good things to find in the picture
* Edges are important. They can happen due to: surface normal discontinuity, depth discontinuity, surface color discontinuity, illumination discontinuity, texture changes
* We want to convert an image (a function) into a reduced set of pixels that are the important elements of the picture. It encodes the changes that matter to you.
* Look for neighbourhood with strong signs of change. Challenges: What should be the neighbourhood size? How much change is the change to consider?
* An edge is a place of raiod change in the image intensity function
* We use an operator to find edges 
* Differential operator: Returns some derivative when applied to an image. We can model these operators as masks that compute the image gradient function.
* We can threshold these gradient functions to find edge pixels.
* Multivariate: function of more than one variable. We take partial derivative, in one of the directions, to find specific edges. Gradient is a vector made up of those derivatives.
* The gradient points in the direction of the most rapid increase in intensity. Magnitude of that vector is how much it's changing as a function of a unit setp in that direction.
* The Discrete Gradient (check video)
* Sobel Operator, Prewitt, Roberts
* While doing filtering for gradients, correlation works better than convolution
* Real world: Signal has noised mixed, so it is hard to take the derivative directly and find edges. What we do is, first we smooth the noise. And then we take the derivative. so: d (h*f)/dx,where h is our smoothing function, f is the signal.
* We can also do this, we can take the derivative of the smoothing function first, then do convolution on the signal. 
* To find the max of a peak, you take one more derivative. This will result in the convolution cutting 0 with a steep slope.


### Lesson 7: Edge detection: 2D operators

* We have to think of derivative _and_direction
* Derivative of an image with gaussian filter applied for smoothing: (I * g) * hx = I * (g * hx)
* So, first you prepare a kernel by taking gradient of a gaussian. Then you apply that filter to the image to achieve edge detection with smoothing.
* When you change size of the sigma, you define how shart the edges should be: smaller value, finer features detected. large values, larger scale edges detected.
* To find edges: a) Smoothing derivatives to suppress noise and compute gradient. b) Threshold that gradient to find regions of significant gradient. c) Thinning to get localized edge pixels. (fat edges become single contours. d) Link and connect edge pixels.
* 
