#' Add distribution plots into rows of a `gt` table
#' @description
#' The `gt_plt_dist` function takes an existing `gt_tbl` object and
#' adds summary distribution sparklines via `ggplot2`. Note that these sparklines
#' are limited to density, histogram, boxplot or rug/strip charts. If you're
#' wanting to plot more traditional spark**lines**, you can use `gtExtras::gt_plt_sparkline()`.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column wherein the sparkline plot should replace existing data. Note that the data *must* be represented as a list of numeric values ahead of time.
#' @param type A string indicating the type of plot to generate, accepts `"boxplot"`, `"histogram"`, `"rug_strip"` or `"density"`.
#' @param fig_dim A vector of two numbers indicating the height/width of the plot in mm at a DPI of 25.4, defaults to `c(5,30)`
#' @param line_color Color for the line, defaults to `"black"`. Accepts a named color (eg 'blue') or a hex color.
#' @param fill_color Color for the fill of histograms/density plots, defaults to `"grey"`. Accepts a named color (eg `'blue'`) or a hex color.
#' @param bw The bandwidth or binwidth, passed to `density()` or `ggplot2::geom_histogram()`. If `type = "density"`, then `bw` is passed to the `bw` argument, if `type = "histogram"`, then `bw` is passed to the `binwidth` argument.
#' @param trim A logical indicating whether to trim the values in `type = "density"` to a slight expansion beyond the observable range. Can help with long tails in `density` plots.
#' @param same_limit A logical indicating that the plots will use the same axis range (`TRUE`) or have individual axis ranges (`FALSE`).
#' @return An object of class `gt_tbl`.
#' @export
#' @section Examples:
#' ```r
#'  library(gt)
#'  gt_sparkline_tab <- mtcars %>%
#'     dplyr::group_by(cyl) %>%
#'     # must end up with list of data for each row in the input dataframe
#'     dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
#'     gt() %>%
#'     gt_plt_dist(mpg_data)
#' ```
#' @section Figures:
#' \if{html}{\figure{gt_plt_dist.png}{options: width=50\%}}
#'
#' @family Plotting
#' @section Function ID:
#' 1-4

gt_plt_dist <- function(gt_object,
                        column,
                        type = "density",
                        fig_dim = c(5, 30),
                        line_color = "black",
                        fill_color = "grey",
                        bw = NULL,
                        trim = FALSE,
                        same_limit = TRUE) {
  is_gt_stop(gt_object)
  # convert tidyeval column to bare string
  col_bare <- dplyr::select(gt_object[["_data"]], {{ column }}) %>% names()

  # segment data with bare string column name
  list_data_in <- gt_index(gt_object, col_bare, as_vector = TRUE)

  # convert to a single vector
  data_in <- unlist(list_data_in)

  stopifnot("Specified column must contain list of values" = any(class(list_data_in) %in% "list"))
  stopifnot("Specified column must be numeric" = is.numeric(data_in))
  stopifnot("You must indicate the `type` of plot as one of 'boxplot', 'histogram', 'rug_strip' or 'density'." = isTRUE(type %in% c("boxplot", "rug_strip", "histogram", "density")))

  # range to be used for plotting if same axis
  total_rng <- grDevices::extendrange(data_in, r = range(data_in, na.rm = TRUE), f = 0.02)

  plot_fn_spark <- function(trim, list_data_in) {
    if (all(list_data_in %in% c(NA, NULL))) {
      return("<div></div>")
    }

    vals <- as.double(stats::na.omit(list_data_in))

    max_val <- max(vals, na.rm = TRUE)
    min_val <- min(vals, na.rm = TRUE)

    x_max <- vals[vals == max_val]
    x_min <- vals[vals == min_val]

    input_data <- dplyr::tibble(
      x = 1:length(vals),
      y = vals
    )

    if (type == "boxplot") {
      plot_base <- ggplot(input_data) +
        theme_void()

      if (isTRUE(same_limit)) {
        plot_base <- plot_base +
          scale_x_continuous(expand = expansion(mult = 0.05)) +
          coord_cartesian(
            clip = "off",
            xlim = grDevices::extendrange(total_rng, f = c(0, 0.01)),
            ylim = c(0.9, 1.15)
          )
      } else {
        plot_base <- plot_base +
          scale_x_continuous(expand = expansion(mult = 0.05)) +
          coord_cartesian(
            clip = "off",
            xlim = grDevices::extendrange(vals, f = 0.09),
            ylim = c(0.9, 1.15)
          )
      }

      plot_out <- plot_base +
        geom_boxplot(
          aes(x = .data$y, y = 1),
          width = 0.15,
          color = line_color,
          fill = fill_color,
          outlier.size = 0.3,
          linewidth = 0.3
        )
    } else if (type == "rug_strip") {
      plot_base <- ggplot(input_data) +
        theme_void()

      if (isTRUE(same_limit)) {
        plot_base <- plot_base +
          scale_x_continuous(expand = expansion(mult = 0.05)) +
          coord_cartesian(
            clip = "off",
            xlim = grDevices::extendrange(total_rng, f = 0.09),
            ylim = c(0.75, 1.15)
          )
      } else {
        plot_base <- plot_base +
          scale_x_continuous(expand = expansion(mult = 0.05)) +
          coord_cartesian(
            clip = "off",
            xlim = grDevices::extendrange(vals, f = 0.09),
            ylim = c(0.75, 1.15)
          )
      }

      plot_out <- plot_base +
        geom_point(
          aes(x = .data$y, y = 1),
          alpha = 0.2,
          size = 0.3,
          color = line_color,
          position = position_jitter(height = 0.15, seed = 37)
        ) +
        geom_rug(
          aes(x = .data$y),
          length = unit(0.2, "npc"),
          alpha = 0.5,
          linewidth = 0.2
        )
    } else if (type == "histogram") {
      plot_base <- ggplot(input_data) +
        theme_void()

      if (isTRUE(same_limit)) {
        if (is.null(bw)) {
          bw <- 2 * stats::IQR(data_in, na.rm = TRUE) / length(data_in)^(1 / 3)
        } else {
          bw <- bw
        }

        plot_out <- plot_base +
          geom_histogram(
            aes(x = .data$y),
            color = line_color,
            fill = fill_color,
            binwidth = bw,
            linewidth = 0.2
          ) +
          scale_x_continuous(expand = expansion(mult = 0.2)) +
          coord_cartesian(
            clip = "off",
            xlim = grDevices::extendrange(
              data_in,
              r = range(data_in, na.rm = TRUE),
              f = 0.02
            )
          )
      } else {
        if (is.null(bw)) {
          bw <- 2 * stats::IQR(vals, na.rm = TRUE) / length(vals)^(1 / 3)
        } else {
          bw <- bw
        }

        plot_out <- plot_base +
          geom_histogram(
            aes(x = .data$y),
            color = line_color,
            fill = fill_color,
            binwidth = bw
          ) +
          coord_cartesian(
            clip = "off",
            xlim = grDevices::extendrange(
              vals,
              r = range(vals, na.rm = TRUE),
              f = 0.02
            )
          )
      }
    } else if (type == "density") {
      if (isTRUE(same_limit)) {
        if (is.null(bw)) {
          bw <- stats::bw.nrd0(stats::na.omit(as.vector(data_in)))
        } else {
          bw <- bw
        }

        total_rng_dens <- stats::density(
          as.vector(
            stats::na.omit(data_in)
          ),
          bw = bw
        )[["x"]]

        density_calc <- stats::density(input_data[["y"]], bw = bw)
        density_range <- density_calc[["x"]]

        density_df <- dplyr::tibble(
          x = density_calc[["x"]],
          y = density_calc[["y"]]
        )

        if (trim) { # implementation of filtering values
          # only to actual and slightly outside the range
          filter_range <- range(vals, na.rm = TRUE) %>%
            scales::expand_range(mul = 0.05)

          density_df <- dplyr::filter(
            density_df,
            dplyr::between(.data$x, filter_range[1], filter_range[2])
          )
        }

        plot_base <- ggplot(density_df) +
          theme_void()


        plot_out <- plot_base +
          geom_area(
            aes(x = .data$x, y = .data$y),
            color = line_color,
            fill = fill_color
          ) +
          xlim(range(density_range)) +
          coord_cartesian(
            xlim = range(total_rng_dens, na.rm = TRUE),
            expand = TRUE,
            clip = "off"
          )
      } else {
        if (is.null(bw)) {
          bw <- stats::bw.nrd0(stats::na.omit(as.vector(data_in)))
        } else {
          bw <- bw
        }

        total_rng_dens <- stats::density(stats::na.omit(as.vector(vals)), bw = bw)[["x"]]

        density_calc <- stats::density(input_data[["y"]], bw = bw)
        density_range <- density_calc[["x"]]

        density_df <- dplyr::tibble(
          x = density_calc[["x"]],
          y = density_calc[["y"]]
        )

        if (trim) { # implementation of filtering values
          # only to actual and slightly outside the range
          filter_range <- range(vals, na.rm = TRUE) %>%
            scales::expand_range(mul = 0.05)

          density_df <- dplyr::filter(
            density_df,
            dplyr::between(.data$x, filter_range[1], filter_range[2])
          )
        }

        plot_base <- ggplot(density_df) +
          theme_void()

        plot_out <- plot_base +
          geom_area(
            aes(x = .data$x, y = .data$y),
            color = line_color,
            fill = fill_color
          ) +
          xlim(range(density_range, na.rm = TRUE)) +
          coord_cartesian(
            xlim = range(total_rng_dens, na.rm = TRUE),
            expand = TRUE,
            clip = "off"
          )
      }
    }

    out_name <- file.path(
      tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".svg")
    )

    ggsave(
      out_name,
      plot = plot_out,
      dpi = 25.4,
      height = fig_dim[1],
      width = fig_dim[2],
      units = "mm"
    )

    img_plot <- out_name %>%
      readLines() %>%
      paste0(collapse = "") %>%
      gt::html()

    on.exit(file.remove(out_name), add = TRUE)

    img_plot
  }

  text_transform(
    gt_object,
    locations = cells_body(columns = {{ column }}),
    fn = function(x) {
      mapply(plot_fn_spark, trim, list_data_in, SIMPLIFY = FALSE)
    }
  )
}
