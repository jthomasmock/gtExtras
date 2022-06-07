test_that("divider has border and type", {
  check_suggests()

  divide_html <- head(mtcars) %>%
    gt::gt() %>%
    gt_add_divider(columns = "cyl", style = "dashed") %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  border_check <- function(row_n){
    divide_html %>%
      rvest::html_nodes(paste0("td:nth-child(",row_n,")")) %>%
      rvest::html_attr("style") %>%
      gsub(x = ., pattern = ".*border-right-width: ", "") %>%
      gsub(x = ., pattern = " border-right-style: | border-right-color: ", "")
  }

  expect_equal(gsub(x=border_check(1), pattern ="; .*", ""), rep("1px;#D3D3D3", 6))
  expect_equal(gsub(x=border_check(2), pattern ="; .*", ""), rep("2px;dashed;grey;", 6))
  expect_equal(gsub(x=border_check(3), pattern ="; .*", ""), rep("1px;#D3D3D3", 6))
  expect_equal(gsub(x=border_check(4), pattern ="; .*", ""), rep("1px;#D3D3D3", 6))
  expect_equal(gsub(x=border_check(5), pattern ="; .*", ""), rep("1px;#D3D3D3", 6))
  expect_equal(gsub(x=border_check(6), pattern ="; .*", ""), rep("1px;#D3D3D3", 6))

})


test_that("divider has border and type on far right", {
  check_suggests()

  divide_html_blue <- head(mtcars) %>%
    gt::gt() %>%
    gt_add_divider(columns = "carb", color = "blue", weight = px(5)) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  blue_border <- divide_html_blue %>%
    rvest::html_nodes("td:nth-child(11)") %>%
    rvest::html_attr("style") %>%
    gsub(x = ., pattern = ".*border-right-width: ", "") %>%
    gsub(x = ., pattern = " border-right-style: | border-right-color: ", "")

  expect_equal(blue_border, rep("5px;solid;blue;", 6))

})

test_that("divider has border and doesn't include labels", {
  check_suggests()

  divide_html_lab <- head(mtcars) %>%
    gt::gt() %>%
    gt_add_divider(columns = carb, include_labels = FALSE) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  lab_border <- divide_html_lab %>%
    rvest::html_nodes("td:nth-child(11)") %>%
    rvest::html_attr("style") %>%
    gsub(x = ., pattern = ".*border-right-width: ", "") %>%
    gsub(x = ., pattern = " border-right-style: | border-right-color: ", "")

  lab_top_border <- divide_html_lab %>%
    rvest::html_nodes("th:nth-child(11)") %>%
    rvest::html_attr("style") %>%
    gsub(x = ., pattern = ".*border-right-width: ", "") %>%
    gsub(x = ., pattern = " border-right-style: | border-right-color: ", "") %>%
    gsub(x = ., pattern = "; .*", "")


  expect_equal(lab_border, rep("2px;solid;grey;", 6))
  expect_equal(lab_top_border, "1px;#D3D3D3")

})


