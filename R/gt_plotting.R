#' Add sparklines into rows of a `gt` table
#' @description
#' The `gt_kable_sparkline` function takes an existing `gt_tbl` object and
#' adds sparklines via the `kableExtra::spec_plot()` function. This is a wrapper
#' around `gt::text_transform()` + `kableExtra::spec_plot()` with
#' the necessary boilerplate already applied.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column wherein the sparkline plot should replace existing data. Note that the data *must* be represented as a list of numeric values ahead of time.
#' @param width Number representing the horizontal width of the plot in pixels. Defaults to 300 px.
#' @param height Number representing the vertical height of the plot in pixels. Defaults to 45 px.
#' @param color Color for the line, defaults to light grey. Accepts a named color (eg 'blue') or a hex color.
#' @param ... Additional arguments passed to `kableExtra::spec_plot`
#' @return An object of class `gt_tbl`.
#' @importFrom gt %>%
#' @export
#' @import gt rlang
#' @importFrom kableExtra spec_plot
#' @examples
#'  library(gt)
#'  kable_sparkline_tab <- mtcars %>%
#'     dplyr::group_by(cyl) %>%
#'     # must end up with list of data for each row in the input dataframe
#'     dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
#'     gt() %>%
#'     gt_kable_sparkline(mpg_data, height = 45)
#'
#' @section Figures:
#' \if{html}{\figure{kable-sparkline.png}{options: width=20\%}}
#'
#' @family Plotting
#' @section Function ID:
#' 3-2

gt_kable_sparkline <- function(gt_object, column, width = 200, height = 45, color = "lightgrey", ...){

  # convert tidyeval column to bare string
  col_bare <- rlang::enexpr(column) %>% rlang::as_string()
  # segment data with bare string column name
  data_in = gt_object[["_data"]][[col_bare]]

  text_transform(
    gt_object,
    locations = cells_body(columns = {{ column }}),
    fn = function(z){
      plot <- lapply(X = data_in, kableExtra::spec_plot, width = width, height = height, same_lim = TRUE, col = color, ...)
      plot_svg <- lapply(plot, function(plot){plot[["svg_text"]]})
      lapply(plot_svg, gt::html)
    }
  )
}

#' Add win loss point plot into rows of a `gt` table
#' @description
#' The `gt_plt_winloss` function takes an existing `gt_tbl` object and
#' adds squares of a specific color and vertical position based on wins/losses.
#' It is a wrapper around `gt::text_transform()`. The column chosen **must** be
#' a list-column as seen in the example code. The column should also only contain
#' values of 0 (loss), 0.5 (tie), and 1 (win).
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column wherein the winloss plot should replace existing data. Note that the data *must* be represented as a list of numeric values ahead of time.
#' @param max_wins An integer indicating the max possible wins, this will be used to add padding if the total wins/losses observed is less than the max. This is useful for mid-season reporting. Defaults to a red, blue, grey palette.
#' @param colors A character vector of length 3, specifying the colors for loss, win, tie in that exact order.
#' @param type A character string representing the type of plot, either a 'pill' or 'square'
#' @return An object of class `gt_tbl`.
#' @importFrom gt %>%
#' @import gt rlang
#' @export
#' @importFrom kableExtra spec_plot
#' @examples
#' library(gt)
#'
#' set.seed(37)
#' data_in <- dplyr::tibble(
#'   grp = rep(c("A", "B", "C"), each = 10),
#'   wins = sample(c(0,1,.5), size = 30, prob = c(0.45, 0.45, 0.1), replace = TRUE)
#' ) %>%
#'   dplyr::group_by(grp) %>%
#'   dplyr::summarize(wins=list(wins), .groups = "drop")
#'
#' data_in
#'
#' win_table <- data_in %>%
#'   gt() %>%
#'   gt_plt_winloss(wins)
#' @section Figures:
#' \if{html}{\figure{gt_plt_winloss-ex.png}{options: width=60\%}}
#'
#' @family Plotting
#' @section Function ID:
#' 3-1

gt_plt_winloss <- function(gt_object, column, max_wins = 17,
                           colors = c("#D50A0A", "#013369", "gray"),
                           type = "pill") {

  stopifnot("'gt_object' must be a 'gt_tbl'" = gt:::is_gt(gt_object))
  stopifnot("type must be on of 'pill' or 'square'" = {type %in% c("pill", "square")})
  stopifnot("There must be 3 colors" = length(colors) == 3L)

  test_vals <- gt_object[["_data"]] %>%
    dplyr::select({{ column }}) %>%
    dplyr::pull()

  stopifnot("The column must be a list-column" = is.list(test_vals))
  stopifnot("All values must be 1, 0 or 0.5" = unlist(test_vals) %in% c(1, 0, 0.5))

  plot_fn_pill <- function(x){

    vals <- strsplit(x, split = ", ") %>%
      unlist() %>%
      as.double()

    input_data <- data.frame(
      x = 1:length(vals),
      xend = 1:length(vals),
      y = ifelse(vals == 0.5, 0.4, vals),
      yend = ifelse(vals == 0, 0.6, ifelse(vals > 0.5, 0.4, 0.6)),
      color = ifelse(vals == 0, "#D50A0A", ifelse(vals == 1, "#013369", "grey"))
    )

    plot_out <- ggplot(input_data) +
      geom_segment(
        aes(x = x, xend = xend, y = y, yend = yend, color = I(color)),
        size = 1, lineend = "round") +
      scale_x_continuous(limits = c(0.5, max_wins + 0.5)) +
      scale_y_continuous(limits = c(-.2, 1.2)) +
      theme_void()

    out_name <- file.path(
      tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".svg")
    )

    ggsave(out_name, plot = plot_out,
           dpi = 20, height = 0.15, width = 0.9)

    img_plot <- out_name %>%
      readLines() %>%
      paste0(collapse = "") %>%
      gt::html()

    on.exit(file.remove(out_name))

    img_plot

  }

  plot_fn_square <- function(x){

    vals <- strsplit(x, split = ", ") %>%
      unlist() %>%
      as.double()

    len_val <- length(vals)

    vals2 <- c(vals, rep(0.49, max_wins-len_val))

    my_pal <- c(colors, "white")

    pt_col <- factor(vals2, levels = c(0, 1, 0.5, 0.49),
                     labels = my_pal)

    raw_plt <- kableExtra::spec_plot(
      vals2, width = 120, height = 35, same_lim = TRUE,
      cex = 4, minmax = list(), xlim = c(0, max_wins), ylim = c(-.5, 1.5),
      type = "b", res = 140, col = my_pal[pt_col], polymin = NA
    )

    plot_svg <- as.character(raw_plt[["svg_text"]]) %>%
      gt::html()

    plot_svg

  }


  text_transform(
    gt_object,
    locations = cells_body(columns = {{ column }}),
    fn = function(x){
      lapply(
        x,
        if(type == "pill"){plot_fn_pill} else {plot_fn_square}
      )
    }
  )

}


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
#' @importFrom gt %>%
#' @export
#' @import gt
#' @examples
#'
#'  gt_bar_plot_tab <- mtcars %>%
#'    head() %>%
#'    dplyr::select(cyl, mpg) %>%
#'    dplyr::mutate(mpg_pct_max = round(mpg/max(mpg) * 100, digits = 2),
#'                  mpg_scaled = mpg/max(mpg) * 100) %>%
#'    dplyr::mutate(mpg_unscaled = mpg) %>%
#'    gt() %>%
#'    gt_plt_bar_pct(column = mpg_scaled, scaled = TRUE) %>%
#'    gt_plt_bar_pct(column = mpg_unscaled, scaled = FALSE, fill = "blue", background = "lightblue") %>%
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

gt_plt_bar_pct <- function(
  gt_object, column, height = 16, fill = "purple", background = "#e1e1e1",
  scaled = FALSE) {

  # convert tidyeval column to bare string
  col_bare <- rlang::enexpr(column) %>% rlang::as_string()
  # segment data with bare string column name
  data_in = gt_object[["_data"]][[col_bare]]

  col_number <- which(colnames(gt_object[["_data"]])==col_bare)

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
