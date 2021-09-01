#' Aligning first-row text only
#' @description
#' This is an experimental function that allows you to apply a suffix/symbol
#' to only the first row of a table, and maintain the alignment with whitespace
#' in the remaining rows.
#' @param gt_data An existing gt table object
#' @param column columns to apply color to with tidyeval
#' @param symbol The HTML code or raw character string of the symbol being inserted, optionally
#' @param suffix a suffix to add, optionally
#' @param decimals the number of decimal places to round to
#' @param last_row_n defining the last row to apply this to
#' @param symbol_first TRUE/FALSE - symbol before after suffix.
#' @return Returns a gt table
#' @importFrom gt %>%
#' @export
#' @import gt
#' @examples
#' library(gt)
#' fmted_tab <- gtcars %>%
#'   head() %>%
#'   dplyr::select(mfr, year, bdy_style, mpg_h, hp) %>%
#'   dplyr::mutate(mpg_h = rnorm(n = dplyr::n(), mean = 22, sd = 1)) %>%
#'   gt::gt() %>%
#'   gt::opt_table_lines() %>%
#'   fmt_symbol_first(column = mfr, symbol = "&#x24;", suffix = " ", last_row_n = 6) %>%
#'   fmt_symbol_first(column = year, symbol = NULL, suffix = "%", last_row_n = 6) %>%
#'   fmt_symbol_first(column = mpg_h, symbol = "&#37;", suffix = NULL, last_row_n = 6, decimals = 1) %>%
#'   fmt_symbol_first(column = hp, symbol = "&#176;", suffix = "F", last_row_n = 6, decimals = NULL, symbol_first = TRUE)
#'
#' @section Figures:
#' \if{html}{\figure{gt_fmt_first.png}{options: width=100\%}}
#'
#' @family Utilities
#' @section Function ID:
#' 3-1


fmt_symbol_first <- function(
  gt_data,
  column = NULL,        # column of interest to apply to
  symbol = NULL,        # symbol to add, optionally
  suffix = "",          # suffix to add, optionally
  decimals = NULL,      # number of decimal places to round to
  last_row_n,           # what's the last row in data?
  symbol_first = FALSE  # symbol before or after suffix?
) {

  # Test and error out if mandatory columns are missing
  stopifnot("`symbol_first` argument must be a logical" = is.logical(symbol_first))
  stopifnot("`last_row_n` argument must be specified and numeric" = is.numeric(last_row_n))
  stopifnot("Input must be a gt table" = class(gt_data)[[1]] == "gt_tbl")

  # needs to type convert to double to play nicely with decimals and rounding
  # as it's converted to character by gt::text_transform
  add_to_first <- function(x, suff = suffix, symb = symbol) {
    if (!is.null(decimals)) {
      x <- suppressWarnings(as.double(x))
      fmt_val <- format(x = x, nsmall = decimals, digits = decimals)
    } else {
      fmt_val <- x
    }

    # combine the value, passed suffix, symbol -> html
    if (isTRUE(symbol_first)) {
      paste0(fmt_val, symb, suff) %>% gt::html()
    } else {
      paste0(fmt_val, suff, symb) %>% gt::html()
    }
  }

  # repeat non-breaking space for combined length of suffix + symbol
  # logic is based on is a NULL passed or not
  if (!is.null(symbol) | !identical(as.character(symbol), character(0))) {
    suffix <- ifelse(identical(as.character(suffix), character(0)), "", suffix)
    length_nbsp <- c("&nbsp", rep("&nbsp", nchar(suffix))) %>%
      paste0(collapse = "")
  } else {
    suffix <- ifelse(identical(as.character(suffix), character(0)), "", suffix)
    length_nbsp <- rep("&nbsp", nchar(suffix)) %>%
      paste0(collapse = "")
  }

  # affect rows OTHER than the first row
  add_to_remainder <- function(x, length = length_nbsp) {
    if (!is.null(decimals)) {
      # if decimal not null, convert to double
      x <- suppressWarnings(as.double(x))
      # then round and format ALL to force specific decimals
      fmt_val <- format(x = x, nsmall = decimals, digits = decimals)
    } else {
      fmt_val <- x
    }
    paste0(fmt_val, length) %>% lapply(FUN = gt::html)
  }

  # pass gt object
  # align right to make sure the spacing is meaningful
  gt_data %>%
    cols_align(align = "right", columns = c({{ column }})) %>%
    # convert to mono-font for column of interest
    tab_style(
      style = cell_text(font = google_font("Fira Mono")),
      locations = cells_body(columns = c({{ column }}))
    ) %>%
    # transform first rows
    text_transform(
      locations = cells_body(c({{ column }}), rows = 1),
      fn = add_to_first
    ) %>%
    # transform remaining rows
    text_transform(
      locations = cells_body(c({{ column }}), rows = 2:last_row_n),
      fn = add_to_remainder
    )
}
