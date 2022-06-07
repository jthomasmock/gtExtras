test_that("two_column_layout, two gt_tbl objects", {
  check_suggests()
  skip_if_not_installed("webshot2")
  skip_on_cran()
  skip_on_ci()

  # define your own function
  my_gt_function <- function(x){
    gt::gt(x)
  }

  two_tables <- gt_double_table(mtcars, my_gt_function, nrows = 16)
  two_tab_null <- gt_double_table(mtcars, my_gt_function)

  two_obj <- sapply(two_tables, function(x) (class(x)[1]))
  two_obj_null <- sapply(two_tables, function(x) (class(x)[1]))

  expect_equal(two_obj, rep("gt_tbl", 2))
  expect_equal(two_obj_null, rep("gt_tbl", 2))

})


test_that("two_column_layout saving works", {
  check_suggests()
  skip_if_not_installed("webshot2")
  skip_on_cran()
  skip_on_ci()

  # Create a filename with path, having the
  # .html extension
  path_1 <- tempfile(fileext = ".html")
  on.exit(unlink(path_1), add = TRUE)

  # Expect that a file does not yet exist
  # on that path
  expect_false(file.exists(path_1))

  # add row numbers and drop some columns
  my_cars <- mtcars %>%
    dplyr::mutate(row_n = dplyr::row_number(), .before = mpg) %>%
    dplyr::select(row_n, mpg:drat)
  # create a one-argument function, passing data to `gt::gt()`
  my_gt_fn <- function(x){
    gt(x) %>%
      gtExtras::gt_color_rows(columns = row_n, domain = 1:32)
  }

  # pass data, your function and the nrows
  my_tables <- gt_double_table(my_cars, my_gt_fn, nrows = nrow(my_cars)/2)

  # boom, this will return it to the viewer
  my_output <- gt_two_column_layout(my_tables)

  path_2 <- tempfile(fileext = ".png")
  on.exit(unlink(path_2), add = TRUE)

  # Expect that a file does not yet exist
  # on that path
  expect_false(file.exists(path_2))

  raw_html <- gt_two_column_layout(my_tables, output = "html") %>%
    htmltools::save_html(path_1)

  # now file exists
  expect_true(file.exists(path_1))

  # save as png
  gt_two_column_layout(my_tables, output = "save", filename = path_2,
                       vwidth = 550, vheight = 620)

  # png exists
  expect_true(file.exists(path_2))

  # output to browsable/ie viewer
  view_browse <- gt_two_column_layout(my_tables, output = "viewer", filename = path_2,
                       vwidth = 550, vheight = 620)

  # is viewable
  expect_true(htmltools::is.browsable(view_browse))

})
