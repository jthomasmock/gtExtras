test_that("tab_style_by_grp, groups respected", {
  check_suggests()

  df_in <- mtcars %>%
    dplyr::select(cyl:hp, mpg) %>%
    tibble::rownames_to_column() %>%
    dplyr::group_by(cyl) %>%
    dplyr::slice(1:4) %>%
    dplyr::ungroup()

  test_tab <- df_in %>%
    gt::gt(groupname_col = "cyl") %>%
    tab_style_by_grp(mpg, fn = max, cell_fill(color = "red", alpha = 0.5)) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  get_grp_rows <- function(row_n){
    test_tab %>%
      rvest::html_elements(paste0("tr:nth-child(", row_n,") > td:nth-child(4)")) %>%
      rvest::html_attr("style") %>%
      gsub(x = ., pattern = ".*background-color: |;", "")

  }

  grp_colors <- lapply(c(5, 9, 12), get_grp_rows) %>% unlist()

  other_rows <- lapply(c(1:4, 6:8, 10:11), get_grp_rows) %>% unlist() %>%
    grepl(x = ., "rgb")

  expect_equal(grp_colors, rep("rgba(255,0,0,0.5)", 3))
  expect_true(all(other_rows == FALSE))

})

