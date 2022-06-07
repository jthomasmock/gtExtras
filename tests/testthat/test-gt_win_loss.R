test_that("SVG exists and has expected values", {
  check_suggests()

  data_in <- dplyr::tibble(
    grp = rep(c("A", "B", "C"), each = 10),
    wins = c(0.5,0.5,0,0,1,1,1,0,0,1,0,0,1,0,1,
             1,1,0,0.5,0,0,1,0,0,0,1,0,0,1,0)
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

  expect_equal(pill_vals, c("8.91","8.91","1.89","8.91","1.89",
                            "1.89","1.89","8.91","6.10","8.91"))
  expect_equal(square_vals, c("3.26","6.72","10.1","13.6","17.1",
                              "20.5","24.0","27.5","30.9","34.4"))

})

test_that("SVG exists and has expected colors", {
  check_suggests()

  data_in <- dplyr::tibble(
    grp = rep(c("A", "B", "C"), each = 10),
    wins = c(0.5,0.5,0,0,1,1,1,0,0,1,0,0,1,0,1,
             1,1,0,0.5,0,0,1,0,0,0,1,0,0,1,0)
  ) %>%
    dplyr::group_by(grp) %>%
    dplyr::summarize(wins=list(wins), .groups = "drop")

  pill_table <- data_in %>%
    gt::gt() %>%
    gt_plt_winloss(wins, palette = c("green", "purple", "black")) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  box_table <- data_in %>%
    gt::gt() %>%
    gt_plt_winloss(wins, type = "square",
                   palette = c("green", "purple", "black")) %>%
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

  pill_colors <- pill_table %>%
    rvest::html_nodes("svg > g > line") %>%
    rvest::html_attr("style") %>%
    lapply(., function(x){
      strsplit(x, split = "stroke: #", fixed = TRUE)[[1]][2]
    }) %>% unlist()


  box_colors <- box_table %>%
    rvest::html_nodes("svg > g > polygon") %>%
    rvest::html_attr("style") %>%
    lapply(., function(x){
      strsplit(x, split = "fill: #", fixed = TRUE)[[1]][2]
    }) %>% unlist()

  exp_pill_colors <- c(
    NA, NA, "A020F0;", "A020F0;", "00FF00;", "00FF00;", "00FF00;", "A020F0;",
    "A020F0;", "00FF00;", "A020F0;", "A020F0;", "00FF00;", "A020F0;", "00FF00;",
    "00FF00;", "00FF00;", "A020F0;", NA, "A020F0;", "A020F0;", "00FF00;", "A020F0;",
    "A020F0;", "A020F0;", "00FF00;", "A020F0;", "A020F0;", "00FF00;", "A020F0;"
    )

  exp_box_colors <- c(
    "000000;", "000000;", "A020F0;", "A020F0;", "00FF00;", "00FF00;",
     "00FF00;", "A020F0;", "A020F0;", "00FF00;", "A020F0;", "A020F0;",
     "00FF00;", "A020F0;", "00FF00;", "00FF00;", "00FF00;", "A020F0;",
     "000000;", "A020F0;", "A020F0;", "00FF00;", "A020F0;", "A020F0;",
     "A020F0;", "00FF00;", "A020F0;", "A020F0;", "00FF00;", "A020F0;"
    )

  expect_equal(box_colors, exp_box_colors)
  expect_equal(pill_colors, exp_pill_colors)

})
