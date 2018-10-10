
#' List Polygons within a directory
#'
#' Returns a list of filepaths to shapefiles. This will recursively search any
#'  subdirectories
#'
#' @param ... a list of values to be concatenated into a filepath
#' @return a list of polygons
#' @author Michael Harper
#' @export
#' @examples
#' list_polygons(system.file("extdata", package = "polyCheck"), "polygons")
#'
list_polygons <- function(..., recursive = TRUE){

  file_path <- file.path(...)

  polygons <-
    list.files(path = file_path,
               pattern = "polygon.shp$",
               full.names = TRUE,
               recursive = recursive)

  return(polygons)
}

