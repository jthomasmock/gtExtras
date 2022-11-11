#' Create a dot plot from any range - add_point_plot
#'
#' @param data The single value that will be used to plot the point.
#' @param palette A length 3 palette, used to highlight high/med/low
#' @param add_label A logical indicating whether to add the label or note. This will only be added if it is the first or last row.
#' @param width A numeric indicating the
#' @param vals_range vector of length two indicating range
#' @inheritParams scales::label_number
#'
#' @return gt table
add_point_plot <- function(data,
                           palette,
                           add_label,
                           width,
                           vals_range,
                           accuracy) {
  if (data %in% c("NA", "NULL", NA, NULL)) {
    return("<div></div>")
  } else {
    df_in <- dplyr::tibble(
      x = data,
      y = 1,
      color = palette
    )

    val_breaks <- seq(from = vals_range[1], to = vals_range[2], length.out = 4)
    break_labs <- scales::label_number(
      accuracy = accuracy,
      scale_cut = cut_short_scale()
    )(val_breaks[c(1, 4)])

    out_pt_plt <- ggplot(df_in) +
      geom_vline(
        xintercept = val_breaks,
        color = "grey",
        linewidth = 0.25
      ) +
      geom_hline(
        yintercept = 1,
        color = "lightgrey",
        linewidth = 0.25,
        linetype = "dotted"
      ) +
      geom_point(
        aes(x = .data$x, y = .data$y, fill = I(.data$color)),
        color = "black",
        size = 3,
        stroke = 0.5,
        shape = 21
      ) +
      theme_void() +
      coord_cartesian(
        xlim = vals_range,
        ylim = c(0.6, 1.2),
        clip = "off"
      )

    if (isTRUE(add_label)) {
      out_pt_plt <- out_pt_plt +
        geom_text(
          data = NULL,
          aes(x = val_breaks[1], y = .61, label = break_labs[1]),
          hjust = -0.1,
          vjust = 0,
          size = 1.5,
          family = "mono",
          color = "black"
        ) +
        geom_text(
          aes(x = val_breaks[4], y = .61, label = break_labs[2]),
          hjust = 1.1,
          vjust = 0,
          size = 1.5,
          family = "mono",
          color = "black"
        )
    } else {
      out_pt_plt <- out_pt_plt
    }

    out_name <- file.path(tempfile(
      pattern = "file",
      tmpdir = tempdir(),
      fileext = ".svg"
    ))

    ggsave(
      out_name,
      out_pt_plt,
      height = 5,
      width = width,
      dpi = 25.4,
      units = "mm",
      device = "svg"
    )

    img_plot <- readLines(out_name) %>%
      paste0(collapse = "") %>%
      gt::html()

    on.exit(file.remove(out_name), add = TRUE)

    img_plot
  }
}

#' Create a point plot in place of each value.
#' @description Creates a dot/point plot in each row. Can be used as an
#' alternative for a bar plot. Accepts any range of values, as opposed to
#' `gt_plt_percentile` which is intended to be used for values between 0 and 100.
#' @param gt_object An existing gt table
#' @param column The column to transform to the percentile dot plot. Accepts `tidyeval`. All values must be end up being between 0 and 100.
#' @param palette A vector of strings of length 3. Defaults to `c('blue', 'lightgrey', 'red')` as hex so `c("#007ad6", "#f0f0f0", "#f72e2e")`
#' @param width A numeric, indicating the width of the plot in `mm`, defaults to 25
#' @param scale A number to multiply/scale the values in the column by. Defaults to 1, but can also be 100 if you have decimals.
#' @param accuracy Accuracy of the number labels in the plot, passed to `scales::label_number()`
#' @return a gt table
#' @export
#'
#' @section Examples:
#' ```r
#' point_tab <- dplyr::tibble(x = c(seq(1.2e6, 2e6, length.out = 5))) %>%
#'   gt::gt() %>%
#'   gt_duplicate_column(x,dupe_name = "point_plot") %>%
#'   gt_plt_point(point_plot, accuracy = .1, width = 25) %>%
#'   gt::fmt_number(x, suffixing = TRUE, decimals = 1)
#' ```
#' @section Figures:
#' \if{html}{\figure{gt_plt_point.png}{options: width=30\%}}
#'
#' @family Plotting
#' @section Function ID:
#' 3-9
gt_plt_point <- function(gt_object,
                         column,
                         palette = c("#007ad6", "#f0f0f0", "#f72e2e"),
                         width = 25,
                         scale = 1,
                         accuracy = 1) {
  col_vals <- gt_index(gt_object, {{ column }})

  val_range <- scales::expand_range(
    range = range(col_vals, na.rm = TRUE),
    mul = 0.1
  )

  gt_object %>%
    text_transform(
      locations = cells_body({{ column }}),
      fn = function(x) {
        x <- as.double(x) * scale
        n_vals <- 1:length(x)

        col_pal <- scales::col_quantile(
          palette = palette,
          domain = val_range,
          reverse = TRUE,
          alpha = TRUE,
          n = 5
        )(x)

        add_label <- n_vals %in% c(min(n_vals), max(n_vals))

        mapply(
          add_point_plot,
          x,
          col_pal,
          add_label,
          width,
          list(val_range),
          accuracy,
          SIMPLIFY = FALSE
        )
      }
    )
}
