#' Count number of decimals
#'
#' @param x A value to count decimals from
#'
#' @return an integer
#' @export
#'
n_decimals <- function(x) {
  # adapted from: https://stackoverflow.com/questions/5173692/how-to-return-number-of-decimal-places-in-r
  if (abs(x - round(x)) > .Machine$double.eps^0.5) {
    x <- format(x, drop0trailing = TRUE)
    nchar(strsplit(x, ".", fixed = TRUE)[[1]][[2]])
    # nchar(strsplit(sub('0+$', '', as.character(x)), ".", fixed = TRUE)[[1]][[2]])
  } else {
    return(0)
  }
}
