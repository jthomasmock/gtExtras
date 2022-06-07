test_that("svg is created", {
  check_suggests()

  # basic dens
  gt_dens <- mtcars %>%
    dplyr::group_by(cyl) %>%
    # must end up with list of data for each row in the input dataframe
    dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
    gt() %>%
    gt_plt_dist(mpg_data)

  gt_hist <- mtcars %>%
    dplyr::group_by(cyl) %>%
    # must end up with list of data for each row in the input dataframe
    dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
    gt::gt() %>%
    gt_plt_dist(mpg_data, type = "histogram", bw = 2)

  gt_rug <- mtcars %>%
    dplyr::group_by(cyl) %>%
    # must end up with list of data for each row in the input dataframe
    dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
    gt::gt() %>%
    gt_plt_dist(mpg_data, type = "rug_strip")

  dens_gt_html <- gt_dens %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  hist_gt_html <- gt_hist %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  rug_gt_html <- gt_rug %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  # SVG Exists and is of length 3 ----

  dens_len <- dens_gt_html %>%
    rvest::html_nodes("svg") %>%
    length()

  hist_len <- hist_gt_html %>%
    rvest::html_nodes("svg") %>%
    length()

  rug_len <- rug_gt_html %>%
    rvest::html_nodes("svg") %>%
    length()

  expect_equal(dens_len, 3)
  expect_equal(hist_len, 3)
  expect_equal(rug_len, 3)
})
