Boundary Detection - July 27th, 2022

This program uses image analysis and color thresholding to detect the boundaries between layers of different colored sand and track changes in these boundaries over time (through an image series). The four colors of sand detected are bright blue, bright turquiose, bright purple, and dark pink. The purpose is to detect changes in the relative position of these sand colors over time as worms burrow through the layers.

INPUT
-images with several layers of colored sand in a thin aquaria

OUTPUT
-thresholded images showing the boundaries between each colored layer


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
INSTRUCTIONS FOR USE

OPEN BoundaryDetection.m in MATLAB.
The main code to run is BoundaryDetection.m. All other .m files need to be in the same folder as the BoundaryDetection.m, as they will be called within the primary function.

You will need to specify the path that contains the images on Line 12.

Interactive segments will walk you through choosing the images in each sequence to analyze and specifying the ROI for each image.