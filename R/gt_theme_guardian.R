#' Apply Guardian theme to a `gt` table
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
#'   gt_theme_guardian()
#' @section Figures:
#' \if{html}{\figure{gt_guardian.png}{options: width=100\%}}
#'
#' @family Themes
#' @section Function ID:
#' 1-4

gt_theme_guardian <- function(gt_object,...) {

  stopifnot("Input must be a gt table" = "gt_tbl" %in% class(gt_object))

  gt_object %>%
    opt_table_font(
      font = list(
        google_font("Noto Sans"),
        default_fonts()
      )
    ) %>%
    tab_style(
      style = cell_borders(
        sides = "top", color = "red", weight = px(0)
      ),
      locations = cells_body(rows = 1)
    ) %>%
    tab_options(
      row.striping.include_table_body = TRUE,
      table.background.color = "#f6f6f6",
      row.striping.background_color = "#ececec",
      column_labels.background.color = "#f6f6f6",
      column_labels.font.weight = "bold",
      table.border.top.width = px(3),
      table.border.top.color = "#ffffff00",
      table.border.bottom.width = px(3),
      table.border.bottom.color = "#ffffff00",
      footnotes.border.bottom.width = px(0),
      source_notes.border.bottom.width = px(0),
      table_body.border.bottom.width = px(3),
      table_body.border.bottom.color = "#ffffff00",
      table_body.hlines.width = "#ffffff00",
      table_body.hlines.color = "#ffffff00",
      row_group.border.top.width = px(1),
      row_group.border.top.color = "grey",
      row_group.border.bottom.width = px(1),
      row_group.border.bottom.color = "grey",
      row_group.font.weight = "bold",
      column_labels.border.top.width = px(1),
      column_labels.border.top.color = "#40c5ff",
      column_labels.border.bottom.width = px(2),
      column_labels.border.bottom.color = "#ececec",
      heading.border.bottom.width = px(0),
      data_row.padding = px(4),
      source_notes.font.size = 12,
      table.font.size = 16,
      heading.align = "left",
      ...
    )
}