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
    rvest::html_nodes("svg > g > g > rect") %>%
    rvest::html_attr("width")

  bar_neg_vals <- bar_tbl_neg %>%
    rvest::html_nodes("svg > g > g > rect") %>%
    rvest::html_attr("width")

  expect_equal(
    bar_vals,
    c("90.61", "90.61", "98.37", "92.33", "80.68", "78.10")
  )
  expect_equal(
    bar_neg_vals,
    c("49.19", "32.79", "16.40", "16.40", "32.79", "49.19")
  )
})
