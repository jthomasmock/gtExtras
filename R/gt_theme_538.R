#' Apply FiveThirtyEight theme to a gt table
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param ... Optional additional arguments to `gt::table_options()`
#' @return An object of class `gt_tbl`.
#' @importFrom gt %>%
#' @export
#' @import gt
#' @examples
#'
#' library(gt)
#' themed_tab <- head(mtcars) %>%
#'   gt() %>%
#'   gt_theme_538()
#' @section Figures:
#' \if{html}{\figure{gt_538.png}{options: width=100\%}}
#'
#' @family Themes
#' @section Function ID:
#' 1-1


gt_theme_538 <- function(gt_object,...) {

  stopifnot("Input must be a gt table" = "gt_tbl" %in% class(gt_object))

  gt_object %>%
    opt_all_caps()  %>%
    opt_table_font(
      font = list(
        google_font("Chivo"),
        default_fonts()
      ),
      weight = 300
    ) %>%
    tab_style(
      style = cell_borders(
        sides = "top", color = "black", weight = px(0)
      ),
      locations = gt::cells_column_labels(
        columns = gt::everything()
      )
    ) %>%
    tab_style(
      style = cell_borders(
        sides = "bottom", color = NULL, weight = px(3)
      ),
      locations = cells_body(
        columns = everything(),
        # This is a relatively sneaky way of changing the bottom border
        # Regardless of data size
        rows = nrow(gt_object[["_data"]])
      )
    ) %>%
    tab_style(
      style = cell_borders(
        sides = "bottom", color = NULL, weight = px(2)
      ),
      locations = cells_body(
        columns = everything(),
        # This is a relatively sneaky way of changing the bottom border
        # Regardless of data size
        rows = nrow(gt_object[["_data"]])
      )
    )  %>%
    tab_options(
      column_labels.background.color = "white",
      heading.border.bottom.style = "none",
      table.border.top.width = px(3),
      table.border.top.style = "none", #transparent
      table.border.bottom.style = "none",
      column_labels.font.weight = "normal",
      column_labels.border.top.style = "none",
      column_labels.border.bottom.width = px(2),
      column_labels.border.bottom.color = "black",
      row_group.border.top.style = "none",
      row_group.border.top.color = "black",
      row_group.border.bottom.width = px(1),
      row_group.border.bottom.color = "black",
      data_row.padding = px(3),
      source_notes.font.size = 12,
      source_notes.border.lr.style = "none",
      table.font.size = 16,
      heading.align = "left",
      ...
    )
}
