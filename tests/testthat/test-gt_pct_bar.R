# test_that("gt_pct_bar SVG is created and has specific values", {
#   check_suggests()

#   ex_df <- dplyr::tibble(
#     x = c("Example 1","Example 1",
#           "Example 1","Example 2","Example 2","Example 2",
#           "Example 3","Example 3","Example 3","Example 4","Example 4",
#           "Example 4"),
#     measure = c("Measure 1","Measure 2",
#                 "Measure 3","Measure 1","Measure 2","Measure 3",
#                 "Measure 1","Measure 2","Measure 3","Measure 1","Measure 2",
#                 "Measure 3"),
#     data = c(30, 20, 50, 30, 30, 40, 30, 40, 30, 30, 50, 20)
#   )

#   tab_df <- ex_df %>%
#     dplyr::group_by(x) %>%
#     dplyr::summarise(list_data = list(data))

#   ex_tab <- tab_df %>%
#     gt::gt() %>%
#     gt_plt_bar_stack(column = list_data) %>%
#     gt::as_raw_html() %>%
#     rvest::read_html()

#   bar_vals <- ex_tab %>%
#     rvest::html_nodes("svg > g > rect") %>%
#     rvest::html_attr("x") %>%
#     as.double()

#   bar_colors <- ex_tab %>%
#     rvest::html_nodes("svg > g > rect") %>%
#     rvest::html_attr("style") %>%
#     gsub(x = ., pattern = ".*fill: #", "")

#   expect_equal(bar_vals, c(0, 59.53, 99.21, 0, 59.53, 119.06,
#                            0, 59.53, 138.9, 0, 59.53, 158.74))
#   expect_equal(
#     bar_colors,
#     c("FF4343;", "BFBFBF;", "0A1C2B;", "FF4343;", "BFBFBF;", "0A1C2B;",
#     "FF4343;", "BFBFBF;", "0A1C2B;", "FF4343;", "BFBFBF;", "0A1C2B;")
#     )

# })

test_that("gt_pct_bar SVG is created and has specific palette", {
  check_suggests()

  ex_df <- dplyr::tibble(
    x = c(
      "Example 1",
      "Example 1",
      "Example 2",
      "Example 2",
      "Example 3",
      "Example 3",
      "Example 4",
      "Example 4"
    ),
    measure = c(
      "Measure 1",
      "Measure 2",
      "Measure 1",
      "Measure 2",
      "Measure 1",
      "Measure 2",
      "Measure 1",
      "Measure 2"
    ),
    data = c(30, 20, 50, 30, 30, 40, 30, 40)
  )

  tab_df <- ex_df %>%
    dplyr::group_by(x) %>%
    dplyr::summarise(list_data = list(data))

  ex_tab <- tab_df %>%
    gt::gt() %>%
    gt_plt_bar_stack(column = list_data, labels = c("Lab 1", "Lab 2")) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  bar_vals <- ex_tab %>%
    rvest::html_nodes("svg > g > g > rect") %>%
    rvest::html_attr("x") %>%
    as.double()

  bar_colors <- ex_tab %>%
    rvest::html_nodes("svg > g > g > rect") %>%
    rvest::html_attr("style") %>%
    gsub(x = ., pattern = ".*fill: #", "")

  expect_equal(
    round(bar_vals, 2),
    c(0.00, 119.06, 0.00, 124.02, 0.00, 85.04, 0.00, 85.04)
  )
  expect_equal(
    bar_colors,
    c(
      "FF4343;",
      "BFBFBF;",
      "FF4343;",
      "BFBFBF;",
      "FF4343;",
      "BFBFBF;",
      "FF4343;",
      "BFBFBF;"
    )
  )
})
