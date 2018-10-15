context("merge_delineated_polygons checks")

# Load a sample shapefile
shapefile <- raster::shapefile(x = system.file("extdata/polygons/000_js_polygon.shp",
                                               package = "polyCheck"))

# Load data
polygons <- list_polygons(system.file("extdata/polygons", package = "polyCheck"))

test_that("Can merge a list of polygons", {
  expect_s4_class(merge_delineated_polygons(polygons[1:2]), "SpatialPolygonsDataFrame")
})

test_that("Will not accept non-valid filepaths", {
  expect_error(merge_delineated_polygons("testPath"))
  expect_error(merge_delineated_polygons(c(polygons, "testPath")))
})
