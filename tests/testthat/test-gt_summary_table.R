test_that("summary_table created", {
  # basic summary
  exibble <- gt::exibble
  exibble$int <- as.integer(1:8)
  gt_sum <- create_sum_table(exibble)

  expect_equal(names(gt_sum), c("type", "name", "value", "n_missing", "Mean", "Median", "SD"))

  out_list <- lapply(gt_sum, class)
  compare_list <- list(type = "character", name = "character", value = "list",
    n_missing = "numeric", Mean = "numeric", Median = "numeric", SD = "numeric")

  expect_equal(out_list, compare_list)

  type_col<- c("numeric", "character", "factor", "character", "character",
    "character", "numeric", "character", "character", "integer")

  expect_equal(type_col, gt_sum$type)

})


test_that("svg is created", {
  check_suggests()

  num_plot <- plot_data(gt::exibble$num)
  chr_plot <- plot_data(gt::exibble$char)

  expect_true("html" %in% class(num_plot))
  expect_true("html" %in% class(chr_plot))

  num_html <- num_plot %>%
    rvest::read_html()

  chr_html <- chr_plot %>%
    rvest::read_html()

  # SVG Exists and is of length 3 ----

  num_len <- num_html %>%
    rvest::html_nodes("svg") %>%
    length()

  chr_len <- chr_html %>%
    rvest::html_nodes("svg") %>%
    length()


  expect_equal(num_len, 1)
  expect_equal(chr_len, 1)
})


test_that("table is created with expected output", {
  check_suggests()

  my_exibble <- gt::exibble |>
    mutate(date = as.Date(date),
      time = hms::parse_hm(time),
      datetime = as.POSIXct(datetime,tz=Sys.timezone())
    )

  ex_tab <- gt_plt_summary(my_exibble)

  vec_miss <- ex_tab[["_data"]][["n_missing"]]
  vec_miss_out <- c(0.125, 0.125, 0, 0.125, 0.125, 0.125, 0.125, 0, 0)

  expect_equal(vec_miss, vec_miss_out)
  ex_html <- ex_tab %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  ex_svg_len <- ex_html %>%
    rvest::html_nodes("svg") %>%
    length()

  expect_equal(ex_svg_len, 9)

  ex_svg_text <- ex_html %>%
    rvest::html_nodes("svg") %>%
    rvest::html_nodes("text") %>%
    rvest::html_text()

  ex_svg_text_out <- c(
    "0", "9M", "7 categories", "8 categories", "2015-01-15",
    "2015-08-15", "13:35:00", "20:20:00", "2018-01-01",
    "2018-07-07", "0", "65K", "8 categories", "2 categories"
    )


  expect_equal(ex_svg_text, ex_svg_text_out)

})
