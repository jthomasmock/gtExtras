#' Add sparklines into rows of a `gt` table
#' @description
#' The `gt_sparkline` function takes an existing `gt_tbl` object and
#' adds sparklines via the `ggplot2`. This is a wrapper around
#' `gt::text_transform()` + `ggplot2` with the necessary boilerplate already applied.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column wherein the sparkline plot should replace existing data. Note that the data *must* be represented as a list of numeric values ahead of time.
#' @param type A string indicating the type of plot to generate, accepts `"sparkline"`, `"histogram"` or `"density"`.
#' @param width A number indicating the width of the plot in mm at a DPI of 25.4, defaults to 30
#' @param line_color Color for the line, defaults to `"black"`. Accepts a named color (eg 'blue') or a hex color.
#' @param range_colors A vector of two valid color names or hex codes, the first color represents the min values and the second color represents the highest point per plot. Defaults to `c("blue", "blue")`. Accepts a named color (eg `'blue'`) or a hex color like `"#fafafa"`.
#' @param fill_color Color for the fill of histograms/density plots, defaults to `"grey"`. Accepts a named color (eg `'blue'`) or a hex color.
#' @param bw The bandwidth or binwidth, passed to `density()` or `ggplot2::geom_histogram()`. If `type = "density"`, then `bw` is passed to the `bw` argument, if `type = "histogram"`, then `bw` is passed to the `binwidth` argument.
#' @param trim A logical indicating whether to trim the values in `type = "density"` to a slight expansion beyond the observable range. Can help with long tails in `density` plots.
#' @param same_limit A logical indicating that the plots will use the same axis range (`TRUE`) or have individual axis ranges (`FALSE`).
#' @param label A logical indicating whether the sparkline will have a numeric label at the end of the plot.
#' @return An object of class `gt_tbl`.
#' @importFrom gt %>%
#' @importFrom scales label_number_si
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
#' \if{html}{\figure{ggplot2-sparkline.png}{options: width=50\%}}
#'
#' @family Plotting
#' @section Function ID:
#' 1-4

gt_sparkline <- function(gt_object, column, type = "sparkline", width = 30,
                         line_color = "black", range_colors = c("red", "blue"),
                         fill_color = "grey", bw = NULL, trim = FALSE,
                         same_limit = TRUE, label = TRUE
) {

  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))
  # convert tidyeval column to bare string
  col_bare <- dplyr::select(gt_object[["_data"]], {{ column }}) %>% names()

  # segment data with bare string column name
  data_in <- gt_index(gt_object, col_bare, as_vector = TRUE)

  stopifnot("Specified column must contain list of values" = class(data_in) %in% "list")
  stopifnot("You must supply two colors for the max and min values." = length(range_colors) == 2L)
  stopifnot("You must indicate the `type` of plot as one of 'sparkline', 'histogram' or 'density'." = isTRUE(type %in% c("sparkline", "histogram", "density")))

  # convert to a single vector
  data_in <- unlist(data_in)
  # range to be used for plotting if same axis
  total_rng <- grDevices::extendrange(data_in, r = range(data_in, na.rm = TRUE), f = 0.02)

  plot_fn_spark <- function(x, trim) {

    if(x %in% c("NA", "NULL")){
      return("<div></div>")
    }

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
      colors = c(rep(range_colors[1], length(x_min)),
                 rep(range_colors[2], length(x_max)))
    )

    input_data <- dplyr::tibble(
      x = 1:length(vals),
      y = vals
    )

    if (type == "sparkline") {
      plot_base <- ggplot(input_data) +
        theme_void()

      if (isTRUE(same_limit)) {
        plot_base <- plot_base +
          scale_y_continuous(expand = expansion(mult = 0.05)) +
          coord_cartesian(clip = "off", ylim = grDevices::extendrange(total_rng, f = 0.09),
                          xlim = c(0.25, length(vals)*1.25))
      } else {
        plot_base <- plot_base +
          scale_y_continuous(expand = expansion(mult = 0.05)) +
          coord_cartesian(clip = "off", ylim = grDevices::extendrange(vals, f = 0.09),
                          xlim = c(0.25, length(vals)*1.25))
      }

      med_y_rnd <- round(median(input_data$y))
      last_val_label <- input_data[nrow(vals), 2]

        plot_out <- plot_base +
          geom_line(aes(x = x, y = y, group = 1), size = 0.5,
                  color = line_color) +
          geom_point(
            data = filter(input_data, x == max(x)),
            aes(x = x, y=y), size = 0.5,  color = "black"
          ) +
          geom_point(
            data = point_data,
            aes(x = x, y = y, color = I(colors), group = 1),
            size = 0.5
            )

        if(isTRUE(label)){
          plot_out <- plot_out +
            geom_text(
              data = filter(input_data, x == max(x)),
              aes(x = x, y=y, color = "black",
                  label = scales::label_number_si(
                    accuracy = if(med_y_rnd > 0){
                      .1
                    } else if(med_y_rnd == 0) {
                      .01
                    }
                  )(y)
              ),
              size = 2, family = "mono", hjust = 0, vjust = 0.5,
              position = position_nudge(x = max(input_data$x)*0.05)
            )
        }



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
          coord_cartesian(
            clip = "off",
            xlim = grDevices::extendrange(
              data_in, r = range(data_in, na.rm = TRUE), f = 0.02))

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
          coord_cartesian(clip = "off",
                          xlim = grDevices::extendrange(
                            vals, r = range(vals, na.rm = TRUE), f = 0.02
                          ))
      }
    } else if (type == "density") {

      if (isTRUE(same_limit)) {
        if(is.null(bw)){
          bw <- bw.nrd0(na.omit(data_in))
        } else {
          bw <- bw
        }

        total_rng_dens <- density(na.omit(data_in), bw = bw)[["x"]]

        density_calc <- density(input_data[["y"]], bw = bw)
        density_range <- density_calc[["x"]]

        density_df <- dplyr::tibble(
          x = density_calc[["x"]],
          y = density_calc[["y"]]
          )

        if(trim){ # implementation of filtering values
          # only to actual and slightly outside the range
          filter_range <- range(vals, na.rm = TRUE) %>%
            scales::expand_range(mul = 0.05)

          density_df <- dplyr::filter(
            density_df,
            dplyr::between(x, filter_range[1], filter_range[2]))
        }

          plot_base <- ggplot(density_df) +
            theme_void()


        plot_out <- plot_base +
          geom_area(aes(x = x, y = y),
                    color = line_color,
                    fill = fill_color) +
          xlim(range(density_range)) +
          coord_cartesian(xlim = range(total_rng_dens, na.rm = TRUE),
                          expand = TRUE, clip = "off")
      } else {
        if(is.null(bw)){
          bw <- bw.nrd0(vals)
        } else {
          bw <- bw
        }

        total_rng_dens <- density(data_in, bw = bw)[["x"]]

        density_calc <- density(input_data[["y"]], bw = bw)
        density_range <- density_calc[["x"]]

        density_df <- dplyr::tibble(
          x = density_calc[["x"]],
          y = density_calc[["y"]]
        )

        if(trim){ # implementation of filtering values
          # only to actual and slightly outside the range
          filter_range <- range(vals, na.rm = TRUE) %>%
            scales::expand_range(mul = 0.05)

          density_df <- dplyr::filter(
            density_df,
            dplyr::between(x, filter_range[1], filter_range[2]))
        }

        plot_base <- ggplot(density_df) +
          theme_void()

        plot_out <- plot_base +
          geom_area(aes(x = x, y = y),
                    color = line_color,
                    fill = fill_color) +
          xlim(range(density_range)) +
          coord_cartesian(xlim = range(total_rng_dens, na.rm = TRUE),
                          expand = TRUE, clip = "off")
      }
    }

    out_name <- file.path(
      tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".svg")
    )

    ggsave(
      out_name,
      plot = plot_out,
      dpi = 25.4,
      height = 5,
      width = width,
      units = "mm"
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
        function(x) {
          plot_fn_spark(x, trim)
        }
      )
    }
  )
}


