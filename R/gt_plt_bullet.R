#' Create an inline 'bullet chart' in a gt table
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column where a 'bullet chart' will replace the inline values.
#' @param target The column indicating the target values that will be represented by a vertical line
#' @param width Width of the plot in pixels
#' @param palette Color of the bar and target line, defaults to `c("grey", "red")`, can use named colors or hex colors. Must be of length two, and the first color will always be used as the bar color.
#' @return An object of class `gt_tbl`.
#' @export
#'
#' @section Examples:
#'
#' ```r
#' set.seed(37)
#' bullet_tab <- tibble::rownames_to_column(mtcars) %>%
#'  dplyr::select(rowname, cyl:drat, mpg) %>%
#'  dplyr::group_by(cyl) %>%
#'  dplyr::mutate(target_col = mean(mpg)) %>%
#'  dplyr::slice_sample(n = 3) %>%
#'  dplyr::ungroup() %>%
#'  gt::gt() %>%
#'  gt_plt_bullet(column = mpg, target = target_col, width = 45,
#'                palette = c("lightblue", "black")) %>%
#'  gt_theme_538()
#' ```
#' \if{html}{\figure{gt_bullet.png}{options: width=100\%}}
#'
#' @family Themes
#' @section Function ID:
#' 3-7
gt_plt_bullet <- function(gt_object, column = NULL, target = NULL, width = 65,
                          palette = c("grey", "red")) {
  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))
  stopifnot("'palette' must be 2 colors" = length(palette) == 2)

  # extract the values from specified columns
  all_vals <- gt_index(gt_object, {{ column }})

  if (length(all_vals) == 0) {
    return(gt_object)
  }

  max_val <- max(all_vals, na.rm = TRUE)
  length_val <- length(all_vals)

  target_vals <- gt_index(gt_object, {{ target }})

  col_bare <- gt_index(gt_object, {{ column }}, as_vector = FALSE) %>%
    dplyr::select({{ column }}) %>%
    names()

  tab_out <- gt_object %>%
    text_transform(
      locations = cells_body({{ column }}),
      fn = function(x) {
        bar_fx <- function(vals, target_vals) {
          if (is.na(vals) | is.null(vals)) {
            return("<div></div>")
          }

          if (is.na(target_vals)) {
            stop("Target Column not coercible to numeric, please create and supply an unformatted column ahead of time with gtExtras::gt_duplicate_columns()",
              call. = FALSE
            )
          }

          if (is.na(vals)) {
            stop("Column not coercible to numeric, please create and supply an unformatted column ahead of time with gtExtras::gt_duplicate_columns()",
              call. = FALSE
            )
          }

          plot_out <- ggplot(data = NULL, aes(x = vals, y = factor("1"))) +
            geom_col(width = 0.1, color = palette[1], fill = palette[1]) +
            geom_vline(
              xintercept = target_vals, color = palette[2], size = 1.5,
              alpha = 0.7
            ) +
            geom_vline(xintercept = 0, color = "black", size = 1) +
            theme_void() +
            coord_cartesian(xlim = c(0, max_val)) +
            scale_x_continuous(expand = expansion(mult = c(0, 0.15))) +
            scale_y_discrete(expand = expansion(mult = c(0.1, 0.1))) +
            theme_void() +
            theme(
              legend.position = "none",
              plot.margin = margin(0, 0, 0, 0, "pt"),
              plot.background = element_blank(),
              panel.background = element_blank()
            )

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

        tab_built <- mapply(bar_fx, all_vals, target_vals)
        tab_built
      }
    ) %>%
    gt::cols_align(align = "left", columns = {{ column }}) %>%
    gt::cols_hide({{ target }})

  tab_out
}
