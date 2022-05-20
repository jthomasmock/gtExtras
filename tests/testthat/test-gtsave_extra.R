# Function to skip tests if Suggested packages not available on system
check_suggests <- function() {
  skip_if_not_installed("rvest")
  skip_if_not_installed("xml2")
  skip_if_not_installed("webshot2")
  skip_on_cran()
}

test_that("gtsave_extra, file out works", {
  check_suggests()

  # Create a filename with path, having the
  # .html extension
  path_1 <- tempfile(fileext = ".png")
  on.exit(unlink(path_1))

  # Expect that a file does not yet exist
  # on that path
  expect_false(file.exists(path_1))

  head(mtcars) %>%
    gt::gt() %>%
    gtsave_extra(path_1)

  expect_true(file.exists(path_1))

})
