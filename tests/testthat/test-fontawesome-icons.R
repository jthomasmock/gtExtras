# Function to skip tests if Suggested packages not available on system
check_suggests <- function() {
  skip_if_not_installed("rvest")
  skip_if_not_installed("xml2")

}


test_that("fontawesome, test repeats", {
  check_suggests()

  fa_rep_html <- mtcars[1:5,1:4] %>%
    gt::gt() %>%
    gt_fa_repeats(cyl, name = "car") %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  row_counter <- function(row_n){
    fa_rep_html %>%
      rvest::html_nodes(paste0("tbody > tr:nth-child(", row_n, ")" )) %>%
      rvest::html_nodes("svg") %>%
      rvest::html_attr("aria-label")
  }

  expect_equal(row_counter(1), rep("Car", 5))
  expect_equal(row_counter(2), rep("Car", 5))
  expect_equal(row_counter(3), rep("Car", 3))
  expect_equal(row_counter(4), rep("Car", 5))
  expect_equal(row_counter(5), rep("Car", 7))

})


test_that("fontawesome, test column, name and colors", {
  check_suggests()

  fa_car_html <- head(mtcars) %>%
    dplyr::select(cyl, mpg, am, gear) %>%
    dplyr::mutate(man = ifelse(am == 1, "cog", "cogs")) %>%
    gt::gt() %>%
    gt_fa_column(man) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  fa_cogs <- fa_car_html %>%
    rvest::html_nodes("td:nth-child(5)") %>%
    rvest::html_nodes("svg") %>%
    rvest::html_attr("aria-label")

  cog_colors <- fa_car_html %>%
    rvest::html_nodes("td:nth-child(5)") %>%
    rvest::html_nodes("svg") %>%
    rvest::html_attr("style") %>%
    gsub(x = ., pattern = ".*fill:", "") %>%
    substr(1, 7)

  expect_equal(fa_cogs, rep(c("cog", "cogs"), each = 3))
  expect_equal(cog_colors, rep(c("#000000", "#E69F00"), each = 3))
})


test_that("fontawesome, test ratings all R and colors/numbers match", {
  check_suggests()

  rate_html <- mtcars %>%
    dplyr::select(mpg:wt) %>%
    dplyr::slice(1:5) %>%
    dplyr::mutate(rating = c(2,3,5,4,1)) %>%
    gt::gt() %>%
    gt_fa_rating(rating, icon = "r-project") %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  fa_stars <- rate_html %>%
    rvest::html_nodes("td:nth-child(7)") %>%
    rvest::html_nodes("svg") %>%
    rvest::html_attr("aria-label")

  star_color_fn <- function(row_n){
    rate_html %>%
      rvest::html_nodes(paste0("tr:nth-child(", row_n,")")) %>%
      rvest::html_nodes("td:nth-child(7)") %>%
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

test_that("fontawesome, test repeats", {
  check_suggests()

  color_fn <- function(pal= "#FF0000"){
    mtcars[1:5,1:4] %>%
      gt::gt() %>%
      gt_fa_repeats(cyl, name = "car", palette = pal) %>%
      gt::as_raw_html() %>%
      rvest::read_html() %>%
      rvest::html_nodes("td:nth-child(2)") %>%
      rvest::html_nodes("svg") %>%
      rvest::html_attr("style") %>%
      gsub(x = ., pattern = ".*fill:", "") %>%
      gsub(x = ., pattern = ";.*", "")
  }

  pal_out <- c("red", "blue", "green")

  pal_rep <- c(rep("red", 10), rep("blue", 3), rep("red", 5), rep("green", 7))

  expect_equal(color_fn("#FF0000"), rep("#FF0000", 25))
  expect_equal(color_fn("blue"), rep("blue", 25))
  expect_equal(color_fn(pal_out), pal_rep)

})



# Check for palette -------------------------------------------------------

test_that("fontawesome, test column, name and colors", {
  check_suggests()

  col_cog_fn <- function(pal){
    head(mtcars) %>%
      dplyr::select(cyl, mpg, am, gear) %>%
      dplyr::mutate(man = ifelse(am == 1, "cog", "cogs")) %>%
      gt::gt() %>%
      gt_fa_column(man, palette = pal) %>%
      gt::as_raw_html() %>%
      rvest::read_html() %>%
      rvest::html_nodes("td:nth-child(5)") %>%
      rvest::html_nodes("svg") %>%
      rvest::html_attr("style") %>%
      gsub(x = ., pattern = ".*fill:", "") %>%
      gsub(x = ., pattern = ";.*", "") %>%
      substr(1, 7)
  }

  expect_equal(col_cog_fn(c("red", "green")), rep(c("red", "green"), each = 3))
  expect_equal(col_cog_fn(c("red")), rep(c("red"), each = 6))
  expect_equal(col_cog_fn(c("cog" = "red", "cogs" = "green")), rep(c("red", "green"), each = 3))
})
