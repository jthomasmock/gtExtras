test_that("merge_stack, vals match expected and location", {
  check_suggests()

  merged_tab <- head(mtcars) %>%
    dplyr::mutate(cars = sapply(strsplit(rownames(.)," "), `[`, 1),
                  .before = mpg) %>%
    dplyr::select(1:4) %>%
    gt::gt() %>%
    gt_merge_stack(cars, mpg) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  merged_vals <- merged_tab %>%
    rvest::html_nodes("td:nth-child(1)") %>%
    rvest::html_text()

  exp_vals <- c("Mazda\n21", "Mazda\n21", "Datsun\n22.8",
                "Hornet\n21.4", "Hornet\n18.7", "Valiant\n18.1")

  expect_equal(merged_vals, exp_vals)

})

