
#' Check if an object is a spatial class
#'
is.spatial <- function(object){
    assertthat::assert_that(grepl("Spatial",class(object)),
                            msg = paste0(deparse(substitute(object)), " is not of class a spatial object"))}
