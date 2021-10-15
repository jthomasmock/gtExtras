# Function to skip tests if Suggested packages not available on system
check_suggests <- function() {
  skip_if_not_installed("rvest")
  skip_if_not_installed("xml2")
}


test_that("svg is created and has specific values", {
  check_suggests()

  # basic sparkline
  gt_sparkline_tab <- mtcars %>%
    dplyr::group_by(cyl) %>%
    # must end up with list of data for each row in the input dataframe
    dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
    gt() %>%
    gt_sparkline(mpg_data)

  gt_spark_hist <- mtcars %>%
    dplyr::group_by(cyl) %>%
    # must end up with list of data for each row in the input dataframe
    dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
    gt::gt() %>%
    gt_sparkline(mpg_data, type = "histogram")

  gt_spark_dens <- mtcars %>%
    dplyr::group_by(cyl) %>%
    # must end up with list of data for each row in the input dataframe
    dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
    gt::gt() %>%
    gt_sparkline(mpg_data, type = "density")

  spark_gt_html <- gt_sparkline_tab %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  hist_gt_html <- gt_spark_hist %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  dens_gt_html <- gt_spark_dens %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  # SVG Exists and is of length 3 ----

  spark_len <- spark_gt_html %>%
    rvest::html_nodes("svg") %>%
    length()

  hist_len <- hist_gt_html %>%
    rvest::html_nodes("svg") %>%
    length()

  dens_len <- dens_gt_html %>%
    rvest::html_nodes("svg") %>%
    length()

  expect_equal(spark_len, 3)
  expect_equal(hist_len, 3)
  expect_equal(dens_len, 3)


  # SVG has specific points ----

  spark_vals <- spark_gt_html %>%
    rvest::html_node("polyline") %>%
    rvest::html_attr("points") %>%
    substr(1, 34)

  hist_attrs <- hist_gt_html %>%
    rvest::html_nodes("svg > g > rect:nth-child(1)") %>%
    rvest::html_attrs()

  hist_vals <- hist_attrs %>%
    lapply(function(xy) xy[['x']]) %>%
    unlist()

  dens_vals <- dens_gt_html %>%
    rvest::html_node("svg > g > polyline") %>%
    rvest::html_attr("points") %>%
    substr(1, 34)

  expect_equal(spark_vals, "8.16,6.80 13.89,6.08 19.61,6.80 25")
  expect_equal(hist_vals, c("39.43", "27.88", "4.79"))
  expect_equal(dens_vals,"26.03,13.47 26.14,13.46 26.25,13.4")

  })


test_that("svg is created and has specific values, same_limit = FALSE", {
  check_suggests()

  # basic sparkline
  gt_sparkline_tab <- mtcars %>%
    dplyr::group_by(cyl) %>%
    # must end up with list of data for each row in the input dataframe
    dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
    gt() %>%
    gt_sparkline(mpg_data, same_limit = FALSE)

  gt_spark_hist <- mtcars %>%
    dplyr::group_by(cyl) %>%
    # must end up with list of data for each row in the input dataframe
    dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
    gt::gt() %>%
    gt_sparkline(mpg_data, type = "histogram", same_limit = FALSE)

  gt_spark_dens <- mtcars %>%
    dplyr::group_by(cyl) %>%
    # must end up with list of data for each row in the input dataframe
    dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
    gt::gt() %>%
    gt_sparkline(mpg_data, type = "density", same_limit = FALSE)

  spark_gt_html <- gt_sparkline_tab %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  hist_gt_html <- gt_spark_hist %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  dens_gt_html <- gt_spark_dens %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  # SVG Exists and is of length 3 ----

  spark_len <- spark_gt_html %>%
    rvest::html_nodes("svg") %>%
    length()

  hist_len <- hist_gt_html %>%
    rvest::html_nodes("svg") %>%
    length()

  dens_len <- dens_gt_html %>%
    rvest::html_nodes("svg") %>%
    length()

  expect_equal(spark_len, 3)
  expect_equal(hist_len, 3)
  expect_equal(dens_len, 3)


  # SVG has specific points ----

  spark_vals <- spark_gt_html %>%
    rvest::html_node("polyline") %>%
    rvest::html_attr("points") %>%
    substr(1, 34)

  hist_attrs <- hist_gt_html %>%
    rvest::html_nodes("svg > g > rect:nth-child(1)") %>%
    rvest::html_attrs()

  hist_vals <- hist_attrs %>%
    lapply(function(xy) xy[['x']]) %>%
    unlist()

  dens_vals <- dens_gt_html %>%
    rvest::html_node("svg > g > polyline") %>%
    rvest::html_attr("points") %>%
    substr(1, 34)

  expect_equal(spark_vals, "8.16,11.32 13.89,9.93 19.61,11.32 ")
  expect_equal(hist_vals, c("-20.30","-32.43","1.79" ))
  expect_equal(dens_vals,"25.91,13.47 26.02,13.46 26.13,13.4")

})

test_that("svg is created and has specific values, trim = TRUE and bw = 2.5", {
  check_suggests()

  # basic sparkline
  gt_sparkline_tab <- mtcars %>%
    dplyr::group_by(cyl) %>%
    # must end up with list of data for each row in the input dataframe
    dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
    gt() %>%
    gt_sparkline(mpg_data, same_limit = FALSE)

  gt_spark_hist <- mtcars %>%
    dplyr::group_by(cyl) %>%
    # must end up with list of data for each row in the input dataframe
    dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
    gt::gt() %>%
    gt_sparkline(mpg_data, type = "histogram", trim = TRUE, bw = 2.5)

  gt_spark_dens <- mtcars %>%
    dplyr::group_by(cyl) %>%
    # must end up with list of data for each row in the input dataframe
    dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
    gt::gt() %>%
    gt_sparkline(mpg_data, type = "density", trim = TRUE, bw = 2.5)

  spark_gt_html <- gt_sparkline_tab %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  hist_gt_html <- gt_spark_hist %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  dens_gt_html <- gt_spark_dens %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  # SVG Exists and is of length 3 ----

  spark_len <- spark_gt_html %>%
    rvest::html_nodes("svg") %>%
    length()

  hist_len <- hist_gt_html %>%
    rvest::html_nodes("svg") %>%
    length()

  dens_len <- dens_gt_html %>%
    rvest::html_nodes("svg") %>%
    length()

  expect_equal(spark_len, 3)
  expect_equal(hist_len, 3)
  expect_equal(dens_len, 3)


  # SVG has specific points ----

  spark_vals <- spark_gt_html %>%
    rvest::html_node("polyline") %>%
    rvest::html_attr("points") %>%
    substr(1, 34)

  hist_attrs <- hist_gt_html %>%
    rvest::html_nodes("svg > g > rect:nth-child(1)") %>%
    rvest::html_attrs()

  hist_vals <- hist_attrs %>%
    lapply(function(xy) xy[['x']]) %>%
    unlist()

  dens_vals <- dens_gt_html %>%
    rvest::html_node("svg > g > polyline") %>%
    rvest::html_attr("points") %>%
    substr(1, 34)

  expect_equal(spark_vals, "8.16,11.32 13.89,9.93 19.61,11.32 ")
  expect_equal(hist_vals, c("40.28","27.86","9.22"))
  expect_equal(dens_vals,"39.79,4.03 39.89,3.90 40.00,3.77 4")

})


test_that("label is created or not created", {
  check_suggests()

  # basic sparkline
  spark_label <- mtcars %>%
    dplyr::group_by(cyl) %>%
    # must end up with list of data for each row in the input dataframe
    dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
    gt() %>%
    gt_sparkline(mpg_data, same_limit = FALSE, label = TRUE)

  spark_no_lab <- mtcars %>%
    dplyr::group_by(cyl) %>%
    # must end up with list of data for each row in the input dataframe
    dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
    gt() %>%
    gt_sparkline(mpg_data, same_limit = FALSE, label = FALSE)

  spark_lab_html <- spark_label %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  spark_nolab_html <- spark_no_lab %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  # SVG text has specific values ----

  spark_txt <- spark_lab_html %>%
    rvest::html_nodes("svg > g > text") %>%
    rvest::html_text()

  spark_no_txt <- spark_nolab_html %>%
    rvest::html_nodes("svg > g > text") %>%
    rvest::html_text()

  expect_equal(spark_txt, c("21.4","19.7","15.0"))
  expect_equal(spark_no_txt, character(0))

})
