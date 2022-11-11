#' Add sparklines into rows of a `gt` table
#' @description
#' The `gt_plt_sparkline` function takes an existing `gt_tbl` object and
#' adds sparklines via the `ggplot2`. Note that if you'd rather plot summary
#' distributions (ie density/histograms) you can instead use: `gtExtras::gt_plt_dist()`
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column wherein the sparkline plot should replace existing data. Note that the data *must* be represented as a list of numeric values ahead of time.
#' @param type A string indicating the type of plot to generate, accepts `"default"`, `"points"`, `"shaded"`, `"ref_median"`, `'ref_mean'`, `"ref_iqr"`, `"ref_last"`. "points" will add points to every observation instead of just the high/low and final. "shaded" will add shading below the sparkline. The "ref_" options add a thin reference line based off the summary statistic chosen
#' @param fig_dim A vector of two numbers indicating the height/width of the plot in mm at a DPI of 25.4, defaults to `c(5,30)`
#' @param palette A character string with 5 elements indicating the colors of various components. Order matters, and palette = sparkline color, final value color, range color low, range color high, and 'type' color (eg shading or reference lines). To show a plot with no points (only the line itself), use: `palette = c("black", rep("transparent", 4))`.
#' @param same_limit A logical indicating that the plots will use the same axis range (`TRUE`) or have individual axis ranges (`FALSE`).
#' @param label A logical indicating whether the sparkline will have a numeric label at the end of the plot.
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
#'     gt_plt_sparkline(mpg_data)
#' ```
#' @section Figures:
#' \if{html}{\figure{gt_plt_sparkline.png}{options: width=50\%}}
#'
#' @family Plotting
#' @section Function ID:
#' 1-4
gt_plt_sparkline <- function(gt_object,
                             column,
                             type = "default",
                             fig_dim = c(5, 30),
                             palette = c("black", "black", "purple", "green", "lightgrey"),
                             same_limit = TRUE,
                             label = TRUE) {
  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))

  # convert tidyeval column to bare string
  col_bare <- dplyr::select(gt_object[["_data"]], {{ column }}) %>% names()

  # segment data with bare string column name
  list_data_in <- gt_index(gt_object, col_bare, as_vector = TRUE)

  # convert to a single vector
  data_in <- unlist(list_data_in)

  stopifnot("Specified column must contain list of values" = class(list_data_in) %in% "list")
  stopifnot("You must supply five colors for the palette." = length(palette) == 5L)
  stopifnot("You must indicate the `type` of plot as one of 'default', 'shaded', 'ref_median', 'ref_mean', 'points', 'ref_last' or 'ref_iqr'." = isTRUE(type %in% c("default", "shaded", "ref_median", "ref_mean", "ref_iqr", "points", "ref_last")))

  # range to be used for plotting if same axis
  total_rng <- grDevices::extendrange(data_in, r = range(data_in, na.rm = TRUE), f = 0.02)

  plot_fn_spark <- function(list_data_in) {
    if (all(list_data_in %in% c(NA, NULL))) {
      return("<div></div>")
    }

    vals <- as.double(stats::na.omit(list_data_in))

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
      colors = c(
        rep(palette[3], length(x_min)),
        rep(palette[4], length(x_max))
      )
    )

    input_data <- dplyr::tibble(
      x = 1:length(vals),
      y = vals
    )

    plot_base <- ggplot(input_data) +
      theme_void()

    med_y_rnd <- round(stats::median(input_data$y))
    last_val_label <- input_data[nrow(vals), 2]

    if (isTRUE(same_limit) && isFALSE(label)) {
      plot_base <- plot_base +
        scale_y_continuous(expand = expansion(mult = 0.05)) +
        coord_cartesian(
          clip = "off",
          ylim = grDevices::extendrange(total_rng, f = 0.09)
        )
    } else if (isFALSE(same_limit) && isFALSE(label)) {
      plot_base <- plot_base +
        scale_y_continuous(expand = expansion(mult = 0.05)) +
        coord_cartesian(
          clip = "off",
          ylim = grDevices::extendrange(vals, f = 0.09)
        )
    } else if (isFALSE(same_limit) && isTRUE(label)) {
      plot_base <- plot_base +
        geom_text(
          data = filter(input_data, .data$x == max(.data$x)),
          aes(
            x = .data$x,
            y = .data$y,
            label = scales::label_number(
              scale_cut = cut_short_scale(),
              accuracy = if (med_y_rnd > 0) {
                .1
              } else if (med_y_rnd == 0) {
                .01
              }
            )(.data$y)
          ),
          size = 2,
          family = "mono",
          hjust = 0,
          vjust = 0.5,
          position = position_nudge(x = max(input_data$x) * 0.05),
          color = palette[2]
        ) +
        scale_y_continuous(expand = expansion(mult = 0.05)) +
        coord_cartesian(
          clip = "off",
          ylim = grDevices::extendrange(vals, f = 0.09),
          xlim = c(0.25, length(vals) * 1.25)
        )
    } else if (isTRUE(same_limit) && isTRUE(label)) {
      plot_base <- plot_base +
        geom_text(
          data = filter(input_data, .data$x == max(.data$x)),
          aes(
            x = .data$x,
            y = .data$y,
            label = scales::label_number(
              scale_cut = cut_short_scale(),
              accuracy = if (med_y_rnd > 0) {
                .1
              } else if (med_y_rnd == 0) {
                .01
              }
            )(.data$y)
          ),
          size = 2,
          family = "mono",
          hjust = 0,
          vjust = 0.5,
          position = position_nudge(x = max(input_data$x) * 0.05),
          color = palette[2]
        ) +
        scale_y_continuous(expand = expansion(mult = 0.05)) +
        coord_cartesian(
          clip = "off",
          ylim = grDevices::extendrange(total_rng, f = 0.09),
          xlim = c(0.25, length(vals) * 1.25)
        )
    }

    plot_out <- plot_base +
      geom_line(
        aes(x = .data$x, y = .data$y, group = 1),
        linewidth = 0.5,
        color = palette[1]
      ) +
      geom_point(
        data = filter(input_data, .data$x == max(.data$x)),
        aes(x = .data$x, y = .data$y),
        size = 0.5,
        color = palette[2]
      ) +
      geom_point(
        data = point_data,
        aes(x = .data$x, y = .data$y, color = I(.data$colors), group = 1),
        size = 0.5
      )

    ### Shaded area
    if (type == "shaded") {
      plot_out$layers <- c(
        geom_area(aes(x = .data$x, y = .data$y), fill = palette[5], alpha = 0.75),
        plot_out$layers
      )

      ### Horizontal ref line at median
    } else if (type == "ref_median") {
      plot_out$layers <- c(
        geom_segment(
          aes(
            x = min(.data$x),
            y = stats::median(.data$y),
            xend = max(.data$x),
            yend = stats::median(.data$y)
          ),
          color = palette[5],
          linewidth = 0.1
        ),
        plot_out$layers
      )
      ### dots on all points
    } else if (type == "points") {
      plot_out$layers <- c(
        geom_point(
          aes(x = .data$x, y = .data$y),
          color = palette[5],
          size = 0.4
        ),
        plot_out$layers
      )
      ### Horizontal ref line at mean
    } else if (type == "ref_mean") {
      plot_out$layers <- c(
        geom_segment(
          aes(
            x = min(.data$x),
            y = mean(.data$y),
            xend = max(.data$x),
            yend = mean(.data$y)
          ),
          color = palette[5],
          linewidth = 0.1
        ),
        plot_out$layers
      )
      ### Horizontal ref line at last point
    } else if (type == "ref_last") {
      plot_out$layers <- c(
        geom_segment(
          aes(
            x = min(.data$x),
            y = last(.data$y),
            xend = max(.data$x),
            yend = last(.data$y)
          ),
          color = palette[5],
          linewidth = 0.1
        ),
        plot_out$layers
      )
      ### Horizontal area/ribbon for 25/75 interquantile range
    } else if (type == "ref_iqr") {
      ribbon_df <- input_data %>%
        summarise(
          q25 = stats::quantile(.data$y, 0.25),
          q75 = stats::quantile(.data$y, 0.75)
        )

      plot_out$layers <- c(
        geom_ribbon(
          aes(x = .data$x, ymin = ribbon_df$q25, ymax = ribbon_df$q75),
          fill = palette[5],
          alpha = 0.5
        ),
        geom_segment(
          aes(
            x = min(.data$x),
            y = stats::median(.data$y),
            xend = max(.data$x),
            yend = stats::median(.data$y)
          ),
          color = palette[5],
          linewidth = 0.1
        ),
        plot_out$layers
      )
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
    fn = function(x) lapply(list_data_in, plot_fn_spark)
  )
}
