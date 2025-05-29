test_that("svg is created and has specific values", {
  check_suggests()
  skip_on_cran()
  skip_on_ci()
  base_table <- dplyr::tibble(
    x = 1,
    names = c("Hadley Wickham"),
    img = c(
      "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Hadley-wickham2016-02-04.jpg/800px-Hadley-wickham2016-02-04.jpg"
    )
  ) %>%
    gt::gt() %>%
    gt_img_circle(img) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  test_style <- base_table %>%
    rvest::html_elements("div") %>%
    rvest::html_attr("style") %>%
    lapply(function(x){
      grepl(x = x, pattern = paste0(
        "background-size:cover;background-position:center;",
        "border: 1.5px solid black;border-radius: 50%;height:25px;width:100%;"
        )
      )
      }) %>%
    unlist()

  expect_equal(test_style, c(FALSE))

})
