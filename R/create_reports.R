create_reports <- function(polygons = polygonName, inputFile = "Kaduna Validation.Rmd", directory = "Reports"){

  # Create directory if not there
  if(!dir.exists(directory)) dir.create("Reports")

  # For each polygon in the list, create a report
  for(polygon in polygons){

    message("Processing Polygon:", polygon, "\n")

    output_name <- paste0(tools::file_path_sans_ext(polygon), ".html")

    # Build the report
    rmarkdown::render(input = inputFile,
                      output_file =  output_name,
                      output_dir = directory,
                      params = list(filepath = polygon),
                      quiet = TRUE)

  }


}
