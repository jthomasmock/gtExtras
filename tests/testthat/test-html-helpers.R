test_that("details tag is created", {

  check_suggests()
  gt_label_details("howdy", c("big" = "if true", "hat" = "Cowboy")) %>%
    grepl(x = ., "<details>") %>%
    expect_true()
})

test_that("tooltip is created", {

  check_suggests()

  out_tooltip <- with_tooltip("What do cowboys say?", "Howdy!") %>%
    as.character()
  exp_tooltip <- paste0("<abbr style=\"text-decoration: underline; ",
                        "text-decoration-style: solid;&#10;    ",
                        "cursor: question; color: blue\" title=\"Howdy!\">",
                        "What do cowboys say?</abbr>")
  expect_equal(out_tooltip, exp_tooltip)
})

test_that("hyperlink is created", {
  check_suggests()
  skip_on_cran()

  out_hyperlink <- gt_hyperlink("rstudio.com", "https://rstudio.com") %>%
    as.character()

  exp_hyperlink <- "<a href=\"https://rstudio.com\" target=\"_blank\">rstudio.com</a>"

  expect_equal(out_hyperlink, exp_hyperlink)

})

test_that("badge color is created",{

  out_badge_color <- add_badge_color("red", "label text", 0.2) %>%
    as.character()

  exp_badge_color <- paste0(
    "<div style=\"display: inline-block; padding: 2px 12px; ",
    "border-radius: 15px; font-weight: 600; font-size: 12px; ",
    "background:#FF000033;\">label text</div>")

  expect_equal(out_badge_color, exp_badge_color)

})

test_that("badge color is created and accurate in gt", {
  check_suggests()

  badge_tab <- head(mtcars) %>%
    dplyr::mutate(cyl = paste(cyl, "Cyl")) %>%
    gt::gt() %>%
    gt_badge(cyl, palette = c("4 Cyl"="red","6 Cyl"="blue","8 Cyl"="green")) %>%
    gt::as_raw_html() %>%
    rvest::read_html()

  raw_colors <- badge_tab %>%
    rvest::html_elements("td:nth-child(2) > div") %>%
    rvest::html_attrs() %>%
    lapply(function(x){
      strsplit(x, "; ", fixed = TRUE)}) %>%
    lapply(function(x){
      x$style[6] %>% gsub(x=., "background:", "")
    }) %>%
    unlist()

  exp_colors <- c(rep("#0000FF33;",2), "#FF000033;", "#0000FF33;",
                  "#00FF0033;", "#0000FF33;")
  expect_equal(raw_colors, exp_colors)

})
