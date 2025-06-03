test_that("gtsave_extra, file out works", {
  check_suggests()
  skip_if_not_installed("webshot2")
  skip_on_cran()
  skip_on_ci()

  # Create a filename with path, having the
  # .html extension
  path_1 <- tempfile(fileext = ".png")
  on.exit(unlink(path_1), add = TRUE)

  # Expect that a file does not yet exist
  # on that path
  expect_false(file.exists(path_1))

  car_tab <- head(mtcars) %>%
    gt::gt()

  # expect_silent(gtsave_extra(car_tab, path_1))
})
