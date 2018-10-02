
#' Extract ID from polygon name
#'
#' For a specified polygon file, extract the three digit ID. It is expected that
#'  the polygon file has the name format "mh_030_polygon.shp".
#'
#' @param filepath a filepath or file name of a shapefile
#' @export
#'
#'
extract_id <- function(filepath){

  id <- basename(filepath) %>%
    stringr::str_extract(pattern = "[:digit:]{3}") %>%
    as.numeric()

  return(id)
}
