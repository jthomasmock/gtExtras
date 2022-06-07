#' Create a dot plot from 0 to 100
#' @param data The single value that will be used to plot the point.
#' @param palette A length 3 palette, used to highlight high/med/low
#' @param add_label A logical indicating whether to add the label or note. This will only be added if it is the first or last row.
#' @param width A numeric indicating the
#' @return gt table
#'
add_pcttile_plot <- function(data, palette, add_label, width){

  if(data %in% c("NA", "NULL", NA, NULL)){ return("<div></div>")}
  stopifnot("Values must be between 0 and 100" = dplyr::between(data, 0, 100))

  df_in <- dplyr::tibble(
    x = data, y = 1, color = palette
  )

  out_pct_plt <- ggplot(df_in) +
    geom_vline(xintercept = 50, color = "black", size = 0.5) +
    geom_vline(xintercept = c(0,25,75,100), color = "grey", size = 0.25) +
    geom_hline(yintercept = 1, color = "lightgrey", size = 0.25, linetype = "dotted") +
    geom_point(aes(x = .data$x, y = .data$y, fill = I(.data$color)), color = "black", size = 3, stroke = 0.5,
               shape = 21) +
    theme_void() +
    coord_cartesian(xlim = c(0,100),
                    ylim = c(0.6, 1.2), clip = "off")

  if(isTRUE(add_label)){
    out_pct_plt <- out_pct_plt +
      geom_text(data = NULL,
        aes(x = 1, y = .61, label = "0"), hjust = 0,vjust = 0,
        size = 1.5, family = "mono", color = "black") +
      geom_text(aes(x = 99, y = 0.61, label = "100"), hjust = 1,vjust = 0,
                size = 1.5, family = "mono", color = "black") +
      geom_text(aes(x = 49, y = 0.61, label = "5"), hjust = 1, vjust = 0,
                size = 1.5, family = "mono", color = "black") +
      geom_text(aes(x = 51, y = 0.61, label = "0"), hjust = 0, vjust = 0,
                size = 1.5, family = "mono", color = "black")
  } else {
    out_pct_plt <- out_pct_plt
  }

  out_name <- file.path(tempfile(
    pattern = "file",
    tmpdir = tempdir(),
    fileext = ".svg"
  ))

  ggsave(out_name, out_pct_plt, height = 5, width = width,
         dpi = 25.4, units = "mm", device = "svg")

  img_plot <- readLines(out_name) %>%
    paste0(collapse = "") %>%
    gt::html()

  on.exit(file.remove(out_name), add=TRUE)

  img_plot

  }

#' Create a dot plot for percentiles
#' @description Creates a percentile dot plot in each row. Can be used as an
#' alternative for a 0 to 100% bar plot. Allows for scaling values as well and
#' accepts a vector of colors for the range of values.
#' @param gt_object An existing gt table
#' @param column The column to transform to the percentile dot plot. Accepts `tidyeval`. All values must be end up being between 0 and 100.
#' @param palette A vector of strings of length 3. Defaults to `c('blue', 'lightgrey', 'red')` as hex so `c("#007ad6", "#f0f0f0", "#f72e2e")`
#' @param width A numeric, indicating the width of the plot in `mm`, defaults to 25
#' @param scale A number to multiply/scale the values in the column by. Defaults to 1, but can also be 100 if you have decimals.
#' @return a gt table
#' @export
#'
#' @examples
#' library(gt)
#' dot_plt <- dplyr::tibble(x = c(seq(10, 90, length.out = 5))) %>%
#'   gt() %>%
#'   gt_duplicate_column(x,dupe_name = "dot_plot") %>%
#'   gt_plt_percentile(dot_plot)
#' @section Figures:
#' \if{html}{\figure{gt_plt_percentile.png}{options: width=30\%}}
#'
#' @family Plotting
#' @section Function ID:
#' 3-8
gt_plt_percentile <- function(gt_object, column,
                               palette = c("#007ad6", "#f0f0f0", "#f72e2e"),
                               width = 25, scale = 1) {
  gt_object %>%
    text_transform(
      locations = cells_body({{ column }}),
      fn = function(x) {
        x <- as.double(x) * scale
        n_vals <- 1:length(x)

        stopifnot("Values must be scaled between 0 and 100"= dplyr::between(x, 0, 100))

        col_pal <- scales::col_quantile(
          palette = palette, domain = c(0:100),
          reverse = TRUE, alpha = TRUE, n = 5)(x)

        add_label <- n_vals %in% c(min(n_vals), max(n_vals))

        mapply(add_pcttile_plot, x, col_pal, add_label, width, SIMPLIFY = FALSE)
      }
    )
}

