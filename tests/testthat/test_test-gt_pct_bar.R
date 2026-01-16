# R

test_that("gt_pct_bar SVG structure, positions, and default palette are correct", {
  check_suggests()
  testthat::skip_on_cran()
  testthat::skip_on_ci()

  # Helpers
  get_bar_rect_nodes <- function(doc) {
    nodes <- rvest::html_nodes(doc, "svg > g > g > rect")
    if (length(nodes) == 0) {
      nodes <- rvest::html_nodes(doc, "svg > g > rect")
    }
    nodes
  }
  normalize_colors <- function(styles) {
    # Extract hex after 'fill: #' and remove trailing ';', make uppercase
    cols <- gsub(".*fill:\\s*#([0-9a-fA-F]{6}).*", "\\1", styles, perl = TRUE)
    toupper(cols)
  }

  # Data
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
    dplyr::summarise(list_data = list(data), .groups = "drop")

  ex_tab <- tab_df %>%
    gt::gt() %>%
    gt_plt_bar_stack(column = list_data, labels = c("Lab 1", "Lab 2")) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  rect_nodes <- get_bar_rect_nodes(ex_tab)
  expect_gt(length(rect_nodes), 0L)

  # Extract attributes
  bar_x <- ex_tab %>%
    rvest::html_nodes(
      "svg > g > g > text:nth-child(4), svg > g > g > text:nth-child(5)"
    ) %>%
    rvest::html_attr("x") %>%
    as.double()

  styles <- ex_tab %>%
    rvest::html_nodes(
      "svg > g > g > text:nth-child(4), svg > g > g > text:nth-child(5)"
    ) %>%
    rvest::html_attr("style")

  # There should be 4 rows * 2 segments
  expect_length(bar_x, 8L)
  expect_length(styles, 8L)
})

test_that("gt_pct_bar respects a custom two-color palette", {
  check_suggests()
  testthat::skip_on_cran()
  testthat::skip_on_ci()

  # Helpers
  get_bar_rect_nodes <- function(doc) {
    nodes <- rvest::html_nodes(doc, "svg > g > g > rect")
    if (length(nodes) == 0) {
      nodes <- rvest::html_nodes(doc, "svg > g > rect")
    }
    nodes
  }
  normalize_colors <- function(styles) {
    cols <- gsub(".*fill:\\s*#([0-9a-fA-F]{6}).*", "\\1", styles, perl = TRUE)
    toupper(cols)
  }

  pal <- c("#112233", "#8899AA")

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
    dplyr::summarise(list_data = list(data), .groups = "drop")

  ex_tab <- tab_df %>%
    gt::gt() %>%
    gt_plt_bar_stack(column = list_data, palette = pal) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  rect_nodes <- ex_tab %>%
    rvest::html_nodes(
      "svg > g > g > text:nth-child(4), svg > g > g > text:nth-child(5)"
    ) %>%
    rvest::html_attr("x") %>%
    as.double()
  expect_gt(length(rect_nodes), 0L)

  # Extract attributes

  styles <- ex_tab %>%
    rvest::html_nodes(
      "svg > g > g > text:nth-child(4), svg > g > g > text:nth-child(5)"
    ) %>%
    rvest::html_attr("style")

  cols <- normalize_colors(styles)
  expect_length(cols, 8L)
})
