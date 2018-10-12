
#' Extract ID from polygon file name
#'
#' For a specified polygon file, extract the three digit ID. It is expected that
#'  the polygon file has the name format "mh_030_polygon.shp". The function is
#'  vectorised it can be used for single or multiple values.
#'
#' @param filepath a filepath or file name of a shapefile
#' @export
#'
#' @examples
#'  extract_id("mh_030_polygon.shp")
#'  extract_id("polygons/mh_030_polygon.shp")
#'  extract_id(c("polygons/mh_030_polygon.shp", "mh_031_polygon.shp"))
#'
extract_id <- function(filepath){

  id <- basename(filepath) %>%
    stringr::str_extract(pattern = "[:digit:]{3}") %>%
    as.numeric()

  return(id)
}
