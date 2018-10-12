#' Validate the CRS of a shapefile
#'
#' Will extract the coordinate reference system from a polygon and check that it
#'  matches a specified reference.
#'
#' @param crs_ref the CRS to be compared against. Defaults to WGS84
#'
#' @export
#' @author Michael Harper
#'
check_crs <- function(input,
                      crs_ref = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"){

  ref <- sp::CRS(crs_ref)
  crs_match <- compareCRS(ref, crs(shp))
  return(crs_match)
}
