#' Apply ESPN theme to a gt table
#'
#' @param gt_data An existing gt table object
#' @param ... Optional additional arguments to gt::table_options()
#' @return Returns a tibble
#' @importFrom gt %>%
#' @import scales
#' @export
#' @import gt
#' @examples
#'
#' library(gt)
#' themed_tab <- head(mtcars) %>%
#'   gt() %>%
#'   gt_theme_espn()
#' @section Figures:
#' \if{html}{\figure{gt_espn.png}{options: width=100\%}}
#'
#'@family Themes





gt_theme_espn <- function(gt_data, ...){
  gt_data %>%
    opt_all_caps()  %>%
    opt_table_font(
      font = list(
        google_font("Lato"),
        default_fonts()
      )
    )  %>%
    opt_row_striping() %>%
    tab_options(
      row.striping.background_color = "#fafafa",
      table_body.hlines.color = "#f6f7f7",
      source_notes.font.size = 12,
      table.font.size = 16,
      heading.align = "left",
      heading.title.font.size = 24,
      table.border.top.color = "#00000000",
      table.border.top.width = px(3),
      data_row.padding = px(7),
      ...
    )
}
