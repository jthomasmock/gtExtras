#' Apply ESPN theme to a gt table
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
#'   gt_theme_espn()
#' @section Figures:
#' \if{html}{\figure{gt_espn.png}{options: width=100\%}}
#'
#' @family Themes
#' @section Function ID:
#' 1-2




gt_theme_espn <- function(gt_object, ...) {
  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))

  gt_object %>%
    opt_all_caps() %>%
    opt_table_font(
      font = list(
        google_font("Lato"),
        default_fonts()
      )
    ) %>%
    opt_row_striping() %>%
    tab_options(
      row.striping.background_color = "#fafafa",
      table_body.hlines.color = "#f6f7f7",
      source_notes.font.size = 12,
      table.font.size = 16,
      heading.align = "left",
      heading.title.font.size = 24,
      table.border.top.color = "white",
      table.border.top.width = px(3),
      data_row.padding = px(7),
      ...
    )
}
