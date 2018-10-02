
#' Assess the geometry of a polygon
#'
#' Runs a number of diagnostics on the delineated polygons to check the geometry.
#'
#' @param polygon_path the relative file path to the polygon shapefile
#' @param survey_points Optional. The survey points where the delineation should occur
#' @param settlement_points Optional. The settlement type points layer
#' @param ornl Optional. A shapefile of the previously surveyed locations
#'
#' @export
#'
assess_polygon <- function(polygon_path, survey_points, settlement_points, ornl){

  cat("Checking polygon ", polygon_path, "\n")

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
  # https://www.azavea.com/blog/2016/07/11/measuring-district-compactness-postgis/
  Polsby_popper <- 4 * pi * area/perimeter^2

  ## Conflict with ORNL
  check_overlap <- !is.null(rgeos::gIntersection(ornl, shp))

  ## Results
  results <- data.frame(filename = basename(polygon_path),
                        num_features = nrow(shp),
                        as.data.frame(shp),
                        id = id,
                        crs_match =  crs_match,
                        no_points = num_points,
                        dist_from_survey = round(dist, 0),
                        prop_settlement_type = round(percent_match, 2),
                        ornl_overlap = check_overlap,
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
