test_that("fa_icon_repeat, is a fa icon", {
  check_suggests()
  skip_on_cran()

  svg_len <- fa_icon_repeat() %>%
    rvest::read_html() %>%
    rvest::html_elements("svg") %>%
    length()

  expect_equal(class(fa_icon_repeat()), c("html", "character"))
  expect_equal(svg_len, 3)


})
