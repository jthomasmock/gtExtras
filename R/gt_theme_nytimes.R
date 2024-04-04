#' Apply NY Times theme to a `gt` table
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param ... Optional additional arguments to `gt::table_options()`
#' @return An object of class `gt_tbl`.
#' @export
#' @examples
#'
#' library(gt)
#' nyt_tab <- head(mtcars) %>%
#'   gt() %>%
#'   gt_theme_nytimes() %>%
#'   tab_header(title = "Table styled like the NY Times")
#'
#' @section Figures:
#' \if{html}{\figure{gt_nyt.png}{options: width=100\%}}
#'
#' @family Themes
#' @section Function ID:
#' 1-3

gt_theme_nytimes <- function(gt_object, ...) {
  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))

  gt_object %>%
    tab_options(
      heading.align = "left",
      column_labels.border.top.style = "none",
      table.border.top.style = "none",
      column_labels.border.bottom.style = "none",
      column_labels.border.bottom.width = 1,
      column_labels.border.bottom.color = "#334422",
      table_body.border.top.style = "none",
      table_body.border.bottom.color = "white",
      heading.border.bottom.style = "none",
      data_row.padding = px(7),
      column_labels.font.size = px(12),
      ...
    ) %>%
    tab_style(
      style = cell_text(
        color = "darkgrey",
        font = google_font("Source Sans Pro"),
        transform = "uppercase"
      ),
      locations = list(
        gt::cells_column_labels(),
        gt::cells_stubhead()
      )
    ) %>%
    tab_style(
      style = cell_text(
        font = google_font("Libre Franklin"),
        weight = 800
      ),
      locations = cells_title(groups = "title")
    ) %>%
    tab_style(
      style = cell_text(
        font = google_font("Source Sans Pro"),
        weight = 400
      ),
      locations = cells_body()
    )
}
