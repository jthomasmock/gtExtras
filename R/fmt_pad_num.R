#' Format numeric columns to align at decimal point without trailing zeroes
#'
#' @description
#' This function removes repeating trailing zeroes and adds blank white space
#' to align at the decimal point.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param columns The columns to format. Can either be a series of column names provided in `c()`, a vector of column indices, or a helper function focused on selections. The select helper functions are: `starts_with()`, `ends_with()`, `contains()`, `matches()`, `one_of()`, `num_range()`, and `everything()`.
#' @param nsmall The max number of decimal places to round at/display
#' @param sep A character for the separator, typically `"."` or `","`
#' @param pad0 A logical, indicating whether to pad the values with trailing zeros.
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

fmt_pad_num <- function(gt_object, columns, sep = ".", nsmall = 2, pad0 = FALSE) {
  stopifnot("Table must be of class 'gt_tbl'" = "gt_tbl" %in% class(gt_object))


  gt_object %>%
    gt::fmt(
      columns = {{ columns }},
      fns = function(x) {
        padded_vals <- pad_fn(x, nsmall = nsmall, pad0 = pad0)
        split_vals <- strsplit(x = padded_vals, split = sep, fixed = TRUE)

        max_int <- max(nchar(split_vals[[1]]))
        max_dec <- max(nchar(split_vals[[2]]))

        create_spans <- function(vals) {
          int_prefix <- vals[[1]]
          dec_suffix <- ifelse(length(vals) == 2, vals[[2]], "")


          html_string <- glue::glue(
            '<div><span style=" display:inline-block; text-align:right; width:{max_int}ch"> {int_prefix} </span>',
            "{sep}",
            '<span style=" display:inline-block; text-align:left; width:{max_dec}ch"> {dec_suffix} </span></div>'
          )
        }

        lapply(split_vals, create_spans)
      }
    )
}
