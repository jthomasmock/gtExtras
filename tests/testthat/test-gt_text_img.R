test_that("gt_text_img is created and matches", {
  check_suggests()
  skip_on_cran()
  temp_nm <- tempfile(fileext = ".html")

  in_title <- "https://www.r-project.org/logo/Rlogo.png"

  title_car <- mtcars %>%
    head() %>%
    gt::gt() %>%
    gt::tab_header(
      title = add_text_img(
        "A table about cars made with",
        url = in_title
        )
      ) %>%
    gt::gtsave(temp_nm)

  title_html <- rvest::read_html(temp_nm)

  out_title <- title_html %>%
    rvest::html_elements("th > div:nth-child(2)") %>%
    rvest::html_elements("img") %>%
    rvest::html_attr("src")

  expect_equal(out_title, in_title)

})

