
#' Creates a summary report of polygon maps
#'
#' @param outDir the output directory. Defaults to the current working directory
#' @param region the name of the region. Used to add a title to the report and for
#'  file naming
#' @param survey_points_path the file path to the survey points dataset
#' @param polygon_dir the file path to the survey polygons
#' @return Creates a HTML report containing an interactive map for each polygon
#'
#' @export
#'
#' @example R/examples/build_map_reports_1.R
#'
build_map_report <- function(outDir = getwd(),
                             region = "Kaduna",
                             survey_points_path = "../1_data",
                             polygon_dir = "../2_results",
                             addDate = TRUE){

  message("Creating report in Directory:", outDir)

  # Load the template from the package
  template <- system.file("reportTemplates/mapTemplate.Rmd", package = "polyCheck")

  # Optionally add date to file name
  date <- ifelse(addDate, paste0(format(Sys.Date(),format="%Y%m%d"), "_"), "")

  fileName <- paste0(date, region, ".html")

  rmarkdown::render(input = template,
                    output_file = fileName,
                    output_dir = outDir,
                    knit_root_dir = outDir,
                    params = list(region = region,
                                  polyPath = polygon_dir,
                                  survey_points = survey_points_path))

  message("Output Created:", file.path(outDir, fileName))
}
