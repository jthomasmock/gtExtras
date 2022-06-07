test_gt_by_col <- function(col_n, row_first = TRUE, expectation) {
  check_suggests()
  skip_on_cran()

  ex_gt <- gt::gtcars %>%
    head() %>%
    dplyr::select(mfr, year, bdy_style, mpg_h, hp) %>%
    dplyr::mutate(mpg_h = c(20.2, 22.0, 20.8, 21.2, 22.8, 22.7)) %>%
    gt::gt() %>%
    gt::opt_table_font(font = google_font("Roboto Mono")) %>%
    gt::opt_table_lines() %>%
    fmt_symbol_first(column = mfr, symbol = "&#x24;", suffix = " ", last_row_n = 6) %>%
    fmt_symbol_first(column = year, symbol = NULL, suffix = "%", last_row_n = 6) %>%
    fmt_symbol_first(column = mpg_h, symbol = "&#37;", suffix = NULL, last_row_n = 6, decimals = 1) %>%
    fmt_symbol_first(column = hp, symbol = "&#176;", suffix = "F", last_row_n = 6, decimals = NULL, symbol_first = TRUE)

  ex_gt_raw <- ex_gt %>%
    gt::as_raw_html()

  # read into rvest, and grab the table body
  ex_html_tab <- rvest::read_html(ex_gt_raw) %>%
    rvest::html_node("table > tbody")

  # if row_first = TRUE, then just get the 1st row
  # otherwise select the remainder
  if(isTRUE(row_first)){
    row_sel <- 1
  } else {
    row_sel <- 2:6
  }

  # use our example html
  # grab the column by number
  # get the rows by selection
  # test the expectation
  ex_html_tab %>%
    rvest::html_nodes(paste0("td:nth-child(",col_n , ")")) %>%
    rvest::html_text() %>%
    .[row_sel] %>%
    testthat::expect_match(expectation)
}

test_that("fmt_symbol_first works with escaped characters", {
  test_gt_by_col(1, expectation = "Ford \\$")
  test_gt_by_col(1, row_first = FALSE, expectation = "Ferrari&nbsp&nbsp")
})

testthat::test_that("fmt_symbol_first, Raw percent character works", {
  test_gt_by_col(2, expectation = "2017%")
  test_gt_by_col(2, row_first = FALSE, expectation = "201[4-7]&nbsp")
})

testthat::test_that("fmt_symbol_first, HTML symbol for percent works", {
  test_gt_by_col(4, expectation = "20.2%")
  test_gt_by_col(4, row_first = FALSE, expectation = "[0-9]+&nbsp")
})

testthat::test_that("fmt_symbol_first, A combined suffix + symbol work", {
  test_gt_by_col(5, expectation = "647°F")
  test_gt_by_col(5, row_first = FALSE, expectation = "[0-9]+&nbsp&nbsp")
})
