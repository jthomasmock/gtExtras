#' Plot a confidence interval around a point
#'
#' @param gt_object An existing gt table
#' @param column The column that contains the mean of the sample. This can either be a single number per row, if you have calculated the values ahead of time, or a list of values if you want to calculate the confidence intervals.
#' @param ci_columns Optional columns representing the left/right confidence intervals of your sample.
#' @param ci The confidence interval, representing the percentage, ie `0.9` which represents `10-90` for the two tails.
#' @param palette A vector of color strings of exactly length 4. The colors represent the central point, the color of the range, the color of the stroke around the central point, and the color of the text, in that specific order.
#' @param width A number indicating the width of the plot in `"mm"`, defaults to `45`.
#' @param text_args A list of named arguments. Optional text arguments passed as a list to `scales::label_number`.
#' @param text_size A number indicating the size of the text indicators in the plot. Defaults to 1.5. Can also be set to `0` to "remove" the text itself.
#' @param ref_line A number indicating where to place reference line on x-axis.
#'
#' @return a gt table
#' @export
#'
#' @section Examples:
#' ```r
#' # gtExtras can calculate basic conf int
#' # using confint() function
#'
#' ci_table <- generate_df(
#'   n = 50, n_grps = 3,
#'   mean = c(10, 15, 20), sd = c(10, 10, 10),
#'   with_seed = 37
#' ) %>%
#'   dplyr::group_by(grp) %>%
#'   dplyr::summarise(
#'     n = dplyr::n(),
#'     avg = mean(values),
#'     sd = sd(values),
#'     list_data = list(values)
#'   ) %>%
#'   gt::gt() %>%
#'   gt_plt_conf_int(list_data, ci = 0.9)
#'
#' # You can also provide your own values
#' # based on your own algorithm/calculations
#' pre_calc_ci_tab <- dplyr::tibble(
#'   mean = c(12, 10), ci1 = c(8, 5), ci2 = c(16, 15),
#'   ci_plot = c(12, 10)
#' ) %>%
#'   gt::gt() %>%
#'   gt_plt_conf_int(
#'     ci_plot, c(ci1, ci2),
#'     palette = c("red", "lightgrey", "black", "red")
#'     )
#' ```
#' @section Figures:
#' \if{html}{\figure{gt_plt_ci_calc.png}{options: width=70\%}}
#' \if{html}{\figure{gt_plt_ci_vals.png}{options: width=70\%}}
#'
#' @family Themes
#' @section Function ID:
#' 3-10
gt_plt_conf_int <- function(gt_object, column, ci_columns, ci = 0.9, ref_line = NULL,
                            palette = c("black", "grey", "white", "black"),
                            width = 45, text_args = list(accuracy = 1),
                            text_size = 1.5) {
  all_vals <- gt_index(gt_object, {{ column }}, as_vector = FALSE)

  stopifnot("Confidence level must be between 0 and 1" = dplyr::between(ci, 0, 1))
  # convert desired confidence interval from percentage
  # to a two-tailed level to be used in confint() function
  level <- 1 - ((1 - ci) * 2)

  # if user doesn't supply their own pre-defined columns
  # grab them or save as "none"
  if (!missing(ci_columns)) {
    ci_vals <- all_vals %>%
      dplyr::select({{ ci_columns }})

    ci_val1 <- ci_vals[[1]]
    ci_val2 <- ci_vals[[2]]
  } else {
    ci_val1 <- "none"
  }

  column_vals <- all_vals %>%
    dplyr::select({{ column }}) %>%
    dplyr::pull()

  if ("none" %in% ci_val1) {
    stopifnot(
      "Must provide list column if no defined Confidence Intervals" =
        (class(column_vals) %in% c("list"))
    )

    # create a list of dataframes with
    # roughly calculated confidence intervals
    data_in <- lapply(column_vals, function(x) {
      dplyr::tibble(x = stats::na.omit(x), y = "1a") %>%
        dplyr::summarise(
          mean = mean(.data$x, na.rm = TRUE),
          y = unique(.data$y, na.rm = TRUE),
          lm_out = list(stats::lm(x ~ 1)),
          ci = list(stats::confint(.data$lm_out[[1]], level = level)),
          ci1 = ci[[1]][1],
          ci2 = ci[[1]][2]
        ) %>%
        dplyr::mutate(y = "1a")
    })
  } else {
    stopifnot(
      "Must provide single values per row if defining Confidence Intervals" =
        !(class(column_vals) %in% "list")
    )

    data_in <- dplyr::tibble(mean = column_vals, y = "1a") %>%
      dplyr::mutate(
        ci1 = ci_val1, ci2 = ci_val2,
        row_n = dplyr::row_number()
      ) %>%
      split(.$row_n)
  }

  # calculate the total range so the x-axis can be shared across rows
  all_ci_min <- min(dplyr::bind_rows(data_in)$ci1, na.rm = TRUE)
  all_ci_max <- max(dplyr::bind_rows(data_in)$ci2, na.rm = TRUE)

  ext_range <- scales::expand_range(c(all_ci_min, all_ci_max),
    mul = 0.1, zero_width = 1
  )

  ref_line <- if (is.null(ref_line)) {
    list("none")
  } else {
    list(ref_line)
  }

  gt_object %>%
    text_transform(
      locations = cells_body(columns = {{ column }}),
      fn = function(x) {
        tab_built <- mapply(
          FUN = add_ci_plot,
          data_in, list(palette), width, list(ext_range), list(text_args),
          text_size, list(ref_line), SIMPLIFY = FALSE
        )

        tab_built
      }
    ) %>%
    gt::cols_align(align = "left", columns = {{ column }})
}



#' Add a confidence interval plot inside a specific row
#'
#' @param data_in A dataframe of length 1
#' @param pal_vals A length 4 palette to be used for coloring points, segments and text
#' @param width Width of the output plot in `'mm'`
#' @param ext_range A length two vector of the full range across all values
#' @param text_args A list of optional text arguments passed to `scales::label_number()`
#' @inheritParams gt_plt_conf_int
#' @noRd
#'
#' @return SVG/HTML
add_ci_plot <- function(data_in, pal_vals, width, ext_range,
                        text_args = list(scale_cut = cut_short_scale()), text_size,
                        ref_line) {

  if(NA %in% unlist(data_in)){
    return("&nbsp;")
  }

  if (unlist(ref_line) == "none") {
    base_plot <- data_in %>%
      ggplot(aes(x = .data$mean, y = "1a"))
  } else {
    base_plot <- data_in %>%
      ggplot(aes(x = .data$mean, y = "1a")) +
      geom_text(
        aes(
          x = unlist(ref_line) * 1.01,
          label = do.call(scales::label_number, text_args)(unlist(ref_line))
        ),
        color = pal_vals[4], vjust = 1.1, size = text_size, hjust = 0,
        position = position_nudge(y = -0.25),
        family = "mono", fontface = "bold"
      ) +
      geom_vline(xintercept = ref_line[[1]], color = pal_vals[4])
  }

  plot_out <- base_plot +
    geom_segment(aes(x = .data$ci1, xend = .data$ci2, y = .data$y, yend = .data$y),
      lineend = "round",
      size = 1, color = pal_vals[2], alpha = 0.75
    ) +
    geom_point(aes(x = .data$mean, y = .data$y),
      size = 2, shape = 21, fill = pal_vals[1],
      color = pal_vals[3], stroke = 0.75
    ) +
    geom_label(aes(x = .data$ci2, label = do.call(scales::label_number, text_args)(.data$ci2)),
      color = pal_vals[4], hjust = 1.1, size = text_size, vjust = 0,
      fill = "transparent", position = position_nudge(y = 0.25),
      family = "mono", fontface = "bold",
      label.size = unit(0, "lines"), label.padding = unit(0.05, "lines"),
      label.r = unit(0, "lines")
    ) +
    geom_label(aes(x = .data$ci1, label = do.call(scales::label_number, text_args)(.data$ci1)),
      position = position_nudge(y = 0.25),
      color = pal_vals[4], hjust = -0.1, size = text_size, vjust = 0,
      fill = "transparent", family = "mono", fontface = "bold",
      label.size = unit(0, "lines"), label.padding = unit(0.05, "lines"),
      label.r = unit(0, "lines")
    ) +
    theme_void() +
    theme(
      legend.position = "none",
      plot.margin = margin(0, 0, 0, 0, "pt"),
      plot.background = element_blank(),
      panel.background = element_blank()
    ) +
    coord_cartesian(ylim = c(0.9, 1.5), xlim = ext_range)

  out_name <- file.path(tempfile(
    pattern = "file", tmpdir = tempdir(),
    fileext = ".svg"
  ))

  ggsave(out_name,
    plot = plot_out, dpi = 25.4, height = 5, width = width,
    units = "mm", device = "svg"
  )

  img_plot <- readLines(out_name) %>%
    paste0(collapse = "") %>%
    gt::html()

  on.exit(file.remove(out_name), add=TRUE)

  img_plot
}
