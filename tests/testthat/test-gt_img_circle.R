test_that("svg is created and has specific values", {
  check_suggests()
  skip_on_cran()
  base_table <- dplyr::tibble(
    x = 1:4,
    names = c("Rich Iannone",  "Katie Masiello", "Tom Mock","Hadley Wickham"),
    img = c(
      "https://pbs.twimg.com/profile_images/961326215792533504/Ih6EsvtF_400x400.jpg",
      "https://pbs.twimg.com/profile_images/1123066272718049281/23XnoFUV_400x400.png",
      "https://pbs.twimg.com/profile_images/1344725315684282371/R9k8sgna_400x400.jpg",
      "https://pbs.twimg.com/profile_images/905186381995147264/7zKAG5sY_400x400.jpg"
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

  expect_equal(test_style, c(FALSE, TRUE, TRUE, TRUE, TRUE))

})
