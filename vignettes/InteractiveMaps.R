## ----setup, include = FALSE----------------------------------------------

# Set the formatting options
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = TRUE,
  out.width = "100%"
)

knitr::write_bib(c("raster", "leaflet", "polyCheck"), file = "software.bib")

## ---- message = FALSE, warning = FALSE-----------------------------------
library(tidyverse)
library(raster)
library(polyCheck)
library(rgeos)

## ------------------------------------------------------------------------
# Load Data
dataPath <- system.file("extdata", package = "polyCheck")
polygons <- list_polygons(dataPath, "polygons")
survey_points <-  shapefile(file.path(dataPath, "survey_points_sample.shp"))
settlement_points <- shapefile(file.path(dataPath, "settlement_points.shp"))

## ------------------------------------------------------------------------
# Just displays the polygon
display_polygon(polygons[2])

## ------------------------------------------------------------------------
# This is a slight workaround to make the code loop work
maps <- display_polygon(polygons[3], survey_points = survey_points)
htmltools::tagList(maps)



## ------------------------------------------------------------------------
# This is a slight workaround to make the code loop work
maps <- display_polygon(polygons[3], survey_points, settlement_points)
htmltools::tagList(maps)

