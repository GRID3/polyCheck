context("display_polygon checks")

# Load a sample shapefile
dataPath <- system.file("extdata", package = "polyCheck")
polygons <- list_polygons(dataPath, "polygons")
survey_points <-  raster::shapefile(file.path(dataPath, "survey_points_sample.shp"))
settlement_points <- raster::shapefile(file.path(dataPath, "settlement_points.shp"))

test_that("Check the function won't accept incorrect objects", {

  expect_error(display_polygon("someFile"))                                       # character string vector: not a shapefile
  expect_error(display_polygon("someFile.shp"))                                   # A fake shapefile which doesn't exist

  expect_error(display_polygon(polygons[1], "survey_points"))                     # non-spatial survey_points layer
  expect_error(display_polygon(polygons[1], survey_points, "settlement_points"))  # non-spatial settlement_points layer

})


