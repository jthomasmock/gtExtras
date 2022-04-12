#' Apply dark theme to a `gt` table
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param ... Optional additional arguments to `gt::table_options()`
#' @return An object of class `gt_tbl`.
#' @export
#' @examples
#'
#' library(gt)
#' dark_tab <- head(mtcars) %>%
#'   gt() %>%
#'   gt_theme_dark() %>%
#'   tab_header(title = "Dark mode table")
#'
#' @section Figures:
#' \if{html}{\figure{gt_dark.png}{options: width=100\%}}
#'
#' @family Themes
#' @section Function ID:
#' 1-6

gt_theme_dark <- function(gt_object, ...){

  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))

  gt_object %>%
    tab_options(
      heading.align = "left",
      table.background.color = "#333333",
      column_labels.background.color = "#333333",
      table.font.color.light = "white",
      column_labels.border.top.style = "none",
      table.border.top.style = "none",
      table.border.bottom.color = "#333333",
      column_labels.border.bottom.width = 3,
      column_labels.border.bottom.color = "white",
      table_body.border.top.style = "none",
      table_body.border.bottom.color = "#333333",
      table.border.left.color = "#333333",
      table.border.right.color = "#333333",
      heading.border.bottom.style = "none",
      data_row.padding = px(7),
      ...
    ) %>%
    tab_style(
      style = cell_text(
        size = px(12),
        color = "white",
        font = google_font("Source Sans Pro"),
        transform = "uppercase"
      ),
      locations = cells_column_labels(everything())
    )  %>%
    tab_style(
      style = cell_text(font = google_font("Libre Franklin"),
                        weight = 800),
      locations = cells_title(groups = "title")
    ) %>%
    tab_style(
      style = cell_text(
        font = google_font("Source Sans Pro"),
        weight =  400
      ),
      locations = cells_body()
    )

}

