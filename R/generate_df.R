#' Generate pseudorandom dataframes with specific parameters
#' @description This function is a small utility to create a specific length dataframe
#' with a set number of groups, specific mean/sd per group. Note that the total length
#' of the dataframe will be `n` * `n_grps`.
#' @param n An integer indicating the number of rows per group, default to `10`
#' @param n_grps An integer indicating the number of rows per group, defaults to `1`
#' @param mean A number indicating the mean of the randomly generated values, must be a vector of equal length to the `n_grps`
#' @param sd A number indicating the standard deviation of the randomly generated values, must be a vector of equal length to the `n_grps`
#' @param with_seed A seed to make the randomization reproducible
#' @return a tibble/dataframe
#' @export
#'
#' @examples
#' library(dplyr)
#' generate_df(
#'   100L,
#'   n_grps = 5,
#'   mean = seq(10, 50, length.out = 5)
#' ) %>%
#'   group_by(grp) %>%
#'   summarise(
#'     mean = mean(values), # mean is approx mean
#'     sd = sd(values), # sd is approx sd
#'     n = n(), # each grp is of length n
#'     # showing that the sd default of mean/10 works
#'     `mean/sd` = round(mean / sd, 1)
#'   )
#' @family Utilities
#' @section Function ID:
#' 2-19
generate_df <- function(n = 10L, n_grps = 1L, mean = c(10), sd = mean / 10,
                        with_seed = NULL) {
  # If a seed is specified, then use it, otherwise ignore
  if (!base::is.null(with_seed)) {
    base::set.seed(with_seed)
  }

  stopifnot("'n' must be an integer of length 1, ie '10', not 'c(10, 20)'" = base::length(n) == 1)
  stopifnot("'n' must be an integer" = base::all.equal(n, base::as.integer(n)))
  stopifnot("'n_grps' must be an integer" = base::all.equal(n_grps, base::as.integer(n_grps)))
  stopifnot("'n_grps' must be equal to the number of values in 'mean'" = base::length(mean) == n_grps)
  stopifnot("'n_grps' must be equal to the number of values in 'sd'" = base::length(sd) == n_grps)
  stopifnot("Number of values in 'sd' must be equal to number of values in 'mean'" = base::length(mean) == length(sd))

  # pad the values with repeated zeros
  pad_length <- base::paste0("%0", nchar(n), "d")
  random_int <- base::sample(1:n, replace = TRUE)
  padded_int <- base::sprintf(pad_length, random_int)

  my_rnorm <- function(n, mean, sd) {
    stats::rnorm(n = n, mean = mean, sd = sd)
  }

  # create a df with combined random letters and integers
  dplyr::tibble(
    row_id = 1:(n * n_grps),
    id = base::paste0(base::sample(LETTERS, n * n_grps, replace = TRUE), padded_int),
    grp = base::sprintf("grp-%s", 1:n_grps) %>% rep(each = n),
    values = base::mapply(my_rnorm, n, mean, sd) %>% base::as.vector()
  )
}
