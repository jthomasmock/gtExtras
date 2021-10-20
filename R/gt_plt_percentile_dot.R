#' Create a dot plot from 0 to 100 - add_pcttile_plot
#'
#' @param data The single value that will be used to plot the point.
#' @param palette A length 3 palette, used to highlight high/med/low
#' @param add_label A logical indicating whether to add the label or note. This will only be added if it is the first or last row.
#' @param width A numeric indicating the
#' @import ggplot2
#' @import gt
#' @importFrom dplyr %>% mutate tibble between
#' @return gt table
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
    geom_point(aes(x = x, y = y, fill = I(color)), color = "black", size = 2, stroke = 0.5,
               shape = 21) +
    theme_void() +
    coord_cartesian(xlim = c(0,100),
                    ylim = c(0.6, 1.4), clip = "off")

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

  on.exit(file.remove(out_name))

  img_plot

  }

#' Create a dot plot for percentiles
#' @description Creates a percentile dot plot in each row. Can be used as an
#' alternative for a bar plot. Con
#' @param gt_object An existing gt table
#' @param column The column to transform to the percentile dot plot. Accepts `tidyeval`. All values must be end up being between 0 and 100.
#' @param palette A vector of strings of length 3. Defaults to `c('green', 'lightgrey', 'purple')` as hex so `c('#1b7837', 'lightgrey', '#762a83')`
#' @param width A numeric, indicating the width of the plot in `mm`, defaults to 25
#' @param scale A number to multiply/scale the values in the column by. Defaults to 1, but can also be 100 if you have decimals.
#' @import gt
#' @importFrom dplyr %>% between case_when
#' @return a gt table
#' @export
#'
#' @examples
#' library(gt)
#' dot_plt <- dplyr::tibble(x = c(seq(10, 90, length.out = 5))) %>%
#'   gt() %>%
#'   gt_duplicate_column(x,dupe_name = "dot_plot") %>%
#'   gt_percentile_dots(dot_plot)
#' @section Figures:
#' \if{html}{\figure{gt_plt_percentile.png}{options: width=30\%}}
#'
#' @family Plotting
#' @section Function ID:
#' 3-8
gt_plt_percentile <- function(gt_object, column,
                               palette = c('#1b7837', 'lightgrey', '#762a83'),
                               width = 25, scale = 1) {
  gt_object %>%
    text_transform(
      locations = cells_body({{ column }}),
      fn = function(x) {
        x <- as.double(x) * scale
        n_vals <- 1:length(x)

        col_pal = dplyr::case_when(
          dplyr::between(x, 25, 75) ~ palette[2],
          x < 25 ~ palette[3],
          x > 75 ~ palette[1]
        )

        add_label <- n_vals %in% c(min(n_vals), max(n_vals))

        mapply(add_pcttile_plot, x, col_pal, add_label, width, SIMPLIFY = FALSE)
      }
    )
}

