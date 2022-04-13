#' Add color highlighting to a specific column(s)
#' @description
#' The `gt_highlight_cols` function takes an existing `gt_tbl` object and
#' adds highlighting color to the cell background of a specific column(s).
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param columns Specific columns to apply color to, accepts either `tidyeval` colum names or columns by position.
#' @param fill A character string indicating the fill color. If nothing is provided, then "#80bcd8" (light blue) will be used as a default.
#' @param alpha An optional alpha transparency value for the color as single value in the range of 0 (fully transparent) to 1 (fully opaque). If not provided the fill color will either be fully opaque or use alpha information from the color value if it is supplied in the #RRGGBBAA format.
#' @param font_weight A string or number indicating the weight of the font. Can be a text-based keyword such as "normal", "bold", "lighter", "bolder", or, a numeric value between 1 and 1000, inclusive. Note that only variable fonts may support the numeric mapping of weight.
#' @return An object of class `gt_tbl`.
#' @export
#' @examples
#' library(gt)
#' basic_col <- head(mtcars) %>%
#'   gt() %>%
#'   gt_highlight_cols(cyl, fill = "red", alpha = 0.5)
#'
#' @section Figures:
#' \if{html}{\figure{highlight-col.png}{options: width=70\%}}
#'
#' @family Utilities
#' @section Function ID:
#' 2-9
#'
#'

gt_highlight_cols <- function(gt_object, columns, fill = "#80bcd8", alpha = 1,
                              font_weight = "normal"){
  stopifnot("Table must be of class 'gt_tbl'" = "gt_tbl" %in% class(gt_object))
    gt_object %>%
      tab_style(
        style = list(
          cell_fill(color = fill, alpha = alpha),
          cell_text(weight = font_weight)
        ),
        locations = cells_body(
          columns = {{ columns }},
          rows = TRUE
        )
      )
  }

