
#' Add HTML-based bar plots into rows of a `gt` table
#' @description
#' The `gt_plt_bar_pct` function takes an existing `gt_tbl` object and
#' adds horizontal barplots via native HTML. This is a wrapper around raw HTML
#' strings, `gt::text_transform()` and `gt::cols_align()`. Note that values
#' default to being normalized to the percent of the maximum observed value
#' in the specified column. You can turn this off if the values already
#' represent a percentage value representing 0-100.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column wherein the bar plot should replace existing data.
#' @param height A number representing the vertical height of the plot in pixels. Defaults to 16 px.
#' @param fill A character representing the fill for the bar, defaults to purple. Accepts a named color (eg 'purple') or a hex color.
#' @param background A character representing the background filling out the 100% mark of the bar, defaults to light grey. Accepts a named color (eg 'white') or a hex color.
#' @param scaled `TRUE`/`FALSE` logical indicating if the value is already scaled to a percent of max (`TRUE`) or if it needs to be scaled (`FALSE`). Defaults to `FALSE`, meaning the value will be divided by the max value in that column and then multiplied by 100.
#' @return An object of class `gt_tbl`.
#' @export
#' @examples
#' library(gt)
#'  gt_bar_plot_tab <- mtcars %>%
#'    head() %>%
#'    dplyr::select(cyl, mpg) %>%
#'    dplyr::mutate(mpg_pct_max = round(mpg/max(mpg) * 100, digits = 2),
#'                  mpg_scaled = mpg/max(mpg) * 100) %>%
#'    dplyr::mutate(mpg_unscaled = mpg) %>%
#'    gt() %>%
#'    gt_plt_bar_pct(column = mpg_scaled, scaled = TRUE) %>%
#'    gt_plt_bar_pct(column = mpg_unscaled, scaled = FALSE,
#'                   fill = "blue", background = "lightblue") %>%
#'    cols_align("center", contains("scale")) %>%
#'    cols_width(4 ~ px(125),
#'               5 ~ px(125))
#'
#' @section Figures:
#' \if{html}{\figure{gt_bar_plot.png}{options: width=100\%}}
#'
#' @family Plotting
#' @section Function ID:
#' 3-5

gt_plt_bar_pct <- function(gt_object, column, height = 16, fill = "purple",
                           background = "#e1e1e1", scaled = FALSE) {

  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))

  # convert tidyeval column to bare string
  col_bare <- rlang::enexpr(column) %>% rlang::as_string()
  # segment data with bare string column name
  data_in <- gt_index(gt_object, column = {{ column }})

  col_number <- which(colnames(gt_object[["_data"]]) == col_bare)

  gt_object %>%
    text_transform(
      locations = cells_body(columns = {{ column }}),
      fn = function(x) {
        max_x <- max(as.double(x), na.rm = TRUE)
        bar <- lapply(data_in, function(x) {

          scaled_value <- if(isFALSE(scaled)){x/max_x*100} else {x}

          glue::glue(
            "<div style='background:{fill};width:{scaled_value}%;height:{height}px;'></div>"
          )
        })

        chart <- lapply(bar, function(bar) {
          glue::glue(
            "<div style='flex-grow:1;margin-left:8px;background:{background};'>{bar}</div>"
          )
        })

        chart
      }
    ) %>%
    cols_align(align = "left", columns = {{ column }})
}
