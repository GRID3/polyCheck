## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  out.width = "100%"
)

## ---- eval = FALSE-------------------------------------------------------
#  # Load Data from the package
#  path_data <- system.file("extdata", package = "polyCheck")
#  
#  # Settlement types
#  path_polygons <- file.path(path_data, "polygons")
#  path_survey_points <-  file.path(path_data, "survey_points_sample.shp")
#  directory <- getwd() # Alter this to your selected directory
#  
#  # Builds a summary report
#  build_map_report(outDir = directory,
#                   survey_points_path = path_survey_points,
#                   polygon_dir = path_polygons)

## ---- echo = FALSE-------------------------------------------------------
knitr::include_graphics("images/mapReport.png", dpi = NA)

