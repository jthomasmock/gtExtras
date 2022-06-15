#' Add color highlighting to a specific row
#' @description
#' The `gt_highlight_rows` function takes an existing `gt_tbl` object and
#' adds highlighting color to the cell background of a specific row. The function
#' accepts rows only by number (not by logical expression) for now.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param columns Specific columns to apply color to, accepts either `tidyeval` colum names or columns by position.
#' @param rows The rows to apply the highlight to. Can either by a `tidyeval` compliant statement (like `cyl == 4`), a number indicating specific row(s) to apply color to or `TRUE` to indicate all rows.
#' @param fill A character string indicating the fill color. If nothing is provided, then "#80bcd8" (light blue) will be used as a default.
#' @param alpha An optional alpha transparency value for the color as single value in the range of 0 (fully transparent) to 1 (fully opaque). If not provided the fill color will either be fully opaque or use alpha information from the color value if it is supplied in the #RRGGBBAA format.
#' @param font_weight A string or number indicating the weight of the font. Can be a text-based keyword such as "normal", "bold", "lighter", "bolder", or, a numeric value between 1 and 1000, inclusive. Note that only variable fonts may support the numeric mapping of weight.
#' @param bold_target_only A logical of TRUE/FALSE indicating whether to apply bold to only the specific `target_col`. You must indicate a specific column with `target_col`.
#' @param target_col A specific `tidyeval` column to apply bold text to, which allows for normal weight text for the remaining highlighted columns.
#' @return An object of class `gt_tbl`.
#' @export
#' @section Examples:
#' ```r
#' library(gt)
#' basic_use <- head(mtcars[,1:5]) %>%
#'  tibble::rownames_to_column("car") %>%
#'    gt() %>%
#'    gt_highlight_rows(rows = 2, font_weight = "normal")
#'
#' target_bold_column <- head(mtcars[,1:5]) %>%
#'    tibble::rownames_to_column("car") %>%
#'    gt() %>%
#'    gt_highlight_rows(
#'      rows = 5,
#'      fill = "lightgrey",
#'      bold_target_only = TRUE,
#'      target_col = car
#'    )
#' ```
#' @section Figures:
#' \if{html}{\figure{highlight-basic.png}{options: width=70\%}}
#' \if{html}{\figure{highlight-target.png}{options: width=70\%}}
#'
#' @family Utilities
#' @section Function ID:
#' 2-10

gt_highlight_rows <- function(
  gt_object, columns = gt::everything(), rows = TRUE, fill = "#80bcd8",
  alpha = 0.8, font_weight = "bold", bold_target_only = FALSE, target_col = c()){

  stopifnot("Table must be of class 'gt_tbl'" = "gt_tbl" %in% class(gt_object))

  if(isTRUE(bold_target_only)){
    gt_object %>%
      tab_style(
        style = cell_fill(color = fill, alpha = alpha),
        locations =
          cells_body(
            columns = {{ columns }},
            rows = {{ rows }}
            )
      ) %>%
      tab_style(
        style = list(
          cell_text(weight = font_weight)
        ),
        locations = cells_body(
          columns = {{ target_col }},
          rows = {{ rows }}
        )
      )
  } else{
    gt_object %>%
      tab_style(
        style = list(
          cell_fill(color = fill, alpha = alpha),
          cell_text(weight = font_weight)
        ),
        locations = cells_body(
          columns = {{ columns }},
          rows = {{ rows }}
        )
      )
  }

}
