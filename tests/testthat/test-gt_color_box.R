test_that("gt_color_box palettes are created and have appropriate hex values", {
  check_suggests()

  test_data <- dplyr::tibble(x = letters[1:10],
                             y = seq(100, 10, by = -10),
                             z = seq(10, 100, by = 10),
                             pff = seq(10, 100, by = 10),
                             blank = seq(10, 100, by = 10))

  color_box_html <- test_data %>%
    gt::gt() %>%
    gt_color_box(columns = y, domain = 0:100, palette = "ggsci::blue_material") %>%
    gt_color_box(columns = z, domain = 0:100,
                 palette = c("purple", "lightgrey", "green")) %>%
    gt_color_box(columns = pff, domain = 0:100,
                 palette = "pff") %>%
    gt_color_box(columns = blank, domain = 0:100, palette = NULL) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  get_colors <- function(n){
    color_box_html %>%
      rvest::html_nodes(glue::glue("td:nth-child({n})")) %>%
      rvest::html_nodes("div > div > div:nth-child(1)") %>%
      rvest::html_attr("style") %>%
      sub(".*background-color: #", "", .) %>%
      substr(., 1, 6)
  }

  blue_colors <- get_colors(2)
  hulk_colors <- get_colors(3)
  pff_colors <- get_colors(4)
  def_colors <- get_colors(5)


  pff_def_colors <- c("E15B1F", "F48411", "FEA300", "FFBA00", "FFD000",
                      "BBC416", "6FB620", "459D47", "437D77", "0C5EA0")
  def_def_colors <- c("9966A9", "BA9BCA", "DCC5E1", "EDE2EE", "F7F7F7",
                      "E5F3E1", "C7E6C1", "91C98C", "5AA25F", "1B7837")

  expect_equal(blue_colors, c("0D47A1","1462BD","1873CE","1D83DF","2090ED",
                              "349DF4","51ABF5","73BBF7","99CEF9","BFE0FB"))
  expect_equal(hulk_colors, c("B052EB","BC76E6","C696E0","CEB5DA","D3D3D3",
                              "C0DDB5","A9E796","8CF075","65F84E","00FF00"))
  expect_equal(pff_colors, pff_def_colors)
  expect_equal(def_colors, def_def_colors)


})
