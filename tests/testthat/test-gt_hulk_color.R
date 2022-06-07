# Gets the HTML attr value from a single key
selection_value <- function(html, key) {

  selection <- paste0("[", key, "]")

  html %>%
    rvest::html_nodes(selection) %>%
    rvest::html_attr(key)
}


test_that("Hulk palette is created and has appropriate hex values", {
  check_suggests()

 hulk_basic <- mtcars %>%
   head() %>%
   gt::gt() %>%
   gt_hulk_col_numeric(mpg)

 hulk_gt_html <- hulk_basic %>%
   gt::as_raw_html() %>%
   rvest::read_html()

 hulk_colors <- hulk_gt_html %>%
   rvest::html_nodes("td:nth-child(1)") %>%
   rvest::html_attr("style") %>%
   sub(".*background-color: #", "", .) %>%
   substr(., 1, 6)

 expect_equal(hulk_colors, c("E2F2DE","E2F2DE","1B7837","C6E6C0","A276B4","762A83"))

 })
