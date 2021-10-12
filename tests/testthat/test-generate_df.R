test_df <- generate_df(
  100L,
  n_grps = 5,
  mean = seq(10, 50, length.out = 5),
  with_seed = 37
) %>%
  dplyr::group_by(grp) %>%
  dplyr::summarise(
    mean = mean(values), # mean is approx mean
    sd = sd(values),     # sd is approx sd
    n = n(),             # each grp is of length n
    # showing that the sd default of mean/10 works
    `mean/sd` = round(mean / sd, 1)
  )


test_that("generate_df w/ n = 100", {
  expect_equal(test_df$n, rep(100, 5))
})

test_that("generate_df w/ n = 100", {
  expect_equal(round(test_df$mean, digits = 3), c(9.946, 20.156, 29.993, 39.361, 50.453))
})

test_that("Text ID in generate_df is equal length to N", {

  expect_equal(nchar(generate_df(10)$id), rep(3, 10))
  expect_equal(nchar(generate_df(100)$id), rep(4, 100))
  expect_equal(nchar(generate_df(1000)$id), rep(5, 1000))

})

