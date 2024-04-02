#' Apply FiveThirtyEight theme to a gt table
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param ... Optional additional arguments to `gt::table_options()`
#' @param quiet A logical to silence the warning about missing ID
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


gt_theme_538 <- function(gt_object, ..., quiet = FALSE) {
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
    opt_table_font(
      font = list(
        google_font("Cairo"),
        default_fonts()
      ),
      weight = 400
    ) %>%
    tab_style(
      locations = cells_title("title"),
      style = cell_text(
        font = google_font("Chivo"),
        weight = 700
      )
    ) %>%
    tab_style(
      locations = cells_title("subtitle"),
      style = cell_text(
        font = google_font("Chivo"),
        weight = 300
      )
    ) %>%
    tab_style(
      style = list(
        cell_borders(
          sides = "top", color = "black", weight = px(0)
        ),
        cell_text(
          font = google_font("Chivo"),
          transform = "uppercase",
          v_align = "bottom",
          size = px(14),
          weight = 200
        )
      ),
      locations = list(
        gt::cells_column_labels(),
        gt::cells_stubhead()
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
      data_row.padding = px(3),
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
      source_notes.font.size = 12,
      source_notes.border.lr.style = "none",
      table.font.size = 16,
      heading.align = "left",
      ...
    ) %>%
    opt_css(
      paste0("#", table_id, " tbody tr:last-child {border-bottom: 2px solid #ffffff00;}"),
      add = TRUE
    )
}
