#' Add bar plots into rows of a `gt` table
#' @description
#' The `gt_plt_bar` function takes an existing `gt_tbl` object and
#' adds horizontal barplots via `ggplot2`. Note that values are plotted on a
#' shared x-axis, and a vertical black bar is added at x = zero.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column A single column wherein the bar plot should replace existing data.
#' @param color A character representing the color for the bar, defaults to purple. Accepts a named color (eg `'purple'`) or a hex color.
#' @param ... Additional arguments passed to `scales::label_number()` or `scales::label_percent()`, depending on what was specified in `scale_type`
#' @param keep_column `TRUE`/`FALSE` logical indicating if you want to keep a copy of the "plotted" column as raw values next to the plot itself..
#' @param width An integer indicating the width of the plot in pixels.
#' @param scale_type A string indicating additional text formatting and the addition of numeric labels to the plotted bars if not `'none'`. If `'none'`, no numbers will be added to the bar, but if `"number"` or `"percent"` are used, then the numbers in the plotted column will be added as a bar-label and formatted according to `scales::label_percent()` or `scales::label_number()`.
#' @param text_color A string indicating the color of text if `scale_type` is used. Defaults to `"white"`
#' @return An object of class `gt_tbl`.
#' @export
#' @section Examples:
#' ```r
#' library(gt)
#' gt_plt_bar_tab <- mtcars %>%
#'   head() %>%
#'   gt() %>%
#'   gt_plt_bar(column = mpg, keep_column = TRUE)
#' ```
#'
#' \if{html}{\figure{gt_plt_bar.png}{options: width=100\%}}
#'
#' @family Plotting
#' @section Function ID:
#' 3-4

gt_plt_bar <- function(gt_object,
                       column = NULL,
                       color = "purple",
                       ...,
                       keep_column = FALSE,
                       width = 70,
                       scale_type = "none",
                       text_color = "white") {
  stopifnot(
    "'gt_object' must be a 'gt_tbl',
            have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object)
  )
  stopifnot(
    "`scale_type` must be one of 'number', 'percent' or 'none'" =
      scale_type %in% c("number", "percent", "none")
  )

  var_sym <- rlang::enquo(column)
  var_bare <- rlang::as_label(var_sym)
  col_bare <- var_bare

  all_vals <- gt_index(gt_object, {{ column }}) %>%
    unlist()

  # need to handle truly empty cols
  if (length(all_vals) == 0) {
    return(gt_object)
  }

  stopifnot(
    "Colors must be either length 1 or equal length to the column" =
      isTRUE(length(color) == 1 | length(color) == length(all_vals))
  )

  stopifnot("'text_color' must be length 1" = length(text_color) == 1)

  if (length(color) == 1) {
    colors <- rep(color, length(all_vals))
  } else if (length(color) == length(all_vals)) {
    colors <- color
  }

  if ((min(all_vals, na.rm = TRUE) >= 0)) {
    min_val <- 0
    rng_multiplier <- c(0.98, 1.02)
  } else {
    min_val <- min(all_vals, na.rm = TRUE)
    rng_multiplier <- c(1.02, 1.02)
  }

  total_rng <- c(min_val, max(all_vals, na.rm = TRUE)) * rng_multiplier

  if (isTRUE(keep_column)) {
    gt_object <- gt_object %>%
      gt_duplicate_column({{ column }}, dupe_name = "DUPE_COLUMN_PLT")
  }

  bar_fx <- function(x_val, colors) {
    if (x_val %in% c("NA", "NULL")) {
      return("<div></div>")
    }


    vals <- as.double(x_val)

    df_in <- dplyr::tibble(
      x = vals,
      y = rep(1),
      fill = colors
    )

    plot_out <- df_in %>%
      ggplot(
        aes(
          x = .data$x,
          y = factor(.data$y),
          fill = I(.data$fill),
          group = .data$y
        )
      ) +
      geom_col(color = "transparent", width = 0.3) +
      scale_x_continuous(
        limits = total_rng,
        expand = expansion(mult = c(0.05, 0.08)),
      ) +
      scale_y_discrete(expand = expansion(mult = c(0.2, 0.2))) +
      geom_vline(xintercept = 0, color = "black", linewidth = 1) +
      coord_cartesian(clip = "off") +
      theme_void() +
      theme(legend.position = "none", plot.margin = unit(rep(0, 4), "pt"))

    if (scale_type != "none") {
      plot_out <- plot_out +
        geom_text(
          aes(
            x = .data$x,
            label = if (scale_type == "number") {
              scales::label_number(...)(.data$x)
            } else if (scale_type == "percent") {
              scales::label_percent(...)(.data$x)
            },
            hjust = ifelse(.data$x >= 0, 1, 0)
          ),
          nudge_x = sign(df_in$x) * (-1) / 80,
          vjust = 0.5,
          size = 3,
          family = "mono",
          color = text_color,
          fontface = "bold"
        )
    }

    out_name <- file.path(tempfile(
      pattern = "file",
      tmpdir = tempdir(),
      fileext = ".svg"
    ))

    ggsave(
      out_name,
      plot = plot_out,
      dpi = 25.4,
      height = 5,
      width = width,
      units = "mm",
      device = "svg"
    )

    img_plot <- readLines(out_name) %>%
      paste0(collapse = "") %>%
      gt::html()

    on.exit(file.remove(out_name), add = TRUE)

    img_plot
  }


  tab_out <- text_transform(
    gt_object,
    locations = if (isTRUE(keep_column)) {
      cells_body(columns = c(DUPE_COLUMN_PLT))
    } else {
      cells_body(columns = {{ column }})
    },
    fn = function(x) {
      tab_built <- mapply(bar_fx, x_val = x, colors = colors)
    }
  )

  if (isTRUE(keep_column)) {
    tab_out %>%
      cols_label(DUPE_COLUMN_PLT = col_bare) %>%
      cols_align("left", columns = c(DUPE_COLUMN_PLT))
  } else {
    tab_out %>%
      cols_align("left", columns = {{ column }})
  }
}
