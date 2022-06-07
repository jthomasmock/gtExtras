test_that("gt_plt_bullet SVG is created and has specific values", {
  check_suggests()

  dot_bar_tab <- mtcars %>%
    head() %>%
    dplyr::mutate(cars = sapply(strsplit(rownames(.), " "), `[`, 1)) %>%
    dplyr::select(cars, mpg, disp) %>%
    gt::gt() %>%
    gt_plt_dot(disp, cars, palette = "ggthemes::fivethirtyeight") %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  dot_vals <- dot_bar_tab %>%
    rvest::html_nodes("div:nth-child(2) > div > div > div") %>%
    rvest::html_attr("style") %>%
    gsub(x = ., pattern = ".*width:", "") %>%
    substr(1, 4)

  dot_colors <- dot_bar_tab %>%
    rvest::html_nodes("div:nth-child(2) > div > div > div") %>%
    rvest::html_attr("style") %>%
    gsub(x = ., pattern = ".*background:", "") %>%
    substr(1, 7)

  expect_equal(dot_vals, c("44.4", "44.4", "30%;", "71.6", "100%", "62.5"))
  expect_equal(dot_colors, c("#3C3C3C", "#3C3C3C", "#E6E6E6", "#DA5D53", "#DA5D53", "#77AB43"))
  })
