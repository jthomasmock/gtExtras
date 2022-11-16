test_that("gt_index has correct inputs, correct ouput index, and can affect correct rows", {
  check_suggests()

  # This is a key step, as gt will create the row groups
  # based on first observation of the unique row items
  # this sampling will return a row-group order for cyl of 6,4,8

  set.seed(1234)
  sliced_data <- mtcars %>%
    dplyr::group_by(cyl) %>%
    dplyr::slice_head(n = 3) %>%
    dplyr::ungroup() %>%
    # randomize the order
    dplyr::slice_sample(n = 9)

  # not in "order" yet
  raw_order <- sliced_data$cyl

  # But unique order of 6,4,8
  unique_order <- unique(sliced_data$cyl)

# Expect input order to match ---------------------------------------------


  expect_equal(c(6,4,8), unique_order)
  expect_equal(c(6, 6, 6, 4, 8, 4, 8, 8, 4), raw_order)

  # creating a standalone basic table
  test_tab <- sliced_data %>%
    gt::gt(groupname_col = "cyl")

  # can style a specific column based on the contents of another column
  tab_out_styled <- test_tab %>%
    gt::tab_style(locations = cells_body(mpg, rows = gt_index(., am) == 0),
              style = cell_fill("red")
    ) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  expect_equal(
    tab_out_styled %>%
      rvest::html_elements("td:nth-child(1)") %>%
      as.character() %>%
      grepl("background-color", .),
    c(TRUE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE)
  )

  # tab_pattern <- "background-color: \\s*(.*?)\\s*;"
  # reg_matches <- regmatches(tab_styled, regexec(tab_pattern, tab_styled)) %>%
  #   lapply(function(x){x[2]}) %>%
  #   unlist()

#
# # Expect color backgrounds to match ---------------------------------------
#
#
#   expect_equal(reg_matches, c("#FFFFFF", "#FF0000", NA, NA, "#FFFFFF", NA,
#                               "#FF0000", "#FF0000", "#FFFFFF", "#FF0000",
#                               "#FF0000", "#FF0000"))


  # OR can extract the underlying data in the "correct order"
  # according to the internal gt structure, ie arranged by group
  # by cylinder, 6,4,8
  # gt_index(test_tab, mpg, as_vector = TRUE)
  # gt_index(test_tab, mpg, as_vector = FALSE)

  sliced_arranged <- sliced_data %>%
    dplyr::mutate(cyl = factor(cyl, levels = unique_order)) %>%
    dplyr::arrange(cyl) %>%
    dplyr::mutate(cyl = as.character(cyl))

# Expect the values to match ----------------------------------------------


  # expect_equal(gt_index(test_tab, mpg, as_vector = FALSE),
  #              sliced_arranged)
  # expect_equal(gt_index(test_tab, mpg, as_vector = TRUE),
  #              c(21.4, 21, 21, 22.8, 24.4, 22.8, 14.3, 18.7, 16.4))
})

