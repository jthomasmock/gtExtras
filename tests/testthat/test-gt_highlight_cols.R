# Function to skip tests if Suggested packages not available on system
check_suggests <- function() {
  skip_if_not_installed("rvest")
  skip_if_not_installed("xml2")

}


test_that("gt_highlight_row correct row is highlighted and is blue", {
  check_suggests()

  basic_col <-  gt::gt(head(mtcars)) %>%
    gt_highlight_cols(cyl, fill = "red", alpha = 0.5) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  high_col <- basic_col %>%
    rvest::html_nodes("td:nth-child(2)") %>%
    rvest::html_attr("style") %>%
    gsub(x = ., pattern = ".*background-color: ", "") %>%
    substr(1, 17)

  expect_equal(high_col, rep("rgba(255,0,0,0.5)", 6))

})



