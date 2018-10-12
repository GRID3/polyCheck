# Merge the example polygons within the package
library(polyCheck)
polygons <- list_polygons(system.file("extdata/polygons", package = "polyCheck"))
polygons_all <- merge_delineated_polygons(polygons)

# Display the results
polygons_all
