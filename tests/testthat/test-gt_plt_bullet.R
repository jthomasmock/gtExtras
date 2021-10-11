# Function to skip tests if Suggested packages not available on system
check_suggests <- function() {
  skip_if_not_installed("rvest")
  skip_if_not_installed("xml2")
}

test_that("gt_plt_bullet SVG is created and has specific values", {
  check_suggests()

  bullet_tab <- tibble::rownames_to_column(mtcars) %>%
    dplyr::select(rowname, cyl:drat, mpg) %>%
    dplyr::group_by(cyl) %>%
    dplyr::mutate(target_col = mean(mpg)) %>%
    dplyr::slice_head(n = 3) %>%
    dplyr::ungroup() %>%
    gt::gt() %>%
    gt_plt_bullet(column = mpg, target = target_col, width = 45,
                  colors = c("lightblue", "black")) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  bar_vals <- bullet_tab %>%
    rvest::html_nodes("svg > g > rect") %>%
    rvest::html_attr("width") %>%
    as.character()

  target_vals <- bullet_tab %>%
    rvest::html_nodes("svg > g") %>%
    rvest::html_nodes("line") %>%
    .[seq(1, 17, by = 2)] %>%
    rvest::html_attr("x1") %>%
    as.character()

  exp_bar_vals <- as.character(c("103.65","110.92","103.65","95.46","95.46","97.28","85.01","65.01","74.55" ))
  exp_tar_vals <- as.character(c("121.19","121.19","121.19","89.74","89.74","89.74","68.64","68.64","68.64"))
  expect_equal(bar_vals, exp_bar_vals)
  expect_equal(target_vals, exp_tar_vals)
  })
