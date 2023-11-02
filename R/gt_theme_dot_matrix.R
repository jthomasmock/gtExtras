#' Apply dot matrix theme to a gt table
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param ... Additional arguments passed to `gt::tab_options()`
#' @param color A string indicating the color of the row striping, defaults to a light green. Accepts either named colors or hex colors.
#' @param quiet A logical to silence the warning about missing ID
#' @return An object of class `gt_tbl`.
#' @export
#' @section Examples:
#' ```r
#' library(gt)
#' themed_tab <- head(mtcars) %>%
#'   gt() %>%
#'   gt_theme_dot_matrix() %>%
#'   tab_header(title = "Styled like dot matrix printer paper")
#' ```
#' @section Figures:
#' \if{html}{\figure{gt_dot_matrix.png}{options: width=100\%}}
#'
#' @family Themes

gt_theme_dot_matrix <- function(gt_object, ..., color = "#b5dbb6", quiet = FALSE) {
  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))

  table_id <- subset(gt_object[['_options']], parameter == 'table_id')[["value"]][[1]]

  if(is.na(table_id)){
    table_id <- gt::random_id()
    if(isFALSE(quiet)){
      message(glue::glue(
        "Table has no assigned ID, using random ID '{table_id}' to apply `gt::opt_css()`",
        "\nAvoid this message by assigning an ID: `gt(id = '')` or `gt_theme_538(quiet = TRUE)`"
      ))
    }

    opt_position <- which("table_id" %in% gt_object[["_options"]][["parameter"]])[[1]]
    gt_object[["_options"]][["value"]][[opt_position]] <- table_id
  }

  gt_object %>%
    opt_row_striping() %>%
    opt_table_font(font = "Courier") %>%
    tab_options(
      ...,
      heading.align = "left",
      heading.border.bottom.color = "white",
      column_labels.text_transform = "lowercase",
      column_labels.font.size = pct(85),
      column_labels.border.top.style = "none",
      column_labels.border.bottom.color = "black",
      column_labels.border.bottom.width = px(2),
      table.border.bottom.style = "none",
      table.border.bottom.width = px(2),
      table.border.bottom.color = "white",
      table.border.top.style = "none",
      row.striping.background_color = color,
      table_body.hlines.style = "none",
      table_body.vlines.style = "none",
      data_row.padding = px(1)
    ) %>%
    opt_css(
      paste0("#", table_id, " tbody tr:last-child {border-bottom: 2px solid #ffffff00;}"),
      add = TRUE
    )
}
