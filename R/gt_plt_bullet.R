#' Create an inline 'bullet chart' in a gt table
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column where a 'bullet chart' will replace the inline values.
#' @param target_col The column indicating the target values that will be represented by a vertical line
#' @param width Width of the plot in pixels
#' @param color Color of the bar, defaults to `"grey"`, can use named colors or hex colors.
#' @param target_color Color of the target vertical line, defaults to `"red"`, can use named colors or hex colors.
#'
#' @return An object of class `gt_tbl`.
#' @import gt ggplot2 rlang
#' @export
#'
#' @examples
#' library(gt)
#' set.seed(37)
#'
#' bullet_tab <- tibble::rownames_to_column(mtcars) %>%
#'  dplyr::select(rowname, cyl:drat, mpg) %>%
#'  dplyr::group_by(cyl) %>%
#'  dplyr::mutate(target_col = mean(mpg)) %>%
#'  dplyr::slice_sample(n = 3) %>%
#'  dplyr::ungroup() %>%
#'  gt() %>%
#'  gt_plt_bullet(column = mpg, target_col = target_col, width = 45,
#'                color = "lightblue", target_color = "black") %>%
#'  gt_theme_538()
#'
#' @section Figures:
#' \if{html}{\figure{gt_bullet.png}{options: width=100\%}}
#'
#' @family Themes
#' @section Function ID:
#' 1-6
gt_plt_bullet <- function(gt_object, column = NULL, target_col = NULL, width = 65,
                          color = "grey", target_color = "red"){

  col_bare <- rlang::enexpr(column) %>% rlang::as_string()
  raw_data <- gt:::dt_data_get(gt_object)

  all_vals <- raw_data[[col_bare]]
  max_val <- max(all_vals, na.rm = TRUE)
  length_val <- length(all_vals)

  tar_col_bare <- rlang::enexpr(target_col) %>% rlang::as_string()
  target_vals <- raw_data[[tar_col_bare]]

  tab_out <- text_transform(
    gt_object,
    locations = cells_body({{ column }}),
    fn = function(x) {
      bar_fx <- function(x_val, target_vals) {
        col_pal <- palette

        vals <- as.double(x_val)

        plot_out <- ggplot(data = NULL, aes(x = vals, y = factor("1"))) +
          geom_col(width = 0.1, color = color, fill = color) +
          geom_vline(xintercept = target_vals, color = target_color, size = 1.5,
                     alpha = 0.7) +
          geom_vline(xintercept = 0, color = "black", size = 1) +
          theme_void() +
          coord_cartesian(xlim = c(0, max_val)) +
          scale_x_continuous(expand = expansion(mult = c(0, 0.1))) +
          scale_y_discrete(expand = expansion(mult = c(0.1, 0.1))) +
          theme_void() +
          theme(legend.position = "none", plot.margin = unit(rep(0, 4), "pt"),
                plot.background = element_blank(),
                panel.background = element_blank())

        out_name <- file.path(tempfile(
          pattern = "file",
          tmpdir = tempdir(),
          fileext = ".svg"
        ))

        ggsave(
          out_name,
          plot = plot_out,
          dpi = 30,
          height = 6,
          width = width,
          units = "px"
        )

        img_plot <- readLines(out_name) %>%
          paste0(collapse = "") %>%
          gt::html()

        on.exit(file.remove(out_name))

        img_plot
      }

      tab_built <- mapply(FUN = bar_fx, x,target_vals)
      tab_built
    }
  )

  tab_out %>%
    cols_align(align = "left", columns = {{ column }}) %>%
    cols_hide(columns = {{ target_col }})


}




