
#' Assess the geometry of a polygon
#'
#' Runs a number of diagnostics on the delineated polygons to check the geometry.
#'  Checks the field parameters, the area of settled area covered and shape complexity.
#'  See the details for more information.
#'
#' @details The full diagnostics checked are as follows:
#'  \itemize{
#'    \item \strong{Shapefile fields}: check that the shapefiles contain the right date formats, ID etc.
#'    \item \strong{Number of polygons per file}: each file should only contain a single shapefile.
#'    \item \strong{Coordinate reference system}: each file should have a CRS of WGS84.
#'    \item \strong{Proximity of polygon from survey point}: the survey point should be contained within the polygon. However, it is sometimes not possible to locate sufficient settled area within the local area, and therefore there can be valid exceptions where there is a gap between the two.
#'    \item \strong{Settled Area Covered}: the polygon should cover between 450 and 550 settlement points.
#'    \item \strong{Proportion of settlement type matching}: the sample points have been selected to represent a single type of settlement area. The delineated survey area should cover a single area, although having a small percentage of other areas is not a major problem.
#'    \item \strong{ORNL Overlap}: the survey areas should not overlap areas which have previously been surveyed.
#'    }
#'
#'  Additional diagnostics are provided which may also provide indications of polygons which require further inspection:
#'  \itemize{
#'    \item \strong{Shape Complexity}: the number of sides of the polygon is extracted. Ideally, polygons should follow simple geometric elements but this is not always possible.
#'    \item \strong{Polsby Popper}: this is a test of compactness comparing the area against the perimeter of the shape. A value of 1 indicates a perfect circle. Ideally, shapes should not be too long and thin as these can be more difficult to survey.
#'  }
#'
#' @inheritParams assess_polygon
#' @author Michael Harper
#' @export
#'
#' @seealso Polsby Popper Definition: https://www.azavea.com/blog/2016/07/11/measuring-district-compactness-postgis/
#'
assess_polygons <- function(polygons, survey_points, settlement_points, ornl, merged_polygons = NULL, progress = FALSE){

  # Only display progress bar if plans to exceed 10 seconds
  pbapply::pboptions(min_time = 5)

  # Run the function
  table <- pbapply::pblapply(polygons,
                             function(x) assess_polygon(x,
                                                        survey_points,
                                                        settlement_points,
                                                        ornl,
                                                        merged_polygons,
                                                        progress))

  # Merge the results of the above function into a table and reformat
  table <-
    do.call(rbind, table) %>%
    dplyr::mutate(Pt_ids = as.numeric(Pt_ids)) %>%
    dplyr::arrange(Pt_ids)

  return(table)
}




#' Assess a single polygon
#'
#' Internal function that is used
#' @param polygon_path the relative file path to the polygon shapefile
#' @param survey_points Optional. The survey points where the delineation should occur
#' @param settlement_points Optional. The settlement type points layer
#' @param ornl Optional. A shapefile of the previously surveyed locations
#' @param merged_polygons Optional. A SpatialPolygonDataFrame of the delineated polygons created from the \code{merge_delineated_polygons} function.
#' @param progress should messages be displayed for the progress through the polygons? Default is TRUE
#'
assess_polygon <- function(polygon_path, survey_points, settlement_points, ornl, merged_polygons = NULL, progress = TRUE){

  if(progress) cat(" Checking polygon ", basename(polygon_path))

  # Add FID to object
  survey_points$FID <- 0:(nrow(survey_points)-1)

  # Load the shapefile
  shp <- raster::shapefile(x = polygon_path)

  # Extract the ID from the file name
  id <- extract_id(polygon_path)

  # Find matching survey point based on ID
  survey_points_id <- survey_points[survey_points$FID == id,]
  coords <- sp::coordinates(survey_points_id)

  ## --- Check coordinate System
  ref <- sp::CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 ")
  crs_match <- raster::compareCRS(ref, crs(shp))

  # Assign correct CRS if not present
  if(compareCRS(shp, y = NULL)) crs(shp) <- ref

  ## --- Check date formats
  dig_date <- shp$dig_date %>% base::strptime(format("%d-%b-%Y"), tz = "GMT")
  src_date <- shp$SRC_DATE2 %>% base::strptime(format("%d-%b-%Y"), tz = "GMT")

  ## --- Number of Points
  points <- raster::intersect(settlements, shp)
  num_points <- nrow(points)

  ## --- Distance between Polygon and Point
  # Data projected from degrees to metres
  crs_m <- "+init=epsg:2062"
  shp_m <- sp::spTransform(shp, CRS(crs_m))
  survey_points_id_m <- sp::spTransform(survey_points_id, CRS(crs_m))
  dist <- rgeos::gDistance(spgeom1 = shp_m, survey_points_id_m)

  ## --- Type of Land Cover
  # Reformat data to allow assessment
  points_df <- as.data.frame(points)
  settlement_type <- survey_points_id$type # Find the land type ID specified in the survey dataframe
  percent_match <- sum(points_df$type == settlement_type)/nrow(points_df)

  ## --- Geometry
  # Number of sides to polygon
  # A strange way of extracting the number of sides of the polygon
  # https://gis.stackexchange.com/questions/58147/extract-number-of-vertices-in-each-polygon-in-r
  num_sides <- sapply(shp@polygons, function(y) nrow(y@Polygons[[1]]@coords))
  num_sides

  # Try formatting the dates
  # shp$dig_date <- shp$dig_date %>% strptime(format("%d-%b-%Y"), tz = "GMT")
  # shp$SRC_DATE2 <- shp$SRC_DATE2 %>% strptime(format("%d-%b-%Y"), tz = "GMT")


  area <- geosphere::areaPolygon(shp) # Area in metres
  area_hectare <- area/10000
  perimeter <- geosphere::perimeter(shp)

  # Polsby-Popper
  # Calculate how compact the shape is compared to a circle
  Polsby_popper <- 4 * pi * area/perimeter^2

  ## Conflict with ORNL
  check_overlap <- !is.null(rgeos::gIntersection(ornl, shp))


  # Conflict with other polygons. Optional
  if(!is.null(merged_polygons)){
    self_intersect <- polygon_self_intersection(shp, merged_polygons, self_id = id)
  } else {
    self_intersect <- list(overlap = "Not Checked",
                           prop_overlap = "Not Checked")
  }


  ## Combine results into a data frame
  results <- data.frame(filename = basename(polygon_path),
                        num_features = nrow(shp),
                        as.data.frame(shp),
                        id = id,
                        crs_match =  crs_match,
                        no_points = num_points,
                        dist_from_survey = round(dist, 0),
                        prop_settlement_type = round(percent_match, 2),
                        ornl_overlap = check_overlap,
                        self_intersect_id = self_intersect$overlap,
                        self_intersect_prop = self_intersect$prop_overlap,
                        no_sides = num_sides,
                        shp_area = round(area,0),
                        shp_area_hect = round(area_hectare,2),
                        Polsby_popper = round(Polsby_popper, 2),
                        perimeter = round(perimeter, 0),
                        row.names = NULL,
                        stringsAsFactors = FALSE)


  # Return the results
  return(results)

}
