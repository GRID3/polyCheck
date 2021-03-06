% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/build_report.R
\name{build_map_report}
\alias{build_map_report}
\title{Creates a summary report of polygon maps}
\usage{
build_map_report(outDir = getwd(), region = "Kaduna",
  survey_points_path = "../1_data", polygon_dir = "../2_results",
  addDate = TRUE)
}
\arguments{
\item{outDir}{the output directory. Defaults to the current working directory}

\item{region}{the name of the region. Used to add a title to the report and for
file naming}

\item{survey_points_path}{the file path to the survey points dataset}

\item{polygon_dir}{the file path to the survey polygons}
}
\value{
Creates a HTML report containing an interactive map for each polygon
}
\description{
Creates a summary report of polygon maps
}
\examples{
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

}
