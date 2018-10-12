<!-- README.md is generated from README.Rmd. Please edit that file -->
polyCheck <img src="https://avatars1.githubusercontent.com/u/43346405?s=200&v=4" align="right" height="50" width="50" />
========================================================================================================================

[![Travis-CI Build Status](https://travis-ci.org/GRID3/polyCheck.svg?branch=master)](https://travis-ci.org/GRID3/polyCheck)

The package **polyCheck** provides functions which can be used to validate delineated polygons created as part of the GRID<sup>3</sup> project. The diagnostics check include:

-   Polygon Geometry (area, perimeter, shape complexity etc.)
-   Coordinate Reference Systems
-   Polygon settlement type
-   Does the polygon overlap previously surveyed areas.

It should be noted that the checks are designed to *support*, not *replace*, the manual verification process. It is still important that the outline of polygons is still

Installation
------------

To install the package, you can use:

    devtools::install_github("GRID3/polyCheck")

User Guide
----------

To see how to use the package check out the vignettes:

-   [Basics](articles/Basics.html)
-   [Interactive Maps](articles/InteractiveMaps.html)

Quick Examples
--------------

![](README_files/figure-markdown_github/unnamed-chunk-1-1.png)
