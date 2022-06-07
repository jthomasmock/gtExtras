test_that("gt_plt_bullet SVG is created and has specific values", {
  check_suggests()

  bullet_tab <- tibble::rownames_to_column(mtcars) %>%
    dplyr::select(rowname, cyl:drat, mpg) %>%
    dplyr::group_by(cyl) %>%
    dplyr::mutate(target_col = round(mean(mpg), digits = 1)) %>%
    dplyr::slice_head(n = 3) %>%
    dplyr::ungroup() %>%
    gt::gt() %>%
    gt_plt_bullet(column = mpg, target = target_col, width = 45,
                  palette = c("lightblue", "black")) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  bar_vals <- bullet_tab %>%
    rvest::html_nodes("svg > g > rect") %>%
    rvest::html_attr("width") %>%
    as.double() %>%
    round(digits = 1)

  target_vals <- bullet_tab %>%
    rvest::html_nodes("svg > g") %>%
    rvest::html_nodes("line") %>%
    .[seq(1, 17, by = 2)] %>%
    rvest::html_attr("x1") %>%
    as.double() %>%
    round(digits = 0)

  exp_bar_vals <- c(103.7, 110.9, 103.7, 95.5, 95.5, 97.3, 85, 65, 74.6)
  exp_tar_vals <- c(121, 121, 121, 90, 90, 90, 69, 69, 69)
  expect_equal(bar_vals, exp_bar_vals)
  expect_equal(target_vals, exp_tar_vals)
  })

# test_that("gt_plt_bullet keep_column = TRUE", {
#   check_suggests()
#
#   bullet_df <- tibble::rownames_to_column(mtcars) %>%
#     dplyr::select(rowname, cyl:drat, mpg) %>%
#     dplyr::group_by(cyl) %>%
#     dplyr::mutate(target_col = round(mean(mpg), digits = 1)) %>%
#     dplyr::slice_head(n = 3) %>%
#     dplyr::ungroup()
#
#   bullet_tab <- bullet_df %>%
#     gt::gt() %>%
#     gt_plt_bullet(column = mpg, target = target_col, width = 45,
#                   colors = c("lightblue", "black"), keep_column = TRUE) %>%
#     gt::as_raw_html() %>%
#     rvest::read_html()
#
#   bar_vals <- bullet_tab %>%
#     rvest::html_nodes("svg > g > rect") %>%
#     rvest::html_attr("width") %>%
#     as.double() %>%
#     round(digits = 1)
#
#   dupe_vals <- bullet_tab %>%
#     rvest::html_nodes("td:nth-child(6)") %>%
#     rvest::html_text() %>%
#     as.double()
#
#   target_vals <- bullet_tab %>%
#     rvest::html_nodes("svg > g") %>%
#     rvest::html_nodes("line") %>%
#     .[seq(1, 17, by = 2)] %>%
#     rvest::html_attr("x1") %>%
#     as.double() %>%
#     round(digits = 0)
#
#   exp_bar_vals <- c(103.7, 110.9, 103.7, 95.5, 95.5, 97.3, 85, 65, 74.6)
#   exp_tar_vals <- c(121, 121, 121, 90, 90, 90, 69, 69, 69)
#   expect_equal(bar_vals, exp_bar_vals)
#   expect_equal(target_vals, exp_tar_vals)
#   expect_equal(dupe_vals, bullet_df$mpg[1:9])
#
# })
