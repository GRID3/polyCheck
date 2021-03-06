% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/polygon_self_intersection.R
\name{polygon_self_intersection}
\alias{polygon_self_intersection}
\title{Check whether delineated polygon intersects any other}
\usage{
polygon_self_intersection(polygon, all_polygons, self_id)
}
\arguments{
\item{polygon}{the polygon to be checked}

\item{all_polygons}{a SpatialPolygonDataFrame as calculated from the \code{merge_delineated_polygons} function}

\item{self_id}{the ID of the polygon being assessed. This makes sure that the polygon excludes this file}
}
\description{
This internal function is used to check whether a delineated polygon intersects
 any other delineated polygons. It will report the polygon it overlaps and the
 proportion of area which overlaps.
}
\seealso{
merge_delineated_polygons
}
\author{
Michael Harper
}
