context("extract_id checks")

test_that("ID Extraction", {
  expect_equal(extract_id("mh_010_shapefile.shp"), 10)                          # Shapefile Name
  expect_equal(extract_id("test/filepath/mh_010_shapefile.shp"), 10)            # With Filepath
  expect_equal(extract_id("mh_010_shape.shp"), 10)                              # Spelling Errors
  expect_equal(extract_id("mh_010-shapefile.shp"), 10)                          # Incorrect Symbol
  expect_equal(extract_id("mh-010-shapefile.shp"), 10)                          # Incorrect Symbols
  expect_equal(extract_id("shapefiles/010/mh_010_shapefile.shp"), 10)           # Numbers in filepath
  expect_equal(extract_id("mh_110_shapefile.shp"), 110)                         # Higher IDs
  expect_equal(extract_id("mh_10_shapefile.shp"), 10)                           # Two digit ID
})

# Load a sample shapefile
shapefile <- raster::shapefile(x = system.file("extdata/polygons/000_js_polygon.shp",
                                               package = "polyCheck"))


test_that("Won't accept non-character arguments", {
  expect_error(extract_id(mtcars))                # An example dataset
  expect_error(extract_id(shapefile))             # A loaded shapefile
})


