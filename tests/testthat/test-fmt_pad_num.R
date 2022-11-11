test_that("gt_fmt_pad_num test that padding is correct", {
  check_suggests()
  skip_on_cran()

  padded_tab <- data.frame(numbers = c(1.2345, 12.345, 123.45, 1234.5, 12345)) %>%
    gt() %>%
    fmt_pad_num(columns = numbers, nsmall = 4)

  pad_html <- padded_tab %>%
    gt::as_raw_html() %>%
    rvest::read_html() %>%
    rvest::html_nodes("td:nth-child(1)") %>%
    rvest::html_text()

  pad_html <- gsub(x = pad_html, pattern = "^.*\\.", replacement = "")

  len_space <- stringr::str_count(pad_html, "\\s")

  expect_equal(len_space, rep(2, 5))

})



