# Function to skip tests if Suggested packages not available on system
check_suggests <- function() {
  skip_if_not_installed("rvest")
  skip_if_not_installed("xml2")

}

test_that("two_column_layout, two gt_tbl objects", {
  check_suggests()

  # define your own function
  my_gt_function <- function(x){
    gt::gt(x)
  }

  two_tables <- gt_double_table(mtcars, my_gt_function, nrows = 16)

  two_obj <- sapply(two_tables, function(x) (class(x)[1]))

  expect_equal(two_obj, rep("gt_tbl", 2))

})

