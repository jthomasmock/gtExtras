test_that("img_header generates img", {
  check_suggests()
  skip_on_cran()
  example_img <- img_header(
    "Luka Doncic",
    "https://secure.espn.com/combiner/i?img=/i/headshots/nba/players/full/3945274.png",
    height = 45,
    font_size = 10
  ) %>% rvest::read_html()

  exp_attr <- example_img %>%
    rvest::html_element("div > img") %>%
    rvest::html_attrs()

  out_attr <- c("src" = "https://secure.espn.com/combiner/i?img=/i/headshots/nba/players/full/3945274.png",
    "height" = "45px",
    "style" = "border-bottom: 2px solid black;")

  expect_equal(exp_attr, out_attr)

  exp_div <- example_img %>%
    rvest::html_element("div > div") %>%
    rvest::html_attrs()

  act_div <- c("style" = "font-size:10px;color: black;text-align: center;width:100%;font-weight:bold;")

  expect_equal(exp_div, act_div)

})
