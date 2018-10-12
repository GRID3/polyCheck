
#' Check whether delineated polygon intersects any other
#'
#' The check calculates whether there is any intersection within the dataset
#'
#' @param polygon the polygon to be checked
#' @param all_polygons a SpatialPolygonDataFrame as calculated from the \code{merge_delineated_polygons} function
#' @param self_id the ID of the polygon being assessed. This makes sure that the polygon excludes this file
#'
#' @seealso merge_delineated_polygons
#' @author Michael Harper
#' @export
#'
polygon_self_intersection <- function(polygon, all_polygons, self_id){

  # Exclude the polygon
  all_polygons <- all_polygons[all_polygons$ID != self_id,]

  # Find ID of overlap (if any)
  # Invisible to prevent any warnings if there is no intersection
  overlap <- suppressWarnings(raster::intersect(polygon, all_polygons))

  # If overlapping, extract the ID of the other polygon
  if(length(overlap) > 0){

    # It is possible that there are multiple polygons overlapping
    overlapping_id <- overlap$ID
    overlapping_id <- paste(overlapping_id, collapse = ', ')

    # Calculate area overlap
    overlapping_area_prop <- raster::area(overlap)/raster::area(polygon) %>%
      round(2)

  } else{
    overlapping_id <- "No Intersection"
    overlapping_area_prop <- NA
  }

  return(list(overlap = overlapping_id,
              prop_overlap = overlapping_area_prop))
}

