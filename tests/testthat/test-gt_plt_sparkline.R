test_that("svg is created and has specific values", {
  check_suggests()

  basic_gt <- mtcars %>%
    dplyr::group_by(cyl) %>%
    # must end up with list of data for each row in the input dataframe
    dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
    gt()

  # basic sparkline
  gt_sparkline_tab <- basic_gt %>%
    gt_plt_sparkline(mpg_data)

  gt_ref_median <- basic_gt %>%
    gt_plt_sparkline(mpg_data, type = "ref_median")

  gt_shaded <- basic_gt %>%
    gt_plt_sparkline(mpg_data, type = "shaded")

  gt_mean <- basic_gt %>%
    gt_plt_sparkline(mpg_data, type = "ref_mean")

  gt_points <- basic_gt %>%
    gt_plt_sparkline(mpg_data, type = "points")

  gt_last <- basic_gt %>%
    gt_plt_sparkline(mpg_data, type = "ref_last")

  gt_iqr <- basic_gt %>%
    gt_plt_sparkline(mpg_data, type = "ref_iqr")

  get_html <- function(table) {
    table %>%
      gt::as_raw_html() %>%
      rvest::read_html()
  }

  basic_html <- get_html(gt_sparkline_tab)
  median_html <- get_html(gt_ref_median)
  mean_html <- get_html(gt_mean)
  points_html <- get_html(gt_points)
  last_html <- get_html(gt_last)
  iqr_html <- get_html(gt_iqr)

  # SVG Exists and is of length 3 ----

  get_length <- function(html) {
    html %>%
      rvest::html_nodes("svg") %>%
      length()
  }

  all_lengths <- sapply(
    list(basic_html, median_html, mean_html, points_html, last_html, iqr_html),
    get_length
  )

  expect_equal(all_lengths, rep(3, 6))

  # SVG has specific points ----

  spark_vals <- basic_html %>%
    rvest::html_node("polyline") %>%
    rvest::html_attr("points") %>%
    substr(1, 34)

  expect_equal(spark_vals, "8.16,6.80 13.89,6.08 19.61,6.80 25")
})

test_that("font size can be changed", {
  check_suggests()
  
  basic_gt <- mtcars %>%
    dplyr::group_by(cyl) %>%
    # must end up with list of data for each row in the input dataframe
    dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
    gt()
  
  # basic sparkline
  gt_small_font <- basic_gt %>%
    gt_plt_sparkline(mpg_data, label = TRUE)
  gt_big_font <- basic_gt %>%
    gt_plt_sparkline(mpg_data, label = TRUE, font_size = 10)
  
  get_html <- function(table) {
    table %>%
      gt::as_raw_html() %>%
      rvest::read_html()
  }
  
  small_font_html <- get_html(gt_small_font)
  big_font_html <- get_html(gt_big_font)
  
  # SVG Exists and is of length 3 ----
  
  get_length <- function(html) {
    html %>%
      rvest::html_nodes("svg") %>%
      length()
  }
  
  expect_equal(get_length(small_font_html), get_length(big_font_html))
  
  # SVG has specific points ----
  
  small_font_spark_vals <- small_font_html %>%
    rvest::html_node("polyline") %>%
    rvest::html_attr("points") %>%
    substr(1, 34)
  
  big_font_spark_vals <- big_font_html %>%
    rvest::html_node("polyline") %>%
    rvest::html_attr("points") %>%
    substr(1, 34)
  
  expect_equal(small_font_spark_vals, big_font_spark_vals)
  
  # SVG has specific font size ----
  
  small_font_size <- small_font_html %>%
    rvest::html_node("text") %>%
    rvest::html_attr("style") %>%
    stringr::str_extract("font-size: [0-9.]+px;")
  
  expect_equal(small_font_size, "font-size: 5.69px;")
  
  big_font_size <- big_font_html %>%
    rvest::html_node("text") %>%
    rvest::html_attr("style") %>%
    stringr::str_extract("font-size: [0-9.]+px;")
  
  expect_equal(big_font_size, "font-size: 14.23px;")
})
