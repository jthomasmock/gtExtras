test_that("n_decimals are expected", {

  expect_equal(n_decimals(12345), 0)
  expect_equal(n_decimals(1234.5), 1)
  expect_equal(n_decimals(123.45), 2)
  expect_equal(n_decimals(12.345), 3)
  expect_equal(n_decimals(1.2345), 4)
  expect_equal(n_decimals(00.12345), 5)
  expect_equal(n_decimals(.00100), 3)
  expect_equal(n_decimals(.001), 3)

})
