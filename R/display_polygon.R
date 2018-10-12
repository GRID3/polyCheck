
#' Displays a delineated polygon in an interactive map
#'
#' Creates an interactive map for a dilineated polygon. If the survey points file
#'  is specified, it will display the corresponding survey point. Also, it may display
#'  the settlement points.
#'
#' @param shp_path the filepath of the shapefile
#' @param survey_points_file the file path of the survey points
#' @export
#' @import leaflet
#' @author Michael Harper
#' @example
#'  poly_path <- system.file("extdata/polygons/001_js_polygon.shp", package = "polyCheck")
#'  display_polygon(poly_path)
#'
display_polygon <- function(shp_path, survey_points = NULL, settlement_point = NULL){

  # Load the shapefile
  shp <- raster::shapefile(x = shp_path)

  # Calculate some stats for the map caption
  # These are added as labels to the maps
  area <- round(geosphere::areaPolygon(shp)/10000)
  title <- htmltools::strong(basename(shp_path))
  details <- paste("Area (hectare):", area)

  label <- paste(sep = "<br>",
                 title,
                 details)

  # Create the base leaflet map with no geometry
  map <- leaflet::leaflet()%>%
    leaflet::addControl(label, position = "bottomright")

  # If Settlement points are indicated
  if(!is.null(settlement_point)){

    # Only show the points locally
    points <- raster::intersect(settlement_point, shp)

    # Create the colour palette for the map
    pal <- leaflet::colorFactor(c("navy", "red", "green", "pink", "orange"),
                                domain = c("A", "B", "C", "D", "Z"))

    # Add polygon to map. Includes control to be able to turn off layer
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

  # Plot the polygon only
  map <- map %>%
    leaflet::addProviderTiles(provider = "Esri.WorldImagery") %>%
    leaflet::addPolygons(data = shp, fillOpacity = 0.1, group = "Polygon")

  # Optionally add survey point
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

