test_that("img_mulit_rows, images exist", {
  check_suggests()
  skip_on_cran()

  teams <- "https://github.com/nflverse/nflfastR-data/raw/master/teams_colors_logos.rds"
  team_df <- readRDS(url(teams))

  temp_nm <- tempfile(fileext = ".html")

  conf_table <- team_df %>%
    dplyr::select(team_conf, team_division, logo = team_logo_espn) %>% 
    dplyr::distinct() %>%
    tidyr::nest(data = logo) %>%
    dplyr::rename(team_logos = data)%>%
    gt::gt(id = "myTable") %>%
    gt_img_multi_rows(columns = team_logos, height = 25) %>% 
    gtsave(temp_nm)

  conf_html <- rvest::read_html(temp_nm)

  out_img <- conf_html %>%
    rvest::html_elements("td:nth-child(3)") %>%
    rvest::html_elements("img") %>%
    rvest::html_attr("src") %>% 
    sort()

  in_img <- team_df %>%
    dplyr::select(team_conf, team_division, logo = team_logo_espn) %>% 
    dplyr::distinct() %>%
    dplyr::pull(logo) %>% 
    sort()

  expect_equal(out_img, in_img)

})
