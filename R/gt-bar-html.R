
#' Add HTML-based bar plots into rows of a `gt` table
#' @description
#' The `gt_plt_bar_pct` function takes an existing `gt_tbl` object and
#' adds horizontal barplots via native HTML. Note that values
#' default to being normalized to the percent of the maximum observed value
#' in the specified column. You can turn this off if the values already
#' represent a percentage value representing 0-100.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column wherein the bar plot should replace existing data.
#' @param height A number representing the vertical height of the plot in pixels. Defaults to 16 px.
#' @param width A number representing the horizontal width of the plot in pixels. Defaults to 100 px. Importantly, this interacts with the label_cutoff argument, so if you want to change the cutoff, you may need to adjust the width as well.
#' @param fill A character representing the fill for the bar, defaults to purple. Accepts a named color (eg 'purple') or a hex color.
#' @param background A character representing the background filling out the 100% mark of the bar, defaults to light grey. Accepts a named color (eg 'white') or a hex color.
#' @param scaled `TRUE`/`FALSE` logical indicating if the value is already scaled to a percent of max (`TRUE`) or if it needs to be scaled (`FALSE`). Defaults to `FALSE`, meaning the value will be divided by the max value in that column and then multiplied by 100.
#' @param labels `TRUE`/`FALSE` logical representing if labels should be plotted. Defaults to `FALSE`, meaning that no value labels will be plotted.
#' @param label_cutoff A number, 0 to 1, representing where to set the inside/outside label boundary. Defaults to 0.40 (40%) of the column's maximum value. If the value in that row is less than the cutoff, the label will be placed outside the bar, otherwise it will be placed within the bar. This interacts with the overall width of the bar, so if you are not happy with the placement of the labels you may try adjusting the `width` argument as well.
#' @param decimals A number representing how many decimal places to be used in label rounding. Defaults to 1.
#' @param font_style A character representing the font style of the labels. Accepts one of 'bold' (default), 'italic', or 'normal'.
#' @param font_size A character representing the font size of the labels. Defaults to '10px'.
#' @return An object of class `gt_tbl`.
#' @export
#' @section Examples:
#' ```r
#' library(gt)
#'
#' base_tab <- dplyr::tibble(x = seq(1, 100, length.out = 6)) %>%
#'   dplyr::mutate(
#'     x_unscaled = x,
#'     x_scaled = x / max(x) * 100
#'   ) %>%
#'   gt()
#'
#' base_tab %>%
#'   gt_plt_bar_pct(
#'     column = x_unscaled,
#'     scaled = TRUE,
#'     fill = "forestgreen"
#'   ) %>%
#'   gt_plt_bar_pct(
#'     column = x_scaled,
#'     scaled = FALSE,
#'     labels = TRUE
#'   )
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
    width = 100,
    fill = "purple",
    background = "#e1e1e1",
    scaled = FALSE,
    labels = FALSE,
    label_cutoff = 0.40,
    decimals = 1,
    font_style = "bold",
    font_size = "10px") {


  stopifnot(`'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?` = "gt_tbl" %in%
    class(gt_object))

  stopifnot('label_cutoff must be a number between 0 and 1' = dplyr::between(label_cutoff, 0, 1))

  # ensure font_style is one of the accepted values
  stopifnot(
    '`font_style` argument must be "bold", "normal", or "italic"' =
      font_style %in% c("bold", "normal", "italic")
    )

  all_cols <- gt_index(gt_object, column = {{ column }}, as_vector = FALSE)

  data_in <- all_cols %>% select({{ column }}) %>% pull()

  col_name <- all_cols %>%
    select({{ column }}) %>%
    names()

  # create a formula for cols_width
  col_to_widen <- rlang::new_formula(col_name, px(width))

  bar_plt_html <- function(xy) {

    if (length(na.omit(xy)) == 0) {
      max_x <- 0
    } else {
      max_x <- max(as.double(xy), na.rm = TRUE)
    }

    bar <- lapply(data_in, function(x) {

      scaled_value <- if(isFALSE(scaled)) {
        x / max_x * 100
      } else {
        x
      }

      if (labels) {
        # adjust values for labeling // scale_label
        label_values <- if(scaled) {
          x
        } else {
          x / max_x * 100
        }

        # create label string to print out // add % sign if requested
        label <- glue::glue("{round(label_values, decimals)}%")

        if (x < (label_cutoff * max_x)) {

          css_styles <- paste0(
            "background:", fill,";",
            "width:", scaled_value, "%;",
            "height:", height, "px;",
            "display:flex;",
            "align-items:center;",
            "justify-content:center;",
            "color:", ideal_fgnd_color(background),";",
            "font-weight:", font_style,";",
            "font-size:", font_size, ";",
            "position:relative;"
          )

          span_styles <- paste0(
            "color:", ideal_fgnd_color(background),";",
            "position:absolute;",
            "left:0%;",
            "margin-left:", scaled_value * width/100, "px;",
            "font-weight:", font_style,";",
            "font-size:", font_size,";"
          )

          glue::glue(
            "<div style='{css_styles}'>",
            "<span style='{span_styles}'>{label}</span></div>"
          )
        } else {

          css_styles <- paste0(
            "background:", fill,";",
            "width:", scaled_value, "%;",
            "height:", height, "px;",
            "display:flex;",
            "align-items:center;",
            "justify-content:flex-start;",
            "position:relative;"
          )

          span_styles <- paste0(
            "color:", ideal_fgnd_color(fill),";",
            "position:absolute;",
            "left:0px;",
            "margin-left:5px;",
            "font-weight:", font_style,";",
            "font-size:", font_size,";"
          )

          glue::glue(
            "<div style='{css_styles}'>",
            "<span style='{span_styles}'>{label}</span></div>"
          )
        }
      } else if(!is.na(x)) {
        glue::glue(
          "<div style='background:{fill};width:{scaled_value}%;height:{height}px;'></div>" # no labels added
        )
      } else if(is.na(x)){
        "<div style='background:transparent;width:0%;height:{height}px;'></div>" # no labels added
      }
    })

    chart <- lapply(bar, function(bar) {
      glue::glue("<div style='flex-grow:1;margin-left:8px;background:{background};'>{bar}</div>")
    })

    chart
  }

  # silence NAs messing with rownum_i
  quiet <- function(x) {
    sink(tempfile())
    on.exit(sink())
    invisible(force(x))
  }

  quiet(gt_object %>%
    cols_width(col_to_widen) %>%
    text_transform(
      locations = cells_body(columns = {{ column }}),
      fn = quiet(bar_plt_html)
    ) %>%
    cols_align(align = "left", columns = {{ column }}))
}
