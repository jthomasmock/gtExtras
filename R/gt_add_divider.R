#' Add a dividing border to an existing `gt` table.
#' @description
#' The `gt_add_divider` function takes an existing `gt_tbl` object and
#' adds borders or dividers to specific columns.
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param columns Specific columns to apply color to, accepts either `tidyeval` colum names or columns by position.
#' @param sides The border sides to be modified. Options include `"left"`, `"right"`, `"top"`, and `"bottom"`. For all borders surrounding the selected cells, we can use the `"all"`` option.
#' @param color,style,weight The border color, style, and weight. The `color` can be defined with a color name or with a hexadecimal color code. The default `color` value is `"#00FFFFFF"` (black). The `style` can be one of either `"solid"` (the default), `"dashed"`, or `"dotted"`. The `weight` of the border lines is to be given in pixel values (the `px()` helper function is useful for this. The default value for `weight` is `"1px"`.
#' @param include_labels A logical, either `TRUE` or `FALSE` indicating whether to also add dividers through the column labels.
#' @return An object of class `gt_tbl`.
#' @export
#' @examples
#' library(gt)
#' basic_divider <- head(mtcars) %>%
#'   gt() %>%
#'   gt_add_divider(columns = "cyl", style = "dashed")
#'
#'
#' @section Figures:
#' \if{html}{\figure{add-divider.png}{options: width=70\%}}
#'
#' @family Utilities
#' @section Function ID:
#' 2-11

gt_add_divider <- function(gt_object, columns, sides = "right", color = "grey",
                           style = "solid", weight = px(2), include_labels = TRUE){

  stopifnot("Table must be of class 'gt_tbl'" = "gt_tbl" %in% class(gt_object))

  if(isTRUE(include_labels)){
    gt_object %>%
      tab_style(
        style = cell_borders(
          sides = sides,
          style = style,
          color = color,
          weight = weight
        ),
        locations = list(
          cells_body(columns = {{ columns }}),
          cells_column_labels(columns = {{ columns }})
          )
      )
  } else {
    gt_object %>%
      tab_style(
        style = cell_borders(
          sides = sides,
          style = style,
          color = color,
          weight = weight
        ),
        locations = cells_body(columns = {{ columns }})
      )
  }

}
