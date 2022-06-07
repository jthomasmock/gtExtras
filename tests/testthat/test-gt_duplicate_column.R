test_that("duplicate column, confirm column exists and matches", {
  check_suggests()

  dupe_table <- head(mtcars) %>%
    dplyr::select(mpg, disp) %>%
    gt::gt() %>%
    gt_duplicate_column(mpg, after = disp, append_text = "2") %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  dupe_title <- rvest::html_node(dupe_table, "th:nth-child(3)") %>%
    rvest::html_text()

  dupe_vals <- rvest::html_nodes(dupe_table, "td:nth-child(3)") %>%
    rvest::html_text() %>%
    as.double()

  expect_equal(dupe_title, "mpg2")
  expect_equal(dupe_vals, mtcars$mpg[1:6])

})

test_that("duplicate column, check dupe_name", {
  check_suggests()

  dupe_table <- head(mtcars) %>%
    dplyr::select(mpg, disp) %>%
    gt::gt() %>%
    gt_duplicate_column(disp, after = mpg, dupe_name = "my_column") %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  dupe_title <- rvest::html_node(dupe_table, "th:nth-child(2)") %>%
    rvest::html_text()

  dupe_vals <- rvest::html_nodes(dupe_table, "td:nth-child(2)") %>%
    rvest::html_text() %>%
    as.double()

  expect_equal(dupe_title, "my_column")
  expect_equal(dupe_vals, mtcars$disp[1:6])

})
