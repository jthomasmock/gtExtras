
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
#' @param labels `TRUE`/`FALSE` logical representing if labels should be plotted. Defaults to `FALSE`, meaning that no value labels will be plotted.
#' @param inside_label_color A character representing the color for labels inside the bar. Defaults to 'white'.
#' @param outside_label_color A character representing the color for labels outside the bar. Defaults to 'black'.
#' @param label_value_cutoff A number, 0 to 1, representing where to set the inside/outside label boundary. Defaults to 0.50 (50%) of the column's maximum value.
#' @param digits A number representing how many decimal places to be used in label rounding. Defaults to 1.
#' @param scale_label `TRUE`/`FALSE` logical representing if the label values should be scaled by 100. Defaults to `TRUE`, meaning the values will be scaled when transformed to labels.
#' @param percent_sign `TRUE`/`FALSE` logical representing if a percent sign, `%`, should be appended to the labels. Defaults to `TRUE`.
#' @param font_style A character represening the font style of the labels. Accepts one of 'bold' (default), 'italic', or 'normal'.
#' @param font_size A character representing the font size of the labels. Defaults to '12px'.
#' @return An object of class `gt_tbl`.
#' @export
#' @section Examples:
#' ```r
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
#' ```
#' @section Figures:
#' \if{html}{\figure{gt_bar_plot.png}{options: width=100\%}}
#'
#' @family Plotting
#' @section Function ID:
#' 3-5

gt_plt_bar_pct <- function(
    gt_object,
    column,
    height = 16,
    fill = "purple",
    background = "#e1e1e1",
    scaled = FALSE,
    labels = FALSE,
    inside_label_color = "white",
    outside_label_color = "black",
    label_value_cutoff = 0.50,
    digits = 1,
    scale_label = TRUE,
    percent_sign = TRUE,
    font_style = "bold",
    font_size = "12px") {


  stopifnot(`'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?` = "gt_tbl" %in%
    class(gt_object))

  # ensure font_style is one of the accepted values
  stopifnot(font_style %in% c("bold", "normal", "italic"))

  data_in <- gt_index(gt_object, column = {{ column }})

  gt_object %>%
    text_transform(
      locations = cells_body(columns = {{ column }}),
      fn = function(x) {
        if (length(na.omit(x)) == 0) {
          return("<div></div>")
        } else {
          max_x <- max(as.double(x), na.rm = TRUE)
        }

        bar <- lapply(data_in, function(x) {
          scaled_value <- if (isFALSE(scaled)) {
            x / max_x * 100
          } else {
            x
          }

          if (labels) {
            # adjust values for labeling // scale_label
            label_values <- if (scale_label) {
              x * 100
            } else {
              x
            }

            # create label string to print out // add % sign if requested
            label <- if (percent_sign) {
              glue::glue("{round(label_values, digits)}%")
            } else {
              round(label_values, digits)
            }

            if (scaled_value > (label_value_cutoff * max_x) * 100) {
              glue::glue("<div style='background:{fill};width:{scaled_value}%;height:{height}px;display:flex;align-items:center;justify-content:center;color:{inside_label_color};font-weight:{font_style};font-size:{font_size};'>{label}</div>")
            } else {
              glue::glue(
                "<div style='background:{fill};width:{scaled_value}%;height:{height}px;display:flex;align-items:center;justify-content:flex-start;position:relative;'>",
                "<span style='color:{outside_label_color};position:absolute;left:100%;margin-left:5px;font-weight:{font_style};font-size:{font_size};'>{label}</span></div>"
              )
            }
          } else {
            glue::glue(
              "<div style='background:{fill};width:{scaled_value}%;height:{height}px;'></div>" # no labels added
            )
          }
        })

        chart <- lapply(bar, function(bar) {
          glue::glue("<div style='flex-grow:1;margin-left:8px;background:{background};'>{bar}</div>")
        })

        chart
      }
    ) %>%
    cols_align(align = "left", columns = {{ column }})
}
