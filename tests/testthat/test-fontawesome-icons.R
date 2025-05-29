test_that("fontawesome, test ratings all R and colors/numbers match", {
  check_suggests()
  skip_on_cran()
  skip_on_ci()

  rate_html <- mtcars %>%
    dplyr::select(mpg:hp) %>%
    dplyr::slice(1:5) %>%
    dplyr::mutate(rating = c(2, 3, 5, 4, 1)) %>%
    dplyr::add_row(mpg = mean(mtcars$mpg), cyl = 6, disp = 190, rating = NA) %>%
    gt::gt() %>%
    gt_fa_rating(rating, icon = "r-project") %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  fa_stars <- rate_html %>%
    rvest::html_nodes("td:nth-child(5)") %>%
    rvest::html_nodes("svg") %>%
    rvest::html_attr("aria-label")

  star_color_fn <- function(row_n) {
    rate_html %>%
      rvest::html_nodes(paste0("tr:nth-child(", row_n, ")")) %>%
      rvest::html_nodes("td:nth-child(5)") %>%
      rvest::html_nodes("svg") %>%
      rvest::html_attr("style") %>%
      gsub(x = ., pattern = ".*fill:", "") %>%
      gsub(x = ., pattern = ";.*", "")
  }

  expect_equal(fa_stars, rep("R Project", 25))
  expect_equal(star_color_fn(1), c(rep("orange", 2), rep("grey", 3)))
  expect_equal(star_color_fn(2), c(rep("orange", 3), rep("grey", 2)))
  expect_equal(star_color_fn(3), c(rep("orange", 5), rep("grey", 0)))
  expect_equal(star_color_fn(4), c(rep("orange", 4), rep("grey", 1)))
  expect_equal(star_color_fn(5), c(rep("orange", 1), rep("grey", 4)))
})


# fa-palette --------------------------------------------------------------

# test_that("fontawesome, test repeats", {
#   check_suggests()
#   skip_on_cran()
#   skip_on_ci()

#   color_fn <- function(pal = "#FF0000") {
#     mtcars[1:5, 1:4] %>%
#       gt::gt() %>%
#       gt_fa_repeats(cyl, name = "car", palette = pal) %>%
#       gt::as_raw_html() %>%
#       rvest::read_html() %>%
#       rvest::html_nodes("td:nth-child(2)") %>%
#       rvest::html_nodes("svg") %>%
#       rvest::html_attr("style") %>%
#       gsub(x = ., pattern = ".*fill:", "") %>%
#       gsub(x = ., pattern = ";.*", "")
#   }

#   pal_out <- c("red", "blue", "green")

#   pal_rep <- c(rep("red", 12), rep("blue", 4), rep("red", 6), rep("green", 8))

#   expect_equal(color_fn("#FF0000"), rep("#FF0000", 30))
#   expect_equal(color_fn("blue"), rep("blue", 30))
#   expect_equal(color_fn(pal_out), pal_rep)
# })

# Check for palette -------------------------------------------------------

# test_that("fontawesome, test column, name and colors", {
#   check_suggests()
#   skip_on_cran()
#   skip_on_ci()

#   col_cog_fn <- function(pal) {
#     head(mtcars) %>%
#       dplyr::select(cyl, mpg, am, gear) %>%
#       dplyr::mutate(man = ifelse(am == 1, "gear", "gears")) %>%
#       gt::gt() %>%
#       gt_fa_column(man, palette = pal) %>%
#       gt::as_raw_html() %>%
#       rvest::read_html() %>%
#       rvest::html_nodes("td:nth-child(5)") %>%
#       rvest::html_nodes("svg") %>%
#       rvest::html_attr("style") %>%
#       gsub(x = ., pattern = ".*fill:", "") %>%
#       gsub(x = ., pattern = ";.*", "") %>%
#       substr(1, 7)
#   }

#   expect_equal(col_cog_fn(c("red", "green")), rep(c("red", "green"), each = 3))
#   expect_equal(col_cog_fn(c("red")), rep(c("red"), each = 6))
#   expect_equal(col_cog_fn(c("gear" = "red", "gears" = "green")), rep(c("red", "green"), each = 3))
# })

# Check for palette -------------------------------------------------------

test_that("fontawesome, test rank change", {
  check_suggests()
  skip_on_cran()

  base_tab <- dplyr::tibble(x = c(1:3, -1, -2, -5, 0)) %>%
    gt::gt()

  rank_tab <- base_tab %>%
    gt_fa_rank_change(x, font_color = "match") %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  rank_tab_items <- rank_tab %>%
    rvest::html_elements("svg") %>%
    rvest::html_attrs() %>%
    lapply(function(x) {
      x[c("aria-label", "style")] %>%
        gsub(x = ., pattern = ".*fill:", "") %>%
        gsub(x = ., pattern = ";.*", "")
    })

  expect_equal(
    c(sapply(rank_tab_items, function(x) x[1]) %>% unname()),
    c(rep("Angles Up", 3), rep("Angles Down", 3), "Equals")
  )

  expect_equal(
    sapply(rank_tab_items, function(x) x[2]) %>% unname(),
    c(rep("#1b7837", 3), rep("#762a83", 3), "lightgrey")
  )

  no_text <- base_tab %>%
    gt_fa_rank_change(x, show_text = FALSE, fa_type = "caret") %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  no_text_items <- no_text %>%
    rvest::html_elements("svg") %>%
    rvest::html_attrs() %>%
    lapply(function(x) {
      x[c("aria-label", "style")] %>%
        gsub(x = ., pattern = ".*fill:", "") %>%
        gsub(x = ., pattern = ";.*", "")
    })

  expect_equal(
    sapply(no_text_items, function(x) x[1]) %>% unname(),
    c(rep("Caret Up", 3), rep("Caret Down", 3), "Equals")
  )

  expect_equal(
    sapply(no_text_items, function(x) x[2]) %>% unname(),
    c(rep("#1b7837", 3), rep("#762a83", 3), "lightgrey")
  )

  custom_tab <- base_tab %>%
    gt_fa_rank_change(
      x,
      palette = c("blue", "grey", "red"),
      font_color = "black",
      fa_type = "caret"
    ) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  custom_tab_items <- custom_tab %>%
    rvest::html_elements("svg") %>%
    rvest::html_attrs() %>%
    lapply(function(x) {
      x[c("aria-label", "style")] %>%
        gsub(x = ., pattern = ".*fill:", "") %>%
        gsub(x = ., pattern = ";.*", "")
    })

  expect_equal(
    sapply(custom_tab_items, function(x) x[1]) %>% unname(),
    c(rep("Caret Up", 3), rep("Caret Down", 3), "Equals")
  )

  expect_equal(
    sapply(custom_tab_items, function(x) x[2]) %>% unname(),
    c(rep("blue", 3), rep("red", 3), "grey")
  )
})
