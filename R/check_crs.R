#' Validate the CRS of a shapefile
#'
#' Will extract the coordinate reference system from a SpatialObject and check that it
#'  matches a specified reference.
#'
#' @param input an object of spatial class.
#' @param crs_ref the CRS to be compared against. Defaults to WGS84
#' @param warn print a warning message if they do not match. Default is TRUE
#'
#' @export
#' @author Michael Harper
#'
check_crs <- function(input,
                      crs_ref = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0",
                      warn = TRUE){

  # Check that the objects are correct
  assertthat::assert_that(grepl("Spatial",class(input)),
                          msg = paste0(deparse(substitute(input)), " is not of class 'Spatial'"))

  # Convert crs_ref into CRS object and compare with shapefile
  ref <- sp::CRS(crs_ref)
  crs_match <- raster::compareCRS(ref, raster::crs(input))

  # Return error message if not matching
  if(!crs_match & warn) warning("The CRS of the file does not match the reference")

  # Return results
  return(crs_match)
}
