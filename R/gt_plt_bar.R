#' Add bar plots into rows of a `gt` table
#' @description
#' The `gt_plt_bar` function takes an existing `gt_tbl` object and
#' adds horizontal barplots via `ggplot2`. Note that values are plotted on a
#' shared x-axis, and a vertical black bar is added at x = zero.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column A single column wherein the bar plot should replace existing data.
#' @param color A character representing the color for the bar, defaults to purple. Accepts a named color (eg `'purple'`) or a hex color.
#' @param keep_column `TRUE`/`FALSE` logical indicating if you want to keep a copy of the "plotted" column as raw values next to the plot itself..
#' @param width An integer indicating the width of the plot in pixels.
#' @return An object of class `gt_tbl`.
#' @importFrom gt %>%
#' @export
#' @import gt ggplot2 rlang dplyr
#' @examples
#' library(gt)
#'  gt_plt_bar_tab <- mtcars %>%
#'    head() %>%
#'    gt() %>%
#'    gt_plt_bar(column = mpg, keep_column = TRUE)
#'
#' @section Figures:
#' \if{html}{\figure{gt_plt_bar.png}{options: width=100\%}}
#'
#' @family Plotting
#' @section Function ID:
#' 3-4

gt_plt_bar <- function(gt_object, column = NULL, color = "purple",
                       keep_column = FALSE, width = 70) {

  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = gt:::is_gt(gt_object))

  var_sym <- rlang::enquo(column)
  var_bare <- rlang::as_label(var_sym)
  col_bare <- var_bare

  all_vals <- gt_object[["_data"]] %>%
    dplyr::pull({{ column }}) %>%
    unlist()

  stopifnot("Colors must be either length 1 or equal length to the column" =
              isTRUE(length(color) == 1|length(color)==length(all_vals))
            )

  if(length(color) == 1){
    colors <- rep(color, length(all_vals))
  } else if(color == length(all_vals)){
    colors <- color
  }

  min_val <- ifelse(
    min(all_vals, na.rm = TRUE) > 0,
    0,
    min(all_vals, na.rm = TRUE)
    )
  total_rng <- c(min_val, max(all_vals, na.rm = TRUE))

  tab_out <- text_transform(
    gt_object,
    locations = cells_body({{ column }}),
    fn = function(x) {
      bar_fx <- function(x_val, colors) {

        vals <- as.double(x_val)

        df_in <- dplyr::tibble(
          x = vals,
          y = rep(1),
          fill = colors
        )

        plot_out <- df_in %>%
          ggplot(aes(x = x, y = factor(y), fill = I(fill), group = y)) +
          geom_col(color = "transparent", width = 0.3) +
          scale_x_continuous(
            expand = expansion(mult = c(0.01, 0.01)),
            limits = total_rng
          ) +
          scale_y_discrete(expand = expansion(mult = c(0.2, 0.2))) +
          geom_vline(xintercept = 0, color = "black", size = 1) +
          coord_cartesian(clip = "off") +
          theme_void() +
          theme(legend.position = "none", plot.margin = unit(rep(0, 4), "pt"))

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

      # tab_built <- lapply(X = x, FUN = bar_fx)
      tab_built <- mapply(bar_fx, x_val = x, colors = colors)
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
      dplyr::mutate(column_label = dplyr::if_else(
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
      cols_move(columns = all_of(col_bare), after = col_name_replace) %>%
      cols_align(align = "left", columns = {{ column }})
  } else {
    tab_out <- tab_out %>%
      cols_align(align = "left", columns = {{ column }})
  }

  tab_out

}

