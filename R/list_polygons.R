
#' List Polygons within a directory
#'
#' Returns a list of filepaths to shapefiles and optionally sort these by their
#'  polygon ID. By default, this will recursively search any subdirectories.
#'
#' @param ... a list of values to be concatenated into a filepath
#' @param recursive should subdirectories be searched? Default is TRUE
#' @param sort should the filenames be sorted by ID? Default is FALSE
#'
#' @return a list of polygons
#' @author Michael Harper
#' @export
#'
#' @examples
#' list_polygons(system.file("extdata", package = "polyCheck"), "polygons")
#'
list_polygons <- function(..., recursive = TRUE, sort = FALSE){

  # Concatenate options into a filepath
  file_path <- file.path(...)

  # Load Polygons
  polygons <-
    list.files(path = file_path,
               pattern = "polygon.shp$",
               full.names = TRUE,
               recursive = recursive)

  # Optionally sort by ID
  if(sort){
    polygons_id <- polyCheck::extract_id(polygons)
    polygons <- polygons[order(rank(polygons_id))]
  }

  return(polygons)
}

