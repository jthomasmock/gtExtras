#' Apply FiveThirtyEight theme to a gt table
#'
#' @param gt_data An existing gt table object
#' @param ... Optional additional arguments to gt::table_options()
#' @return Returns a tibble
#' @importFrom gt %>%
#' @export
#' @import gt
#' @examples
#'
#' library(gt)
#' themed_tab <- head(mtcars) %>%
#'   gt() %>%
#'   gt_theme_espn()
#' @section Figures:
#' \if{html}{\figure{gt_538.png}{options: width=100\%}}
#'
#' @family Themes
#' @section Function ID:
#' 1-1


gt_theme_538 <- function(gt_data,...) {
  gt_data %>%
    opt_all_caps()  %>%
    opt_table_font(
      font = list(
        google_font("Chivo"),
        default_fonts()
      )
    ) %>%
    tab_style(
      style = cell_borders(
        sides = "bottom", color = "#00000000", weight = px(2)
      ),
      locations = cells_body(
        columns = everything(),
        # This is a relatively sneaky way of changing the bottom border
        # Regardless of data size
        rows = nrow(data$`_data`)
      )
    )  %>%
    tab_options(
      column_labels.background.color = "white",
      table.border.top.width = px(3),
      table.border.top.color = "#00000000",
      table.border.bottom.color = "#00000000",
      table.border.bottom.width = px(3),
      column_labels.border.top.width = px(3),
      column_labels.border.top.color = "#00000000",
      column_labels.border.bottom.width = px(3),
      column_labels.border.bottom.color = "black",
      data_row.padding = px(3),
      source_notes.font.size = 12,
      table.font.size = 16,
      heading.align = "left",
      ...
    )
}
