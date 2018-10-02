

display_polygon <- function(filename){

  leaflet(shp) %>%
    addProviderTiles(provider = "Esri.WorldImagery") %>%
    addPolygons() %>%
    addMarkers(lng = coords[1], lat = coords[2])

}

