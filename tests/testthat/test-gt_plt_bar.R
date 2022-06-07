test_that("gt_plt_bar svg is created and has specific values", {
  check_suggests()

  bar_tbl <- mtcars %>%
    head() %>%
    gt::gt() %>%
    gt_plt_bar(column = mpg, keep_column = TRUE) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  bar_tbl_neg <- dplyr::tibble(
    x = LETTERS[1:6],
    vals = c(6, 4, 2, -2, -4, -6)
  ) %>%
    gt::gt() %>%
    gt_plt_bar(vals, scale_type = "number") %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  # SVG exists and is of length ----

  bar_len <- bar_tbl %>%
    rvest::html_nodes("svg") %>%
    length()

  bar_neg_len <- bar_tbl_neg %>%
    rvest::html_nodes("svg") %>%
    length()

  expect_equal(bar_len, 6)
  expect_equal(bar_neg_len, 6)

  # SVG has specific points ----

  bar_vals <- bar_tbl %>%
    rvest::html_nodes("svg > g > rect") %>%
    rvest::html_attr("width")

  bar_neg_vals <- bar_tbl_neg %>%
    rvest::html_nodes("svg > g > rect") %>%
    rvest::html_attr("width")

  expect_equal(bar_vals, c("158.56","158.56","172.15","161.58","141.20","136.67"))
  expect_equal(bar_neg_vals, c("86.08","57.38","28.69","28.69","57.38","86.08"))

})


