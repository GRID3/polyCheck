#' Build a polygon diagnostics report
#'
#' For a specified polygon, this function will generate an HTML summary report providing
#'  more detailed diagnostics and an interactive map. If a list of polygon filepaths is
#'  provided, a separate report will be built for each.
#'
#' @details The full details provided by the report include:
#'  \itemize{
#'   \item A printout of the shapefile fields
#'   \item An interactive map showing the polygon and corresponding survey point
#'   \item A count of the number of settlement points within the polygon
#'  }
#'  The function is designed to be used once the settlement data, survey points and ORNL datasets
#'  have been loaded.
#'
#' @param polygons the name of the filepath to the polygon. Can be supplied a list.
#' @param out_dir the output directory
#' @author Michael Harper
#' @export
#'
create_reports <- function(polygons = polygonName, out_dir = "Reports", input_file = NULL){

  # Create directory if not there
  if(!dir.exists(out_dir)) dir.create("Reports")

  # Load the default template
  if(is.null(input_file)) input_file <- system.file("reportTemplate.Rmd", package = "polyCheck")

  # For each polygon in the list, create a report
  for(polygon in polygons){

    message("Processing Polygon:", polygon, "\n")

    output_name <- paste0(tools::file_path_sans_ext(polygon), ".html")

    # Build the report
    rmarkdown::render(input = input_file,
                      output_file =  output_name,
                      knit_root_dir = getwd(),
                      output_dir = out_dir,
                      params = list(filepath = polygon, reloadData = FALSE),
                      quiet = TRUE)

  }
}
