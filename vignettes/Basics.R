## ----setup, include = FALSE----------------------------------------------
# This is not displayed in the vignette

# Set the formatting options
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

knitr::write_bib(c("raster", "leaflet", "polyCheck"), file = "software.bib")

## ---- message = FALSE, warning = FALSE-----------------------------------
library(tidyverse)
library(raster)
library(polyCheck)
library(rgeos)

## ----loadData------------------------------------------------------------
# Load filepath from repository
dataPath <- system.file("extdata", package = "polyCheck")

# Settlement types
settlements <- shapefile(file.path(dataPath, "settlement_points.shp"))

# Survey Points
survey_points <-  shapefile(file.path(dataPath, "survey_points_sample.shp"))

# We must mimic how the FID is generated 
survey_points$FID <-  0:(nrow(survey_points)-1)

# load the ORNL data
ornl <- shapefile(file.path(dataPath, "ornl.shp"))

## ------------------------------------------------------------------------
polygons <- list_polygons(dataPath, "polygons")
basename(polygons)

## ------------------------------------------------------------------------
polygons_all <- merge_delineated_polygons(polygons)
polygons_all

## ------------------------------------------------------------------------
diagnostics <- 
  assess_polygons(polygons[1],
                survey_points,
                settlement_points,
                ornl,
                polygons_all,
                progress = FALSE)

## ---- echo = FALSE-------------------------------------------------------

# Reformat data to display in table
table <- t(diagnostics) %>%
  as.data.frame() %>%
  rownames_to_column()

knitr::kable(table,
             col.names = c("Parameter", "Value"),
             format = "html",
             caption = "Diagnostic Values") %>%
  kableExtra::kable_styling(bootstrap_options = c("striped", "hover"))

## ------------------------------------------------------------------------
diagnostics <- 
  assess_polygons(polygons,
                survey_points,
                settlement_points,
                ornl,
                polygons_all)

## ---- echo = FALSE-------------------------------------------------------
DT::datatable(diagnostics, options = list(autoWidth = TRUE,
                                    pageLength = 10,
                                    scrollX = TRUE,
                                    scrollCollapse = TRUE,
                                    dom = 't'))

