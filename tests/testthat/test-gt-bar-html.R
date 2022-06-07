test_that("gt_plt_bar_pct HTML is created and has specific values", {
  check_suggests()


  gt_bar_plot_tab <- mtcars %>%
    head() %>%
    dplyr::select(cyl, mpg) %>%
    dplyr::mutate(
      mpg_pct_max = round(mpg / max(mpg) * 100, digits = 2),
      mpg_scaled = mpg / max(mpg) * 100
    ) %>%
    dplyr::mutate(mpg_unscaled = mpg) %>%
    gt::gt() %>%
    gt_plt_bar_pct(column = mpg_scaled, scaled = TRUE) %>%
    gt_plt_bar_pct(
      column = mpg_unscaled,
      scaled = FALSE,
      fill = "blue",
      background = "lightblue"
    ) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  #jotyuenmde > table > tbody > tr:nth-child(1) > td:nth-child(4) > div > div

  scaled_vals <- gt_bar_plot_tab %>%
    rvest::html_nodes("td:nth-child(4) > div > div") %>%
    rvest::html_attr("style") %>%
    gsub(x = ., pattern = ".*width:", replacement = "") %>%
    substr(1, 4)

  unscaled_vals <- gt_bar_plot_tab %>%
    rvest::html_nodes("td:nth-child(5) > div > div") %>%
    rvest::html_attr("style") %>%
    gsub(x = ., pattern = ".*width:", replacement = "") %>%
    substr(1, 4)

  expect_equal(scaled_vals, c("92.1", "92.1", "100%", "93.8", "82.0", "79.3"))
  expect_equal(unscaled_vals, c("92.1", "92.1", "100%", "93.8", "82.0", "79.3"))

})
