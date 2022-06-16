test_that("svg is created", {
  check_suggests()

  base_tab <- mtcars %>%
    dplyr::group_by(cyl) %>%
    # must end up with list of data for each row in the input dataframe
    dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
    gt()

  get_svg_len <- function(table){
    table %>%
      gt::as_raw_html() %>%
      rvest::read_html() %>%
      rvest::html_nodes("svg") %>%
      length()
  }

  # basic dens
  gt_dens <-  base_tab %>%
    gt_plt_dist(mpg_data)

  # bw dens
  gt_dens_bw <- base_tab %>%
    gt_plt_dist(mpg_data, bw = 3)

  # same_limit dens
  gt_dens_lim <- base_tab %>%
    gt_plt_dist(mpg_data, bw = 3, same_limit = FALSE)

  gt_dens_trim <- base_tab %>%
    gt_plt_dist(mpg_data, bw = 3, same_limit = FALSE)

  # basic hist
  gt_hist <- base_tab %>%
    gt_plt_dist(mpg_data, type = "histogram")

  gt_hist_bw <- base_tab %>%
    gt_plt_dist(mpg_data, type = "histogram", bw = 2)

  gt_hist_lim <- base_tab %>%
    gt_plt_dist(mpg_data, type = "histogram", bw = 2, same_limit = FALSE)

  gt_rug <- base_tab %>%
    gt_plt_dist(mpg_data, type = "rug_strip")

  gt_box <- base_tab %>%
    gt_plt_dist(mpg_data, type = "boxplot")

  expect_equal(get_svg_len(gt_dens), 3)
  expect_equal(get_svg_len(gt_dens_bw), 3)
  expect_equal(get_svg_len(gt_dens_lim), 3)
  expect_equal(get_svg_len(gt_dens_trim), 3)
  expect_equal(get_svg_len(gt_box), 3)
  expect_equal(get_svg_len(gt_hist), 3)
  expect_equal(get_svg_len(gt_hist_bw), 3)
  expect_equal(get_svg_len(gt_hist_lim), 3)
  expect_equal(get_svg_len(gt_rug), 3)

})
