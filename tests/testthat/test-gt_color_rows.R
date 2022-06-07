test_that("gt_color_rows palettes are created and have appropriate hex values", {
  check_suggests()

  base_red <-  mtcars %>%
    head() %>%
    gt::gt() %>%
    gt_color_rows(mpg, domain = range(mtcars$mpg)) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  base_red_colors <- base_red %>%
    rvest::html_nodes("td:nth-child(1)") %>%
    rvest::html_attr("style") %>%
    sub(".*background-color: #", "", .) %>%
    substr(., 1, 6)

  blue_pal <- head(mtcars) %>%
    gt::gt() %>%
    gt_color_rows(mpg, palette = "ggsci::blue_material", domain = range(mtcars$mpg)) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  blue_colors <- blue_pal %>%
    rvest::html_nodes("td:nth-child(1)") %>%
    rvest::html_attr("style") %>%
    sub(".*background-color: #", "", .) %>%
    substr(., 1, 6)

  vector_pal <- head(mtcars) %>%
    gt::gt() %>%
    gt_color_rows(
      mpg, palette = c("#ffffff", "#00FF00"),
      domain = range(mtcars$mpg[1:6])) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  vector_colors <- vector_pal %>%
    rvest::html_nodes("td:nth-child(1)") %>%
    rvest::html_attr("style") %>%
    sub(".*background-color: #", "", .) %>%
    substr(., 1, 6)

  discrete_pal <- head(mtcars) %>%
    gt::gt() %>%
    gt_color_rows(
      cyl, pal_type = "discrete",
      palette = "ggthemes::colorblind", domain = range(mtcars$cyl)
    ) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  discrete_colors <- discrete_pal %>%
    rvest::html_nodes("td:nth-child(2)") %>%
    rvest::html_attr("style") %>%
    sub(".*background-color: #", "", .) %>%
    substr(., 1, 6)

  expect_equal(base_red_colors, c("EF524E","EF524E","F3473D","F0504B","E76E6D","E67575"))
  expect_equal(blue_colors, c("41A4F5","41A4F5","2C9AF4","3DA2F5","5FB2F6","67B6F6"))
  expect_equal(vector_colors, c("9BFF82","9BFF82","00FF00","88FF6F","EDFFE6","FFFFFF"))
  expect_equal(discrete_colors, c("98C160","98C160","000000","98C160","CC79A7","98C160"))

  expect_error(gt(head(mtcars)) %>%
    gt_color_rows(
      cyl, palette = "ggthemes::FAKENAME", domain = range(mtcars$cyl)
      )
    )

})
