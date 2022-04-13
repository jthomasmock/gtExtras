#' Apply Excel-style theme to an existing gt table
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param ... Additional arguments passed to `gt::tab_options()`
#' @param color A string indicating the color of the row striping, defaults to a light gray Accepts either named colors or hex colors.
#' @return An object of class `gt_tbl`.
#' @export
#' @examples
#' library(gt)
#' themed_tab <- head(mtcars) %>%
#'   gt() %>%
#'   gt_theme_excel() %>%
#'   tab_header(title = "Styled like your old pal, Excel")
#' @section Figures:
#' \if{html}{\figure{gt_excel.png}{options: width=75\%}}
#'
#' @family Themes
#' @section Function ID:
#' 1-7

gt_theme_excel <- function(gt_object, ..., color = "lightgrey"){

  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))

  gt_object %>%
    opt_row_striping() %>%
    tab_style(
      style = cell_borders(sides = "all", weight = px(1), color = "black"),
      locations = list(
        cells_body()
      )
    ) %>%
    tab_style(
      style = cell_borders(sides = "left", weight = px(2), color = "black"),
      locations = list(
        cells_body(columns = 1),
        cells_column_labels(columns = 1),
        cells_stub()
      )
    ) %>%
    tab_style(
      style = cell_borders(sides = "left", weight = px(1), color = "black"),
      locations = list(
        cells_row_groups()
      )
    ) %>%
    tab_style(
      style = cell_borders(sides = "right", weight = px(2), color = "black"),
      locations = list(
        cells_body(columns = dplyr::last_col()),
        cells_column_labels(columns = dplyr::last_col()),
        cells_row_groups()
      )
    ) %>%
    tab_style(
      style = cell_borders(sides = "bottom", weight = px(2), color = "black"),
      locations = list(
        cells_body(rows = nrow(gt_object[["_data"]])),
        cells_stub(rows = nrow(gt_object[["_data"]]))
      )
    ) %>%
    opt_table_font(font = "Calibri") %>%
    tab_options(
      ...,
      heading.align = "left",
      heading.border.bottom.color = "black",
      column_labels.background.color = "black",
      column_labels.font.weight = "bold",
      stub.background.color = "white",
      stub.border.color = "black",
      row_group.background.color = "white",
      row_group.border.top.color = "black",
      row_group.border.bottom.color = "black",
      row_group.border.left.color = "black",
      row_group.border.right.color = "black",
      row_group.border.left.width = px(1),
      row_group.border.right.width = px(1),
      column_labels.font.size = pct(85),
      column_labels.border.top.style = "none",
      column_labels.border.bottom.color = "black",
      column_labels.border.bottom.width = px(2),
      table.border.left.color = "black",
      table.border.left.style = "solid",
      table.border.right.style = "solid",
      table.border.left.width = px(2),
      table.border.right.width = px(2),
      table.border.right.color = "black",
      table.border.bottom.width = px(2),
      table.border.bottom.color = "black",
      table.border.top.width = px(2),
      table.border.top.color = "black",
      row.striping.background_color = color,
      table_body.hlines.color = "black",
      table_body.vlines.color = "black",
      data_row.padding = px(1)
    )
}
