# Load Data from the package
path_data <- system.file("extdata", package = "polyCheck")

# Settlement types
path_polygons <- file.path(path_data, "polygons")
path_survey_points <-  file.path(path_data, "survey_points_sample.shp")
directory <- file.path(getwd(), "reports")

# Builds a summary report
build_map_report(outDir = directory,
                 survey_points_path = path_survey_points,
                 polygon_dir = path_polygons,
                 addDate = FALSE)

