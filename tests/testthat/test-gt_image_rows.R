test_that("img_rows, images exist", {
  check_suggests()
  skip_on_cran()

  teams <- "https://github.com/nflverse/nflfastR-data/raw/master/teams_colors_logos.rds"
  team_df <- readRDS(url(teams))

  temp_nm <- tempfile(fileext = ".html")

  logo_table <- team_df %>%
    dplyr::select(team_wordmark, team_abbr, logo = team_logo_espn, team_name:team_conf) %>%
    head() %>%
    gt::gt(id = "myTable") %>%
    gt_img_rows(columns = team_wordmark, height = 25) %>%
    gtsave(temp_nm)

  logo_html <- rvest::read_html(temp_nm)

  out_img <- logo_html %>%
    rvest::html_elements("td:nth-child(1)") %>%
    rvest::html_elements("img") %>%
    rvest::html_attr("src")

  in_img <- team_df$team_wordmark[1:6]

  expect_equal(out_img, in_img)

})
