#' Apply FiveThirtyEight theme to a gt table
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param ... Optional additional arguments to `gt::table_options()`
#' @return An object of class `gt_tbl`.
#' @export
#' @section Examples:
#' ```r
#' library(gt)
#' themed_tab <- head(mtcars) %>%
#'   gt() %>%
#'   gt_theme_538()
#' ```
#' @section Figures:
#' \if{html}{\figure{gt_538.png}{options: width=100\%}}
#'
#' @family Themes
#' @section Function ID:
#' 1-1


gt_theme_538 <- function(gt_object, ...) {
  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))

  gt_object %>%
    opt_all_caps() %>%
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
        sides = "bottom", color = "black", weight = px(1)
      ),
      locations = cells_row_groups()
    ) %>%
    tab_options(
      column_labels.background.color = "white",
      heading.border.bottom.style = "none",
      table.border.top.width = px(3),
      table.border.top.style = "none", # transparent
      table.border.bottom.style = "none",
      column_labels.font.weight = "normal",
      column_labels.border.top.style = "none",
      column_labels.border.bottom.width = px(2),
      column_labels.border.bottom.color = "black",
      row_group.border.top.style = "none",
      row_group.border.top.color = "black",
      row_group.border.bottom.width = px(1),
      row_group.border.bottom.color = "white",
      stub.border.color = "white",
      stub.border.width = px(0),
      data_row.padding = px(3),
      source_notes.font.size = 12,
      source_notes.border.lr.style = "none",
      table.font.size = 16,
      heading.align = "left",
      ...
    ) %>%
    opt_css(
      "tbody tr:last-child {
    border-bottom: 2px solid #ffffff00;
      }

    ",
      add = TRUE
    )
}
