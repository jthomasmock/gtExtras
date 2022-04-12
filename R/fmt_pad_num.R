#' Format numeric columns to align at decimal point without trailing zeroes
#'
#' @description
#' This function removes repeating trailing zeroes and adds blank white space
#' to align at the decimal point. This requires the use of true monospaced fonts,
#' which are supplied via the `gt::google_font()` function. This is a wrapper
#' around `gt::fmt()` and `gtExtras::pad_fn()`.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param columns The columns to format. Can either be a series of column names provided in `c()`, a vector of column indices, or a helper function focused on selections. The select helper functions are: `starts_with()`, `ends_with()`, `contains()`, `matches()`, `one_of()`, `num_range()`, and `everything()`.
#' @param nsmall The max number of decimal places to round at/display
#' @param gfont The complete name of a font available in Google Fonts. For the `fmt_pad_num` function this requires a monospaced font, where Google has many available at [fonts.google.com](https://fonts.google.com/?category=Monospace&preview.text=1234567890&preview.text_type=custom)
#' @return An object of class `gt_tbl`.
#' @export
#' @seealso [gtExtras::pad_fn()]
#' @examples
#' library(gt)
#' padded_tab <- data.frame(numbers = c(1.2345, 12.345, 123.45, 1234.5, 12345)) %>%
#'   gt() %>%
#'   fmt_pad_num(columns = numbers, nsmall = 4)
#' @section Figures:
#' \if{html}{\figure{fmt_pad_num.png}{options: width=20\%}}
#'
#' @family Utilities
#' @section Function ID:
#' 2-2

fmt_pad_num <- function(gt_object, columns, nsmall = 2, gfont = "Fira Mono") {
  stopifnot("Table must be of class 'gt_tbl'" = "gt_tbl" %in% class(gt_object))
  gt_object %>%
    fmt(
      columns = {{ columns }},
      fns = function(x) {pad_fn(x, nsmall = nsmall)}
    ) %>%
    tab_style(
      style = cell_text(font = c(google_font(gfont), default_fonts())),
      locations = cells_body(columns = {{ columns }})
    )
}

