# Function to skip tests if Suggested packages not available on system
check_suggests <- function() {
  skip_if_not_installed("rvest")
  skip_if_not_installed("xml2")
}

test_that("SVG exists and has expected values", {
  check_suggests()

  set.seed(37)
  data_in <- dplyr::tibble(
    grp = rep(c("A", "B", "C"), each = 10),
    wins = sample(c(0,1,.5), size = 30, prob = c(0.45, 0.45, 0.1), replace = TRUE)
  ) %>%
    dplyr::group_by(grp) %>%
    dplyr::summarize(wins=list(wins), .groups = "drop")

  pill_table <- data_in %>%
    gt::gt() %>%
    gt_plt_winloss(wins) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  box_table <- data_in %>%
    gt::gt() %>%
    gt_plt_winloss(wins, type = "square") %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  # SVG Exists and is of length 3 ----

  pill_len <- pill_table %>%
    rvest::html_nodes("svg") %>%
    length()

  square_len <- box_table %>%
    rvest::html_nodes("svg") %>%
    length()

  expect_equal(pill_len, 3)
  expect_equal(square_len, 3)


  # SVG has specific points ----

  pill_vals <- pill_table %>%
    rvest::html_nodes("tr:nth-child(2) > td") %>%
    rvest::html_nodes("svg > g > line") %>%
    rvest::html_attrs() %>%
    lapply(function(xy) xy[['y1']]) %>%
    unlist()

  square_vals <- box_table %>%
    rvest::html_nodes("tr:nth-child(2) > td") %>%
    rvest::html_nodes("svg > g > polygon") %>%
    rvest::html_attr("points") %>%
    substr(1, 4)

  expect_equal(pill_vals, c("1.89","8.91","1.89","1.89","6.10",
                            "8.91","8.91","1.89","8.91","8.91"))
  expect_equal(square_vals, c("3.26","6.72","10.1","13.6","17.1",
                              "20.5","24.0","27.5","30.9","34.4"))

})
