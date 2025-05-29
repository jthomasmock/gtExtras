test_that("gt_plt_conf_int generates correct points/text", {
  check_suggests()

  ci_table <- generate_df(
    n = 50,
    n_grps = 3,
    mean = c(10, 15, 20),
    sd = c(10, 10, 10),
    with_seed = 37
  ) %>%
    dplyr::group_by(grp) %>%
    dplyr::summarise(
      n = dplyr::n(),
      avg = mean(values),
      sd = sd(values),
      list_data = list(values)
    ) %>%
    gt::gt() %>%
    gt_plt_conf_int(list_data, ci = 0.9) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  lab_text <- ci_table %>%
    rvest::html_elements("svg > g > g > text") %>%
    rvest::html_text()

  expect_equal(lab_text, c("11", "7", "17", "14", "21", "16"))

  ci_tab_attrs <- ci_table %>%
    rvest::html_elements("svg > g > g > circle") %>%
    rvest::html_attrs()
  ci_tab_style <- ci_tab_attrs %>%
    lapply(function(x) {
      x[c("style")]
    }) %>%
    unlist() %>%
    unname()

  expect_equal(
    ci_tab_style,
    rep(
      "stroke-linecap: round; stroke-linejoin: round; stroke-miterlimit: 10.00; stroke-width: 1.06; stroke: #FFFFFF; fill: #000000;",
      3
    )
  )

  ci_tab_svg <- ci_tab_attrs %>%
    lapply(function(x) {
      x[names(x) %in% c("cx")]
    }) %>%
    unlist() %>%
    unname()

  expect_equal(ci_tab_svg, c("29.48", "72.84", "95.20"))
})

test_that("gt_plt_conf_int uses correct points/text/colors", {
  check_suggests()

  # You can also provide your own values
  # based on your own algorithm/calculations
  pre_calc_ci_tab <- dplyr::tibble(
    mean = c(12, 10),
    ci1 = c(8, 5),
    ci2 = c(16, 15),
    ci_plot = c(12, 10)
  ) %>%
    gt::gt() %>%
    gt_plt_conf_int(
      ci_plot,
      c(ci1, ci2),
      palette = c("red", "lightgrey", "black", "red")
    ) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  lab_text_pre <- pre_calc_ci_tab %>%
    rvest::html_elements("svg > g > g > text") %>%
    rvest::html_text()

  expect_equal(lab_text_pre, c("16", "8", "15", "5"))

  pre_tab_attrs <- pre_calc_ci_tab %>%
    rvest::html_elements("svg > g > g > circle") %>%
    rvest::html_attrs()
  pre_tab_style <- pre_tab_attrs %>%
    lapply(function(x) {
      x[c("style")]
    }) %>%
    unlist() %>%
    unname()

  expect_equal(
    pre_tab_style,
    rep(
      "stroke: #000000; stroke-linecap: round; stroke-linejoin: round; stroke-miterlimit: 10.00; stroke-width: 1.06; fill: #FF0000;",
      2
    )
  )

  pre_tab_svg <- pre_tab_attrs %>%
    lapply(function(x) {
      x[names(x) %in% c("cx")]
    }) %>%
    unlist() %>%
    unname()

  expect_equal(pre_tab_svg, c("76.96", "59.39"))
})
