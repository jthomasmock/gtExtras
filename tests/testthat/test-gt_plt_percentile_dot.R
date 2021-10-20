# Function to skip tests if Suggested packages not available on system
check_suggests <- function() {
  skip_if_not_installed("rvest")
  skip_if_not_installed("xml2")
}

test_that("add_pcttile_plot creates a plot", {

  check_suggests()

  plt15 <- add_pcttile_plot(15, "green", TRUE, 25) %>%
    rvest::read_html()

  plt15_text <- plt15 %>%
    rvest::html_elements("svg > g > text") %>%
    rvest::html_text()

  expect_equal(plt15_text, c("0","100","5", "0"))

  pt15 <- plt15 %>%
    rvest::html_elements("svg > g") %>%
    rvest::html_elements("circle") %>%
    rvest::html_attrs() %>%
    .[[1]] %>%
    gsub(x = ., ".*fill: ", "") %>%
    gsub(x = ., ";.*", "") %>%
    unname()

  expect_equal(pt15, c("12.88", "7.09", "2.49", "#00FF00"))

  plt75 <- add_pcttile_plot(75, "#00FF00", FALSE, 25) %>%
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

  expect_equal(pt75, c("51.54", "7.09", "2.49", "#00FF00"))

  })

test_that("gt_plt_percentile works as intended", {

  dot_plt <- dplyr::tibble(x = c(seq(10, 90, length.out = 5))) %>%
    gt::gt() %>%
    gt_duplicate_column(x,dupe_name = "dot_plot") %>%
    gt_plt_percentile(dot_plot) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  dot_txt <- dot_plt %>%
    rvest::html_elements("svg > g > text") %>%
    rvest::html_text()

  expect_equal(dot_txt, rep(c("0", "100", "5", "0"), 2))

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

  exp_pts <- c("9.66", "#762A83", "22.55", "#D3D3D3", "35.43",
               "#D3D3D3", "48.32", "#D3D3D3", "61.20", "#1B7837")

  expect_equal(dot_pts, exp_pts)

})
