
#' Merges a list of delineated polygons into a single spatial object
#'
#' For a given list of shapefile filepaths, this function will load and combine
#'  the shapefiles into a single shapefile object. Each polygon will retain the
#'  original attributes assigned to it.
#'
#' @param shp_paths a list of polygons
#' @param message should progress messages be displayed? Default is TRUE
#' @return A SpatialPolygonsDataFrame with the identifier column ID
#' @export
#'
#' @example R/examples/merge_delineated_polygons_1.R
#'
merge_delineated_polygons <- function(shp_paths, message = TRUE){

  # Load the polygons and merge into single object
  if(message) message("Loading Polygons")
  shp_loaded <- pbapply::pblapply(shp_paths, function(x) raster::shapefile(x = x))

  if(message) message("Merging Polygons")
  # Warnings are suppressed to prevent NAs being flagged
  shp_merged <- suppressWarnings(do.call(raster::bind, shp_loaded))

  # Delete all other parameters and add column ID as the ID stored to the object
  shp_merged <- shp_merged[,-(1:ncol(shp_merged))]
  shp_merged$ID <- polyCheck::extract_id(shp_paths)

  # Return the merged SPDF
  if(message) message("Complete")
  return(shp_merged)

}






