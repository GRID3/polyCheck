#' Validate the CRS of a shapefile
#'
#' @param crs_ref

check_crs <- function(input, crs_ref = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 "){

  ref <- sp::CRS(crs_ref)

  crs_match <- compareCRS(ref, crs(shp))
}
