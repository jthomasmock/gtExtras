#' Create an inline 'bullet chart' in a gt table
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column where a 'bullet chart' will replace the inline values.
#' @param target The column indicating the target values that will be represented by a vertical line
#' @param width Width of the plot in pixels
#' @param color Color of the bar, defaults to `"grey"`, can use named colors or hex colors.
#' @param target_color Color of the target vertical line, defaults to `"red"`, can use named colors or hex colors.
#' @param keep_column Logical indicating whether to duplicate the column for the plot.
#' @param keep_target Logical indicating whether to keep (`TRUE`) or hide the target column (`FALSE`)
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
#'                color = "lightblue", target_color = "black") %>%
#'  gt_theme_538()
#'
#' @section Figures:
#' \if{html}{\figure{gt_bullet.png}{options: width=100\%}}
#'
#' @family Themes
#' @section Function ID:
#' 3-6
gt_plt_bullet <- function(gt_object, column = NULL, target = NULL, width = 65,
                          keep_column = FALSE, keep_target = FALSE,
                          color = "grey", target_color = "red"){

  col_bare <- rlang::enexpr(column) %>% rlang::as_string()
  raw_data <- gt:::dt_data_get(gt_object)

  all_vals <- raw_data[[col_bare]]
  max_val <- max(all_vals, na.rm = TRUE)
  length_val <- length(all_vals)

  tar_col_bare <- rlang::enexpr(target) %>% rlang::as_string()
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

  if (isTRUE(keep_column)) {

    # core concept is that we are adding a duplicate column
    # which takes the place of the original column
    # this will be "kept" in place as the original gets overwritten as a plot
    dupe_name <- paste0(col_bare, "_dupe")
    col_name_replace <- paste0(col_bare, "_plt")

    col_bare_index <- which(tab_out[["_boxhead"]][["var"]] == col_bare)

    tab_out[["_data"]] <- tab_out[["_data"]] %>%
      dplyr::mutate(!!dupe_name := {{ column }}, .before = {{ column }}) %>%
      dplyr::rename(
        !!col_name_replace := col_bare,
        !!col_bare := !!dupe_name
      )

    tab_out[["_boxhead"]] <- tab_out[["_boxhead"]] %>%
      mutate(column_label = dplyr::if_else(
        var == !!col_bare,
        list(!!col_name_replace),
        column_label
      ))


    tab_out <- gt:::dt_boxhead_add_var(
      data = tab_out,
      var = col_name_replace,
      type = "default",
      column_label = list(col_bare),
      column_align = "left",
      column_width = list(NULL),
      hidden_px = list(NULL),
      add_where = "bottom"
    )

    tab_out <- tab_out %>%
      cols_move(columns = col_bare, after = col_name_replace) %>%
      cols_align(align = "left", columns = {{ column }})

    if (isTRUE(keep_target)) {
      tab_out
    } else {
      tab_out %>%
        cols_hide(columns = {{ target }})
    }
  } else {
    if (isTRUE(keep_target)) {
      tab_out %>%
        cols_align(align = "left", columns = {{ column }})
    } else {
      tab_out %>%
        cols_align(align = "left", columns = {{ column }}) %>%
        cols_hide(columns = {{ target }})
    }
  }

}




