+++
date        = "2017-10-12T20:27:27-04:00"
title       = "Class Notes: Computer Vision (Georgia Tech)"
description = "This are my notes of Georgia Techs Intro to Computer Vision course"
tags        = [ "computer vision", "concepts", "classical"]
categories  = [ "computer vision" ]
slug        = "intro-to-computer-vision"
featuredImage="/post_imgs/aaron-bobick.jpg"
draft       = false
+++

These are my _raw_ notes of Georgia Tech's [Intro to Computer Vision](https://www.udacity.com/course/introduction-to-computer-vision--ud810) course taught by [Aaron Bobick](https://www.cc.gatech.edu/~afb/). Putting out mostly for me to refer to easily, but also in case anyone else finds them useful.

_This is a text heavy post._

<center>
![Img](/post_imgs/intro-cv-gt.png)
</center>

### Lecture 1: Introduction

* Course Purpose: Build systems that can do image understanding.
* Computational Photography: About capturing light from scene, record the scene and photograph and such other related artifacts that showcase the scene
* Image Processing: Support the capture and display of a scene (input: image, output: modified image)
* Computer Vision: Interpret and analyze the scene (input: image, output: meaning). It can also be video - which has temporal meaning.
* Seeing is not the same thing as measuring image properties (ref: Edward Adelson's checkerboard image). Seeing is building a _precept_ of what is in the world based on the measurements made by an image sensor. Perception is an active construction going on in your head. (ref: Dan Kresten shadow image). The brain creates a story behind what it sees.
* Use cases: Medical Image processing, Automotive applications (lane tracking, pedestrian tracking), Surveillance, Motion sensing, Sports etc.

### Lecture 2: Image as a function

* Image as a function: I(x, y), where x and y are coordinates, and I() gives us the intensity at that point. Maps from R^2 to R.
* Plot in 3D, and smooth it to get a blurry effect.
* x, and y will range from a min value to a max value. Also, the intensity will range from some min (black) to max (white).
* For color, we use 3 intensity functions for Red Green and Blue (or L, U and V). Vector-valued function.
* Image: Variation of light intensities at various locations.
* For images, usually we mark the origin at the top left corner.
* For digital images: (a) We have to _sample_ the 2D space on a regular grid (b) We have to _quantize_ each sample and round them to the nearest integer.
* Pixel stands for Picture Element
* Though we quantize and round intensities, it's better to use floating points to represent them. ints will break the math.
* In image processing tools, images are represented as matrix of integer values
* Matplot functions used: `imread()`, image indexing: `img(row, col, channel)`, `imshow()`, `plot()`, `size()`, `disp()`, image addition (when adding, to ensure max intensity is preserved, divide each image first by the number of images, then add), scalling, `imabsdiff()`, `hist()`, `linspace()`, `rand()`, `randi()`
* Math: Round down, Clip at Limits
* Blending images: scaling images by weights and adding them, making sure the sum of all weights add to 1
* Noise in image: Another function that is combined with the original image function to get a new function. I`(x,y) = I(x, y) + N(x, y)
* Salt and Pepper noise: random white and black specs in image
* Impulse noise: random occurrences of white pixels
* Gaussian noise: For every pixel, we add a value drawn from normal distribution
* noise = randn(size(im)) * sigma, where sigma is the standard deviation we want in our noise
* 0 need not be black and 255 need not be white. We should be able to map any number to black (even -ve) and any greater number to white, and ask the image library to spread the darkness to brightness between these two values.
* You normalize an image only to display it, not to compute with it
* If you are adding noise to image, magnitude of noise should be relative to the magnitude of image intensities


### Lesson 3: Filtering

* Moving average - for each pixel, replace it with the average of pixel values around it, and then move to the next pixel.
    * Assumptions: (a) The true value of a pixel is similar to the true value of pixels nearby. (b) The noise added to each pixel is done independently.
* Weighted average: While doing average, give different weights to the different pixels being averaged. E.g. the pixels near to the center pixel might have greater weight than the pixels farther away. This is nonuniform weight. Gives smoother curves. We use odd symmetric weight matrix.
* Moving average in 2D, Weighted average in 2D
* Correlation filtering (with uniform weights)
* Cross Correlation filtering (with nonuniform weights): The output is the cross-correlation of the filter/mask/kernel/coefficient with the sub image
* The filter is the matrix of the linear weights
* What makes a good blurring kernel? Box filter: All 1's. Creates a bad blur. For better blurring, we need a kernel which has higher values in the middle and falls off the edges - this will be a gaussian filter aka Circularly symmetric gaussian function aka Circularly symmetric fuzzy blob aka Isotropic
* When you design a gaussian filter, you have to take care of two things: size of the filter (3x3 or 5x5) and the sigma value of the gaussian
* When you say bigger kernel, mostly it means bigger sigma, not bigger kernel grid.
* `fspecial()` give it a size and sigma, and it creates the kernel for you. ALso `surf()`, `imfilter()`
* Remember there are two sigmas

### Lesson 4: Linearity and Convolution

* Properties of linearity: An operator H() is linear if two properties hold given two functions f1() and f2() and a constant alpha.
    * Additive: H(f1 + f2) = H(f1) + H(f2)
    * Multiplicative scaling (Homogeneity of degree 1): H(alpha * f1) = alpha * H(f1)
* Hence the filtering operation is linear given the operations we are performing
* Impulse: Building blocks of a function. In the discrete world, it's a value of 1 at a single location. In continuous world, it's a tall function with area of 1. 
* Impulse Response: Inject an impulse into a black box, the output is the impulse response. The black box behavior can be described by h(x), which is the impulse response. We can send in shifted and scaled impulses to determine it's behavior.
* Apply a filter to an impulse. The filter get's flipped left right and up down. We have done a correlation filter of an impulse.
* Center pixel is reference pixel of the filter.
* Correlation vs Convolution: Correlation flips the output, Correlation doesn't because while doing the multiplications, it flips either the kernel or the sub-image before doing the multiplication
* For symmetric or circular symmetric filters, both are same. It matters only when the filter is not symmetrical. (Also when we are taking derivatives, we have to worry about conv vs corr, direction matters)
* G = H * F (convolution)
* When convolving a filter/image with an impulse image, we get back the filter/image as a result.
* Shift invariance: Operator behaves the same everywhere, i.e. the value of the output depends on the pattern in the image neighborhood, not position of the neighborhood
* Properties of convolution (it is linear):
    * Commutative f * g = g * f
    * Associative (f * g) * h = f * (g * h)
    * Identity f * e = f, where e is unit impulse
    * Differentiation is a linear operation: d(f * g)/dx = df/dx * g, derivative of f convolving with g is equal to derivative of just f convolved with g
* Number of multiplications needed if filter is WxW and image is NxN: W*W*N*N
* If your kernel can be created by convolving a single row with a single column, it is called linearly separable kernel. Take advantage of the associative property and reduce the number of multiplications needed. Number of multiplications needed: 2W*N*N
* What happens when filter falls off the edge? FULL (bigger size than image), SAME (size), VALID (operation, but smaller size)
* How do you fill the edges where the filter sticks out? Clip (black), Wrap-around (good for periodic signals), Copy edge/Replicate (extend the same value), Reflection/Symmetric (best). Can be done using `imfilter()` function
* Sharpening filter: 2*Impulse - Box filter (Unsharp mask)
* Different kinds of noise: Median filter (aka edge preserving) is nonlinear, great for removing noise


### Lesson 5: Filters as templates

* Filters as means to get some intermediate representation of image - it's about properties of the pixels locally in the image
* Normalized Correlation - normalize the filter, normalize the patch below the filter, then do the correlation. The peak of the correlation is where the image matches the filter.
* Template matching using filters
* We use filters to localize interesting areas in the image that have some sort of property that makes the filter respond well.

### Lesson 6: Edge detection: gradients in 1D

* Features: Good things to find in the picture
* Edges are important. They can happen due to: surface normal discontinuity, depth discontinuity, surface color discontinuity, illumination discontinuity, texture changes
* We want to convert an image (a function) into a reduced set of pixels that are the important elements of the picture. It encodes the changes that matter to you.
* Look for a neighbourhood with strong signs of change. Challenges: What should be the neighborhood size? How much change is the change to consider?
* An edge is a place of rapid change in the image intensity function
* We use an operator to find edges 
* Differential operator: Returns some derivative when applied to an image. We can model these operators as masks that compute the image gradient function.
* We can threshold these gradient functions to find edge pixels.
* Multivariate: function of more than one variable. We take partial derivative, in one of the directions, to find specific edges. The gradient is a vector made up of those derivatives.
* The gradient points in the direction of the most rapid increase in intensity. The magnitude of that vector is how much it's changing as a function of a unit step in that direction.
* The Discrete Gradient (check video)
* Sobel Operator, Prewitt, Roberts
* While doing filtering for gradients, correlation works better than convolution
* Real-world: Signal has noised mixed, so it is hard to take the derivative directly and find edges. What we do is, first we smooth the noise. And then we take the derivative. so: d (h*f)/dx,where h is our smoothing function, f is the signal.
* We can also do this, we can take the derivative of the smoothing function first, then do convolution on the signal. 
* To find the max of a peak, you take one more derivative. This will result in the convolution cutting 0 with a steep slope.


### Lesson 7: Edge detection: 2D operators

* We have to think of derivative _and_direction
* Derivative of an image with gaussian filter applied for smoothing: (I * g) * hx = I * (g * hx)
* So, first you prepare a kernel by taking the gradient of a gaussian. Then you apply that filter to the image to achieve edge detection with smoothing.
* When you change the size of the sigma, you define how shart the edges should be: smaller value, finer features detected. large values, larger scale edges detected.
* To find edges: a) Smoothing derivatives to suppress noise and compute gradient. b) The threshold that gradient to find regions of significant gradient. c) Thinning to get localized edge pixels. (fat edges become single contours. d) Link and connect edge pixels.
* Canny edge operator: a) Filter image with derivative of Gaussian b) Find magnitude and orientation of gradient c) Non maximum suppression: Thin multi-pixel wide ridges down to a single pixel width d) Linking and thresholding (hysteresis) where you define two thresholds high and low, use the high threshold to start edge curves and the low threshold to continue them
* To get zero crossings, apply the laplacian operator on x and y

### Lesson 8: Hough transform: Lines

* Parametric model: can represent a class of instances where each is defined by a value of the parameters
* Choose a parametric model to represent a set of features
* Membership criterion is not local: Can't tell whether a point in the image belongs to a given model just by looking at that point
* Computational complexity is important
* Voting: a general technique where we let the features vote for all models that are compatible with it a) cycle through features, each casting votes for model parameters b) Look for model parameters that receive a lot of votes. Noise & clutter features will cast votes too, but typically their votes should be inconsistent with the majority of 'good' features. Ok if some features not observed, a model can span multiple fragments.
* Line fitting a) Given points that belong to a line, what is the line? b) How many lines are there? c) Which points belong to which lines?
* Hough transform is a voting technique to answer the above questions.
* Hough space: A line in an image corresponds to a point in the Hough space. A point in the image corresponds to a line in the hough space
* For numerical stability, we use polar representation of line (in this case, a point in image space is a sinosoid in hough space)
* Hough accumulator array: the thing which counts the votes
* Check the lecture video to know how Hough transform works

### Lesson 9: Hough transform: Circles

* Approach is same as lines. A point in image space is a circle in the Hough space. 
* If you don't know the radius, the Hough space will be 3D. The points in the image will now vote for a cone (instead of a circle) in the Hough space.
* Voting tips: Minimize irrelevant tokens first (take edge points with significant gradient magnitude). Choose good grid/discretization
* Pros of Hough: All points are processed independently, so can cope with occlusion. Some robustness to noise: noise points unlikely to contribute consistently to any single bin. Can detect multiple instances of a model in a single pass.
* Cons: Complexity of search time increases exponentially with the number of model parameters. Nontarget shapes can produce spurious peaks in parameter space. Quantization: hard to pick a good grid size.
* Hough transforms are old techniques. But good to learn how to extract structures from the image.


### Lesson 10: Generalized Hough transform

* Non-analytic models: Instead of using lines and circles, parameters express variation in pose or scale of fixed but arbitrary shape (old approach)
* Visual code-word based features: Not edges but detected templates learned from models (this is the latest approach)
* For detecting arbitrary shapes, we use a Hough Table (refer video for algorithm)
* Terms: Visual codeword with displacement vector

`Lesson 11 to 13 teach old techniques in the analogue domain. Skipping them for now.`

` Lesson 14 to 26 are mostly about camera systems. Skipping them for now.`



### Lesson 27: Introduction to Features

* Features: An idea to find reliably detectable and discriminable locations in different images. If I have some unique points in a scene, I would like to figure out where in other images do those points exist.
* The basic image point matching problem: Suppose I have two images related by some transformation. Or I have two images of the same object in different positions. How to find the transformation of image 1 that would align it with image 2? We need matching or corresponding points.
* Local Features: Goal is to find points in an image that can be a) Found in other images b) Found precisely - well-localized c) Found reliably - well matched.
* To build panorama: We need to match/align our images.
* Matching with Features:
    * Detect features (feature points or interesting points) in both images. We will use interest point operator to find interesting points.
    *  Match features - find corresponding pairs
    *  Use these pairs to align the images
* Problem 1: Detect the same point independently in both images. We need a repeatable detector.
* Problem 2: For each point correctly recognize the corresponding one. We need a reliable and distinctive descriptors.
* Feature points used in: Image alignment, 3D reconstruction, Motion tracking, Object recognition, Indexing and database retrieval, Robot navigation etc.
* What makes a good feature? _Repeatability/Precision_ - the same feature can be found in several images despite geometric and photometric transformations. _Saliency/Matchability_ - Each feature has a distinctive description. _Compactness/Efficiency_: Many fewer features than image pixels. _Locality_: A feature occupies a relatively small area of the image. Robust to clutter and occlusion.

### Lesson 28: Finding corners

* Corners have gradients in more than 1 direction. Hence they can be uniquely located.
* Harris Corners: Formula consists of Intensity, Shifted Intensity, Window function
* Refer video for the derivation of the Harris corner detection algorithm. Lots of math though.
* Shi-Tomasi is better than Harris corner. Reportedly better for the region undergoing affine deformations.
* Another corner: Brown, Szeliski and Winder
* Also there is an Improved Harris version 

### Lesson 29: Scale invariance

* Harris detector properties:
    * Rotation invariant
    * Mostly invariant to additive and multiplicative intensity changes (threshold issue for multiplicative)
    * NOT invariant to image scale by default
* Scale invariant detection: How do we choose corresponding circles _independently_ of each image, which scales as per the image and hence can give us scale invariance? The solution is to design a scale-invariant function over different size neighborhoods (different scales). Choose the scale for each image at which the function is a maximum.
* Scale Invariant detectors:
* Scale Invariant Feature Transform (SIFT): Key point localization: Find the local maximum of the difference of Gaussians in space and scale.
* Harris Laplacian: Find local maximum of harris corner detector in space (image coordinates), Laplacian in scale
* According to one report: Harris Laplacian better than SIFT better than Harris corner detector
* Till now, we have found feature points. Now we need to describe them so that they have a unique signature.


### Lesson 30: SIFT descriptor

* Detecting interest points: Harris operator, SIFT, Harris Laplacian etc.
* A descriptor is a description of the neighborhood where the interest point is
* Properties for a descriptor to have:
    * We want the descriptors to be the (almost) same in both images - invariant
    * We want the descriptors to be distinctive
* Motivation: The Harris operator was not invariant to scale, and correlation was not invariant to rotation
* Goal of SIFT: To develop an interest operator - a detector - that is invariant to scale and rotation. Also, create a descriptor that was robust to the variations corresponding to typical viewing conditions. The descriptor is the most used part of SIFT
* Idea of SIFT: Image content is represented by a constellation of local features that are invariant to translation, rotation, scale, and other imaging parameters
* The steps in SIFT:
    * (a) Scale-space extrema detection
    * (b) Keypoint localization
    * (c) Orientation assignment
    * (d) Keypoint description
    * For (a) and (b), we can use Harris Laplace or other methods  


(To be continued...)






















