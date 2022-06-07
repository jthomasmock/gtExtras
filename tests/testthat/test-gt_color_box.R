test_that("gt_color_box palettes are created and have appropriate hex values", {
  check_suggests()

  test_data <- dplyr::tibble(x = letters[1:10],
                             y = seq(100, 10, by = -10),
                             z = seq(10, 100, by = 10))
  color_box_html <- test_data %>%
    gt::gt() %>%
    gt_color_box(columns = y, domain = 0:100, palette = "ggsci::blue_material") %>%
    gt_color_box(columns = z, domain = 0:100,
                 palette = c("purple", "lightgrey", "green")) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  blue_colors <- color_box_html %>%
    rvest::html_nodes("td:nth-child(2)") %>%
    rvest::html_nodes("div > div > div:nth-child(1)") %>%
    rvest::html_attr("style") %>%
    sub(".*background-color: #", "", .) %>%
    substr(., 1, 6)


  hulk_colors <- color_box_html %>%
    rvest::html_nodes("td:nth-child(3)") %>%
    rvest::html_nodes("div > div > div:nth-child(1)") %>%
    rvest::html_attr("style") %>%
    sub(".*background-color: #", "", .) %>%
    substr(., 1, 6)

  expect_equal(blue_colors, c("0D47A1","1462BD","1873CE","1D83DF","2090ED",
                              "349DF4","51ABF5","73BBF7","99CEF9","BFE0FB"))
  expect_equal(hulk_colors, c("B052EB","BC76E6","C696E0","CEB5DA","D3D3D3",
                              "C0DDB5","A9E796","8CF075","65F84E","00FF00"))

  })
