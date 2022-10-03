test_that("gt_text_img is created and matches", {
  check_suggests()
  skip_on_cran()
  temp_nm <- tempfile(fileext = ".html")

  in_title <- "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Boston_Terrier_male.jpg/330px-Boston_Terrier_male.jpg"

  title_car <- mtcars %>%
    head() %>%
    gt::gt() %>%
    gt::tab_header(
      title = add_text_img(
        "A table about cars made with",
        url = in_title,
        height = px(30)
        )
      ) %>%
    gt::gtsave(temp_nm)

  title_html <- rvest::read_html(temp_nm)

  out_title <- title_html %>%
    rvest::html_elements("img") %>%
    rvest::html_attr("src")

  expect_equal(out_title, in_title)

})

