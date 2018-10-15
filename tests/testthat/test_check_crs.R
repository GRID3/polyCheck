context("check_crs function checks")

# Load a sample shapefile
shapefile <- raster::shapefile(x = system.file("extdata/polygons/000_js_polygon.shp",
                                               package = "polyCheck"))

test_that("check_crs identifies CRS", {
  expect_true(check_crs(shapefile))
})


# Remove CRS from shapefile and test for failure
raster::crs(shapefile)  <- NULL

test_that("check_crs identifies CRS", {

  # Return false if not matching
  expect_false(check_crs(shapefile, warn = FALSE))

  # Should give a warning if not matching
  expect_warning(check_crs(shapefile))
})


test_that("Stops if given a non-spatial object", {

  # Return false if not matching
  expect_error(check_crs("A string"))

})
