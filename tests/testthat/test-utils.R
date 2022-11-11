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


test_that("bw calc is appropriate", {

  expect_equal(round(bw_calc(mtcars$mpg), digits = 3), 4.646)
  expect_equal(round(bw_calc(c(mtcars$mpg, NA)), digits = 3), 4.599)


})

test_that("save_svg exports and imports SVG", {
  check_suggests()

  base_plot <- ggplot2::ggplot(aes(x=mpg, y=wt), data = mtcars)

  out_plot <- save_svg(base_plot)

  expect_true("html" %in% class(out_plot))

  out_svg <- out_plot %>%
    rvest::read_html() %>%
    rvest::html_nodes("svg") %>%
    length()

  expect_equal(out_svg, 1)

})

