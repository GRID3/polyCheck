# polyCheck <img src="https://avatars1.githubusercontent.com/u/43346405?s=200&v=4" align="right" height="50" width="50" />

[![Travis-CI Build Status](https://travis-ci.org/GRID3/polyCheck.svg?branch=master)](https://travis-ci.org/GRID3/polyCheck)

The package **polyCheck** provides functions which can be used to validate delineated polygons created as part of the GRID^3^ project.

To install the package, you can use:

```
devtools::install_github("GRID3/polyCheck")
```

## User Guide

- [Basics](articles/Basics.html)


The package is designed to provide a number of diagnostics for polygons. This includes:

- **Shapefile fields**: check that the shapefiles contain the right date formats, ID etc.
- **Number of polygons per file**: each file should only contain a single shapefile.
- **Coordinate reference system**: each file should have a CRS of WGS84.
- **Proximity of polygon from survey point**: the survey point should be contained within the polygon. However, it is sometimes not possible to locate sufficient settled area within the local area, and therefore there can be valid exceptions where there is a gap between the two.
- **Settled Area Covered**: the polygon should cover between 450 and 550 settlement points.
- **Proportion of settlement type matching**: the sample points have been selected to represent a single type of settlement area. The delineated survey area should cover a single area, although having a small percentage of other areas is not a major problem.
- **ORNL Overlap**: the survey areas should not overlap areas which have previously been surveyed.

Additional diagnostics are provided which may also provide indications of polygons which require further inspection:

- **Shape Complexity**: the number of sides of the polygon is extracted. Ideally, polygons should follow simple geometric elements but this is not always possible.
- **Polsby Popper**: this is a test of compactness comparing the area against the perimeter of the shape. A value of 1 indicates a perfect circle. Ideally, shapes should not be too long and thin as these can be more difficult to survey.

Additional tools are provided to allow for the visual inspection of polygons.
