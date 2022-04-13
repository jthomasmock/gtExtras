#' Pad a vector of numbers to align on the decimal point.
#' @description
#' This helper function adds whitespace to numeric values so that they can
#' be aligned on the decimal without requiring additional trailing zeroes.
#' This function is intended to use within the `gt::fmt()` function.
#' @param x A vector of numbers to pad/align at the decimal point
#' @param nsmall The max number of decimal places to round at/display
#' @return Returns a vector of equal length to the input vector
#' @export
#' @examples
#'
#' library(gt)
#' padded_tab <- data.frame(x = c(1.2345, 12.345, 123.45, 1234.5, 12345)) %>%
#'   gt() %>%
#'   fmt(fns = function(x){pad_fn(x, nsmall = 4)}) %>%
#'   tab_style(
#'     # MUST USE A MONO-SPACED FONT
#'     # https://fonts.google.com/?category=Monospace
#'     style = cell_text(font = google_font("Fira Mono")),
#'     locations = cells_body(columns = x)
#'     )
#'
#' @section Figures:
#' \if{html}{\figure{gt_pad_fn.png}{options: width=20\%}}
#'
#' @family Utilities
#' @section Function ID:
#' 2-3


pad_fn <- function(x, nsmall = 2){

  # round and format values as text with specific number of decimals
  round_x <- round(x, digits = nsmall)
  fmt_x <- format(round_x, nsmall = nsmall)

  # calc number of trailing zeros
  nbsp_len <- nchar(fmt_x) - nchar(sub("0*$", "", fmt_x))

  # create string of non-breaking spaces
  rep_nbsp <- strrep("&nbsp", nbsp_len)

  # remove traililng zeros by position
  fmt_out <- substr(fmt_x, 1, nchar(fmt_x) - nbsp_len)

  # add the non-breaking spaces to the formatted values
  filled_out <- paste0(fmt_out, rep_nbsp)

  filled_out

}
