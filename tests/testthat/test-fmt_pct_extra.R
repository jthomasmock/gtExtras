test_that("fmt_pct_extra generates expected output and colors", {
  check_suggests()

  pct_tab <- dplyr::tibble(x = c(.001,.05,.008,.1,.2,.5,.9)) %>%
    gt::gt() %>%
    fmt_pct_extra(x, scale = 100, accuracy=.1) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  text_out <- pct_tab %>%
    rvest::html_elements("td:nth-child(1)") %>%
    rvest::html_text()

 expect_equal(text_out, c("<1%", "5.0%", "<1%", "10.0%",
                          "20.0%", "50.0%", "90.0%"))

 txt_color <- pct_tab %>%
   rvest::html_elements("td:nth-child(1) > span") %>%
   rvest::html_attrs() %>%
   unlist() %>%
   unname()

 expect_equal(txt_color, c("color:grey;", "color:grey;"))


})
