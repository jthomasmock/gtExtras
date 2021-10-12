save_theme <- function(gt_code){
  path <- tempfile(fileext = ".html")
  gt_code %>%
    gtsave(path)
}

head(mtcars) %>% gt() %>% gt_theme_nytimes() %>%
  save_theme()

test_that("NYTimes snapshot", {
  expect_snapshot_file(save_theme(head(mtcars) %>% gt() %>% gt_theme_nytimes()), "nytimes.html")
})

snapshot_review()
