# Colour Transfer

A major problem in the post production industry is matching the colour between different shots possibly taken at different times in the day. This process is part of the large activity of film grading in which the film material is digitally manipulated to have consistent grain and colour. The term colour grading is used here specifically to refer to the matching of colour. Colour grading is important because shots taken at different times under natural light can have a substantially different feel due to even slight changes in lighting.

Currently in the industry, colour balancing (as it is called) is achieved by experienced artists who use edit hardware and software to manually match the colour between frames by tuning parameters. For instance, in an effort to balance the red colour, the digital samples in the red channel in one frame may be multiplied by some factor and the output image viewed and compared to the colour of some other (a target) frame. The factor is then adjusted if the match in colour is not quite right. The amount of adjustment and whether it is an increase or decrease depends crucially on the experience of the artist. This is because it is a delicate task since the change in lighting conditions induces a very complex change of illumination. It would be beneficial to automate this task in some way.

The techniques proposed here are example-based re-colouring methods which can be illustrated by the picture above. The original picture is required to be transformed so that its colours match the palette of the image in the middle, regardless of the content of the pictures.


## ND-DISTRIBUTION TRANSFER

In [1,2,3] an iterative colour transfer method is discussed. Since it is known how to perform intensity transfer on grayscale pictures, the proposed idea is to cycle through all the colour spectrum and apply iteratively the 1D colour transfer technique. The method is efficient as it only requires the manipulation of 1D colour marginals.

## MONGE-KANTOROVITCH LINEAR COLOUR TRANSFORMATION

Before considering fully non-linear techniques, it is often useful to find the parameters of linear colour transformation. In Photoshop for instance, adjusting the colours require to tune a half dozen parameters like the brightness, contrast, colour filter, colour mixing, etc. Different mappings can achieve this tuning and in [4] it explored in details how to find such mappings. It is also proposed in [4] a solution to the minimal colour displacement mapping, which is based on the Monge-Kantorovitch linear solution.

## References

     1. N-Dimensional Probability Density Function Transfer and its Application to Colour Transfer.
 	   	  F. Pitié , A. Kokaram and R. Dahyot (2005) In International Conference on Computer Vision (ICCV'05). Beijing, October.
	 2. Towards Automated Colour Grading. F. Pitié, A. Kokaram and R. Dahyot (2005) In 2nd IEE European Conference on Visual Media Production (CVMP'05). London, November.
	 3. Automated colour grading using colour distribution transfer. F. Pitié , A. Kokaram and R. Dahyot (2007) Journal of Computer Vision and Image Understanding.
	 4. The Linear Monge-Kantorovitch Colour Mapping for Example-Based Colour Transfer. F. Pitié and A. Kokaram (2007) In IEE European Conference on Visual Media Production (CVMP'06). London, December.

## Content

This package contains two scripts to run colour grading as described in [1,2,3]

The grain reducer technique is not provided here.
Note that both pictures are copyrighted.




send an email to fpitie@mee.tcd.ie if you want more information
