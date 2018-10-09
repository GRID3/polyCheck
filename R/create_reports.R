#' Build a diagnostics summary report
#'
#' Will create a summary report for each summary report.
#'
#' @param polygons the name of the filepath to the polygon
#' @param out_dir the output directory
#' @param input_file
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
                      output_dir = out_dir,
                      params = list(filepath = polygon),
                      quiet = TRUE)

  }
}
