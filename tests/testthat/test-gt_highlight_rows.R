my_car <- head(mtcars[,1:5]) %>%
  tibble::rownames_to_column("car")

basic_use <- gt::gt(my_car) %>%
  gt_highlight_rows(rows = 2, font_weight = "normal")


target_bold_column <- gt::gt(my_car) %>%
  gt_highlight_rows(
    rows = 5,
    fill = "lightgrey",
    bold_target_only = TRUE,
    target_col = car
  )

tidyeval_tab <- gt::gt(my_car) %>%
  gt_highlight_rows(rows = grepl(x = car, pattern = "4 Drive|Valiant"))

test_that("gt_highlight_row correct row is highlighted and is blue", {
  check_suggests()

  base_html <- basic_use %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  high_row <- base_html %>%
    rvest::html_nodes("tr:nth-child(2) > td") %>%
    rvest::html_attr("style") %>%
    gsub(x = ., pattern = ".*background-color: ", "") %>%
    substr(6, 20)

  high_colors <- sapply(strsplit(high_row, ","), function(x)
    rgb(x[1], x[2], x[3], maxColorValue=255))

  first_row <- base_html %>%
    rvest::html_nodes("tr:nth-child(1) > td") %>%
    rvest::html_attr("style") %>%
    grepl(x = ., pattern = "background-color")

  row2 <- base_html %>%
    rvest::html_nodes("tr:nth-child(2) > td") %>%
    rvest::html_attr("style") %>%
    grepl(x = ., pattern = "background-color")

  testthat::expect_true(all(first_row == FALSE))
  testthat::expect_false(all(row2 == FALSE))
  testthat::expect_true(all(high_colors == "#80BCD8"))

  })

test_that("gt_highlight_row target is bold", {
  check_suggests()

  target_html <- target_bold_column %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  bold_rows <- target_html %>%
    rvest::html_nodes("td:nth-child(1)") %>%
    rvest::html_attr("style") %>%
    grepl(x = ., pattern = "font-weight: bold")

  testthat::expect_true(all(bold_rows[c(1:4,6)] == FALSE))
  testthat::expect_true(isTRUE(bold_rows[5]))

})

test_that("gt_highlight_row tidyeval works", {
  check_suggests()

  tidyeval_html <- tidyeval_tab %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  color_rows <- tidyeval_html %>%
    rvest::html_nodes("td:nth-child(1)") %>%
    rvest::html_attr("style") %>%
    grepl(x = ., pattern = "background-color: rgba\\(128,188,216,0.8\\)")

  testthat::expect_true(all(color_rows[c(1:3,5)] == FALSE))
  testthat::expect_true(all(color_rows[c(4,6)] == TRUE))

})

