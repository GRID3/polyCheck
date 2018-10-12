
#' Displays a delineated polygon in an interactive map
#'
#' Creates an interactive map for a dilineated polygon. The survey locations and settlement
#'  types may optionall be specified, which will be filtered to the relevant area for the
#'  polygon.
#'
#' @details
#' Note, the shapefiles are specified by a filepath only, while the survey and settlement
#'  points must be loaded into the memory. While this may appear inconsistent, it makes
#'  it easier to run this function for each individual shapefile when a list of maps is
#'  required.
#'
#' @param shp_path the filepath of the shapefile
#' @param survey_points A SpatialPointsDataFrame containing the survey locations
#' @param settlement_point A SpatialPointsDataFrame containing the settlement type
#'
#' @return An HTML map created by the leaflet package.
#'
#' @author Michael Harper
#' @import leaflet
#' @export
#'
#' @example R/examples/display_polygon_1.R
#'
display_polygon <- function(shp_path, survey_points = NULL, settlement_point = NULL){

  # Load the shapefile
  shp <- raster::shapefile(x = shp_path)

  # Calculate some stats for the map caption
  # These are added as labels to the maps
  area <- round(geosphere::areaPolygon(shp)/10000)
  title <- htmltools::strong(basename(shp_path))
  details <- paste("Area (hectare):", area)
  label <- paste(sep = "<br>", title, details)

  # Create the base leaflet map with no geometry
  map <- leaflet::leaflet()%>%
    leaflet::addControl(label, position = "bottomright")

  # Add Settlement points (if specified)
  if(!is.null(settlement_point)){

    # Only show the points locally
    points <- raster::intersect(settlement_point, shp)

    # Create the colour palette for the map
    pal <- leaflet::colorFactor(c("navy", "red", "green", "pink", "orange"),
                                domain = c("A", "B", "C", "D", "Z"))

    # Add to map. Includes control to be able to turn off layer
    map <- map %>%
      leaflet::addCircleMarkers(data = points,
                                radius = 0.4,
                                opacity = 0.4,
                                color = ~pal(settlement_point$type),
                                group = "Settlement Type") %>%
      leaflet::addLayersControl(overlayGroups = "Settlement Type",
                                options = leaflet::layersControlOptions(collapsed = FALSE),
                                position = "topright")
  }

  # Add the polygon to the map
  map <- map %>%
    leaflet::addProviderTiles(provider = "Esri.WorldImagery") %>%
    leaflet::addPolygons(data = shp, fillOpacity = 0.1, group = "Polygon")

  # Add survey point to map (if specified)
  if(!is.null(survey_points)){

    # Load survey point
    survey_points_data <- shapefile(survey_points)
    survey_points_data$FID <- 0:(nrow(survey_points_data)-1) # Add FID to object

    # Find the coordinate ID which matches
    id <- extract_id(shp_path)   # Extract the ID from the file name
    survey_points_id <- survey_points_data[survey_points_data$FID == id,]
    coords <- coordinates(survey_points_id)

    # Add markers to map
    map <- map %>%
      leaflet::addMarkers(lng = coords[1], lat = coords[2])

  }

  return(map)
}

