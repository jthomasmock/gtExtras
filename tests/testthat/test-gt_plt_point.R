test_that("add_point_plot creates a plot", {

  check_suggests()

  plt15 <- add_point_plot(15, c("blue"), TRUE, 25, c(2,90), .1) %>%
    rvest::read_html()

  plt15_text <- plt15 %>%
    rvest::html_elements("svg > g > text") %>%
    rvest::html_text()

  expect_equal(plt15_text, c("2.0", "90.0"))

  pt15 <- plt15 %>%
    rvest::html_elements("svg > g") %>%
    rvest::html_elements("circle") %>%
    rvest::html_attrs() %>%
    .[[1]] %>%
    gsub(x = ., ".*fill: ", "") %>%
    gsub(x = ., ";.*", "") %>%
    unname()

  expect_equal(pt15, c("12.74", "4.94", "3.56", "#0000FF"))

  plt75 <- add_point_plot(75, c("blue"), FALSE, 25, c(2,90), .1) %>%
    rvest::read_html()

  plt75_text <- plt75 %>%
    rvest::html_elements("svg > g > text") %>%
    rvest::html_text()

  expect_equal(plt75_text, character(0))

  pt75 <- plt75 %>%
    rvest::html_elements("svg > g") %>%
    rvest::html_elements("circle") %>%
    rvest::html_attrs() %>%
    .[[1]] %>%
    gsub(x = ., ".*fill: ", "") %>%
    gsub(x = ., ";.*", "") %>%
    unname()

  expect_equal(pt75, c("56.66","4.94","3.56","#0000FF"))

})

test_that("gt_plt_point works as intended", {
  check_suggests()

  dot_plt <- dplyr::tibble(x = c(seq(1.2e6, 2e6, length.out = 5))) %>%
    gt::gt() %>%
    gt_duplicate_column(x,dupe_name = "point_plot") %>%
    gt_plt_point(point_plot, accuracy = .1, width = 25) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  dot_txt <- dot_plt %>%
    rvest::html_elements("svg > g > text") %>%
    rvest::html_text()

  expect_equal(dot_txt, rep(c("1.1M", "2.1M"), 2))

  dot_pts <- dot_plt %>%
    rvest::html_elements("svg > g > circle") %>%
    rvest::html_attrs() %>%
    lapply(., function(x){
      gsub(x = x, ".*fill: ", "") %>%
        gsub(x = ., ";.*", "") %>%
        unname() %>%
        .[c(1,4)]
    }) %>%
    unlist()


exp_pts <- c("8.59", "#F72E2E", "22.01", "#FF9C8B", "35.43",
             "#F0F0F0", "48.85", "#9BB3E4", "62.28", "#007AD6")

  expect_equal(dot_pts, exp_pts)

})
