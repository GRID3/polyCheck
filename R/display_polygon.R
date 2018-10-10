
#' Displays a polygon
#'
#'


display_polygon <- function(filename){

  leaflet::leaflet(shp) %>%
    leaflet::addProviderTiles(provider = "Esri.WorldImagery") %>%
    leaflet::addPolygons() %>%
    leaflet::addMarkers(lng = coords[1], lat = coords[2])

}

