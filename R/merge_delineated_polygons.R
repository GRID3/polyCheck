
#' Merges a list of delineated polygons into a single spatial object
#'
#' @param polygons a list of polygons
#' @return A SpatialPolygonsDataFrame with the identifier column ID
#' @export
#'
merge_delineated_polygons <- function(polygons){

  # Load the polygons and merge into single object
  polygons_loaded <- lapply(polygons, function(x) raster::shapefile(x = x))

  # Warnings are suppressed to prevent NAs being flagged
  polygons_merged <- suppressWarnings(do.call(bind, polygons_loaded))

  # Delete all other parameters and add column ID as the ID stored to the object
  polygons_merged <- polygons_merged[,-(1:ncol(polygons_merged))]
  polygons_merged$ID <- polyCheck::extract_id(polygons)

  # Return the merged SPDF
  return(polygons_merged)

}






