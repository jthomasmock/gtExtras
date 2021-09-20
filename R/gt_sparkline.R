#' Add sparklines into rows of a `gt` table
#' @description
#' The `gt_sparkline` function takes an existing `gt_tbl` object and
#' adds sparklines via the `ggplot2`. This is a wrapper around
#' `gt::text_transform()` + `ggplot2` with the necessary boilerplate already applied.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column wherein the sparkline plot should replace existing data. Note that the data *must* be represented as a list of numeric values ahead of time.
#' @param type A string indicating the type of plot to generate, accepts `"sparkline"`, `"histogram"` or `"density"`.
#' @param line_color Color for the line, defaults to `"lightgrey"`. Accepts a named color (eg 'blue') or a hex color.
#' @param range_colors A vector of two valid color names or hex codes, the first color represents the min values and the second color represents the highest point per plot. Defaults to `c("blue", "blue")`. Accepts a named color (eg `'blue'`) or a hex color like `"#fafafa"`.
#' @param fill_color Color for the fill of histograms/density plots, defaults to `"lightgrey"`. Accepts a named color (eg `'blue'`) or a hex color.
#' @param bw The bandwidth or binwidth, passed to `ggplot2::geom_density()` or `ggplot2::geom_histogram()`. If `type = "density"`, then `bw` is passed to the `bw` argument, if `type = "histogram"`, then `bw` is passed to the `binwidth` argument.
#' @param same_limit A logical indicating that the plots will use the same y-axis range (`TRUE`) or have individual y-axis ranges (`FALSE`).
#' @return An object of class `gt_tbl`.
#' @importFrom gt %>%
#' @export
#' @import gt ggplot2 dplyr
#' @examples
#'  library(gt)
#'  gt_sparkline_tab <- mtcars %>%
#'     dplyr::group_by(cyl) %>%
#'     # must end up with list of data for each row in the input dataframe
#'     dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
#'     gt() %>%
#'     gt_sparkline(mpg_data)
#'
#' @section Figures:
#' \if{html}{\figure{ggplot2-sparkline.png}{options: width=20\%}}
#'
#' @family Plotting
#' @section Function ID:
#' 1-4

gt_sparkline <- function(
  gt_object,
  column,
  type = "sparkline",
  line_color = "lightgrey",
  range_colors = c("red", "blue"),
  fill_color = "lightblue",
  bw = NULL,
  same_limit = TRUE
) {

  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))
  # convert tidyeval column to bare string
  col_bare <- rlang::enexpr(column) %>% rlang::as_string()
  # segment data with bare string column name
  data_in <- gt_object[["_data"]][[col_bare]]

  stopifnot("Specified column must contain list of values" = class(data_in) %in% "list")
  stopifnot("You must supply two colors for the max and min values." = length(range_colors) == 2L)
  stopifnot("You must indicate the `type` of plot as one of 'sparkline', 'histogram' or 'density'." = isTRUE(type %in% c("sparkline", "histogram", "density")))

  # convert to a single vector
  data_in <- unlist(data_in)
  # range to be used for plotting if same axis
  total_rng <- range(data_in, na.rm = TRUE)

  plot_fn_spark <- function(x) {
    vals <- strsplit(x, split = ", ") %>%
      unlist() %>%
      as.double()

    max_val <- max(vals, na.rm = TRUE)
    min_val <- min(vals, na.rm = TRUE)

    x_max <- vals[vals == max_val]
    x_min <- vals[vals == min_val]

    point_data <- dplyr::tibble(
      x = c(
        c(1:length(vals))[vals == min_val],
        c(1:length(vals))[vals == max_val]
      ),
      y = c(x_min, x_max),
      colors = c(rep(range_colors[1], length(x_min)), rep(range_colors[2], length(x_max)))
    )

    input_data <- dplyr::tibble(
      x = 1:length(vals),
      y = vals
    )

    if (type == "sparkline") {
      plot_base <- ggplot(input_data) +
        theme_void() +
        coord_cartesian(clip = "off")

      if (isTRUE(same_limit)) {
        plot_base <- plot_base +
          scale_y_continuous(
            limits = total_rng,
            expand = expansion(mult = 0.2)
          )
      } else {
        plot_base <- plot_base +
          scale_y_continuous(
            limits = range(vals, na.rm = TRUE),
            expand = expansion(mult = 0.2)
          )
      }

      plot_out <- plot_base +
        geom_line(aes(x = x, y = y), size = 0.5, color = line_color) +
        geom_point(
          data = point_data,
          aes(x = x, y = y, color = I(colors)),
          size = 0.5
        )
    } else if (type == "histogram") {
      plot_base <- ggplot(input_data) +
        theme_void()

      if (isTRUE(same_limit)) {

        if(is.null(bw)){
          bw <- 2 * IQR(data_in, na.rm = TRUE) / length(data_in)^(1 / 3)
        } else {
          bw <- bw
        }

        plot_out <- plot_base +
          geom_histogram(
            aes(x = y),
            color = line_color,
            fill = fill_color,
            binwidth = bw
          ) +
          scale_x_continuous(expand = expansion(mult = 0.2)) +
          coord_cartesian(clip = "off", xlim = range(data_in, na.rm = TRUE))

      } else {
        if(is.null(bw)){
          bw <- 2 * IQR(vals, na.rm = TRUE) / length(vals)^(1 / 3)
        } else {
          bw <- bw
        }

        plot_out <- plot_base +
          geom_histogram(
            aes(x = y),
            color = line_color,
            fill = fill_color,
            binwidth = bw
          ) +
          coord_cartesian(clip = "off")
      }
    } else if (type == "density") {
      plot_base <- ggplot(input_data) +
        theme_void()

      if (isTRUE(same_limit)) {
        if(is.null(bw)){
          bw <- bw.nrd0(data_in)
        } else {
          bw <- bw
        }

        plot_out <- plot_base +
          geom_density(
            aes(x = y),
            color = line_color,
            fill = fill_color,
            bw = bw
          ) +
          coord_cartesian(xlim = range(data_in, na.rm = TRUE),
                          expand = TRUE, clip = "off")
      } else {
        if(is.null(bw)){
          bw <- bw.nrd0(vals)
        } else {
          bw <- bw
        }

        plot_out <- plot_base +
          geom_density(
            aes(x = y),
            color = line_color,
            fill = fill_color,
            bw = bw
          ) +
          coord_cartesian(clip = "off", expand = TRUE)
      }
    }

    out_name <- file.path(
      tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".svg")
    )

    ggsave(
      out_name,
      plot = plot_out,
      dpi = 20,
      height = 0.15,
      width = 0.9
    )

    img_plot <- out_name %>%
      readLines() %>%
      paste0(collapse = "") %>%
      gt::html()

    on.exit(file.remove(out_name))

    img_plot
  }

  text_transform(
    gt_object,
    locations = cells_body(columns = {{ column }}),
    fn = function(x) {
      lapply(
        x,
        plot_fn_spark
      )
    }
  )
}
