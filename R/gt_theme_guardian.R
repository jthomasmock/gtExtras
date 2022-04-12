#' Apply Guardian theme to a `gt` table
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param ... Optional additional arguments to `gt::table_options()`
#' @return An object of class `gt_tbl`.
#' @export
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

  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))

  tab_out <- gt_object %>%
    opt_table_font(
      font = list(
        google_font("Noto Sans"),
        default_fonts()
      )
    ) %>%
    tab_style(
      style = cell_borders(
        sides = "top", color = "white", weight = px(0)
      ),
      locations = cells_body(rows = ifelse(nrow(gt_object[["_data"]])> 0, 1, NA))
    ) %>%
    tab_style(
      style = cell_text(color = "#005689", size = px(22), weight = 700),
      locations = list(cells_title(groups = "title")
      )
    ) %>%
    tab_style(
      style = cell_text(color = "#005689", size = px(16), weight = 700),
      locations = list(cells_title(groups = "subtitle")
      )
    )

  tab_out <- tab_out %>%
    tab_options(
      row.striping.include_table_body = TRUE,
      table.background.color = "#f6f6f6",
      row.striping.background_color = "#ececec",
      column_labels.background.color = "#f6f6f6",
      column_labels.font.weight = "bold",
      table.border.top.width = px(1),
      table.border.top.color = "#40c5ff",
      table.border.bottom.width = px(3),
      table.border.bottom.color = "white",
      footnotes.border.bottom.width = px(0),
      source_notes.border.bottom.width = px(0),
      table_body.border.bottom.width = px(3),
      table_body.border.bottom.color = "white",
      table_body.hlines.width = "white",
      table_body.hlines.color = "white",
      row_group.border.top.width = px(1),
      row_group.border.top.color = "grey",
      row_group.border.bottom.width = px(1),
      row_group.border.bottom.color = "grey",
      row_group.font.weight = "bold",
      column_labels.border.top.width = px(1),
      column_labels.border.top.color = if(
        is.null(tab_out[["_heading"]][["title"]])){
        "#40c5ff"
      } else {"#ececec"},
      column_labels.border.bottom.width = px(2),
      column_labels.border.bottom.color = "#ececec",
      heading.border.bottom.width = px(0),
      data_row.padding = px(4),
      source_notes.font.size = 12,
      table.font.size = 16,
      heading.align = "left",
      ...
    )

  tab_out
}
