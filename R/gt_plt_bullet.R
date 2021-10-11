#' Create an inline 'bullet chart' in a gt table
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column where a 'bullet chart' will replace the inline values.
#' @param target The column indicating the target values that will be represented by a vertical line
#' @param width Width of the plot in pixels
#' @param colors Color of the bar and target line, defaults to `c("grey", "red")`, can use named colors or hex colors. Must be of length two, and the first color will always be used as the bar color.
#' @param keep_column Logical indicating whether to keep a copy of the `column` as raw values, in addition to the bullet chart
#' @return An object of class `gt_tbl`.
#' @import gt ggplot2 rlang dplyr
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
#'  gt_plt_bullet(column = mpg, target = target_col, width = 45,
#'                colors = c("lightblue", "black")) %>%
#'  gt_theme_538()
#'
#' @section Figures:
#' \if{html}{\figure{gt_bullet.png}{options: width=100\%}}
#'
#' @family Themes
#' @section Function ID:
#' 3-7
gt_plt_bullet <- function(gt_object, column = NULL, target = NULL, width = 65,
                          keep_column = FALSE, colors = c("grey", "red")){

  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))
  stopifnot("'colors' must be 2 colors" = length(colors) == 2)

  col_bare <- rlang::enexpr(column) %>% rlang::as_string()
  raw_data <- gt:::dt_data_get(gt_object)

  all_vals <- raw_data[[col_bare]]
  max_val <- max(all_vals, na.rm = TRUE)
  length_val <- length(all_vals)

  tar_col_bare <- rlang::enexpr(target) %>% rlang::as_string()
  target_vals <- raw_data[[tar_col_bare]]

  tab_out <- if (isFALSE(keep_column)) {
    cols_merge(
      gt_object,
      columns = c({{ target }}, {{ column }}),
      pattern = "{1}^split^{2}"
    )
  } else if (isTRUE(keep_column)) {
    gt_object %>%
      gt_duplicate_column({{column}}, dupe_name = "DUPE_COLUMN_PLT") %>%
      cols_merge(
      columns = c({{ target }}, DUPE_COLUMN_PLT),
      pattern = "{1}^split^{2}"
    )
  }

  tab_out <- tab_out %>%
    text_transform(
      locations = cells_body({{ target }}),
      fn = function(x) {
        bar_fx <- function(xz, target_vals) {

          if(xz %in% c("NA", "NULL")){
            return("<div></div>")
          }

          split_cols <- strsplit(xz, "^split^", fixed = TRUE) %>% unlist()

          target_vals <- as.double(split_cols[1])
          vals <- as.double(split_cols[2])


          if(is.na(target_vals)) {
            stop("Target Column not coercible to numeric, please create and supply an unformatted column ahead of time with gtExtras::gt_duplicate_columns()",
                 call. = FALSE)
          }

          if(is.na(vals)) {
            stop("Column not coercible to numeric, please create and supply an unformatted column ahead of time with gtExtras::gt_duplicate_columns()",
                 call. = FALSE)
          }

          plot_out <- ggplot(data = NULL, aes(x = vals, y = factor("1"))) +
            geom_col(width = 0.1, color = colors[1], fill = colors[1]) +
            geom_vline(xintercept = target_vals, color = colors[2], size = 1.5,
                       alpha = 0.7) +
            geom_vline(xintercept = 0, color = "black", size = 1) +
            theme_void() +
            coord_cartesian(xlim = c(0, max_val)) +
            scale_x_continuous(expand = expansion(mult = c(0, 0.15))) +
            scale_y_discrete(expand = expansion(mult = c(0.1, 0.1))) +
            theme_void() +
            theme(legend.position = "none",
                  plot.margin = margin(0,0,0,0, "pt"),
                  plot.background = element_blank(),
                  panel.background = element_blank())

          out_name <- file.path(tempfile(pattern = "file", tmpdir = tempdir(),
                                         fileext = ".svg"))

          ggsave(out_name, plot = plot_out, dpi = 25.4, height = 5, width = width,
                 units = "mm", device = "svg")

          img_plot <- readLines(out_name) %>%
            paste0(collapse = "") %>%
            gt::html()

          on.exit(file.remove(out_name))

          img_plot
        }

        tab_built <- lapply(X = x, FUN = bar_fx)
        tab_built
      }
    ) %>%
    gt::cols_align(align = "left", columns = {{ target }}) %>%
    gt::cols_label({{ target }} := col_bare)

  tab_out

}




