#' Add a dumbbell plot in place of two columns
#'
#' @param gt_object an existing gt_tbl or pipeline
#' @param col1 column 1, plot will replace this column
#' @param col2 column 2, will be hidden
#' @param label an optional new label for the transformed column
#' @param palette must be 3 colors in order of col1, col2, bar color
#' @param width width in mm, defaults to 70
#' @param text_args A list of named arguments. Optional text arguments passed as a list to `scales::label_number`.
#' @param text_size A number indicating the size of the text indicators in the plot. Defaults to 1.5. Can also be set to `0` to "remove" the text itself.
#'
#' @return a gt_object table
#' @export
#'
#' @section Examples:
#' ```r
#' head(mtcars) %>%
#'   gt() %>%
#'   gt_plt_dumbbell(disp, mpg)
#' ```
#' @section Figures:
#' \if{html}{\figure{gt_plt_dumbell.png}{options: width=70\%}}
gt_plt_dumbbell <- function(
  gt_object,
  col1 = NULL,
  col2 = NULL,
  label = NULL,
  palette = c("#378E38", "#A926B6", "#D3D3D3"),
  width = 70,
  text_args = list(accuracy = 1),
  text_size = 2.5
) {
  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))
  stopifnot("'palette' must be 3 colors in order of col1, col2, bar color" = length(palette) == 3)

  if (rlang::quo_is_null(rlang::enquo(col1)) | rlang::quo_is_null(rlang::enquo(col2))) {
    stop("'col1' and 'col2' must be specified")
  }

  # extract the values from specified columns
  df_in <- gtExtras::gt_index(gt_object, {{ col1 }}, as_vector = FALSE) %>%
    dplyr::select(x1 = {{ col1 }}, x2 = {{ col2 }})

  if (length(df) == 0) {
    return(gt_object)
  }

  all_vals <- df_in %>%
    unlist() %>%
    as.vector()

  rng_val <- range(all_vals, na.rm = TRUE)

  tab_out <- gt_object %>%
    text_transform(
      locations = cells_body({{ col1 }}),
      fn = function(x) {
        dumbbell_fx <- function(col1_vals, col2_vals, text_args, text_size) {
          all_df_in_vals <- c(col1_vals, col2_vals)

          if (any(is.na(all_df_in_vals)) | any(is.null(all_df_in_vals))) {
            return("<div></div>")
          }

          df_vals <- dplyr::tibble(x1 = col1_vals, x2 = col2_vals)

          # TODO: revisit horizontal adjustment
          hjust_val <- ifelse(col1_vals >= col2_vals, list(1,0), list(0,1))

          plot_obj <- ggplot(df_vals, aes(y = "y1")) +
            geom_segment(
              aes(x = x1, xend = x2, yend = "y1"),
              linewidth = 1.5,
              color = palette[3]
            ) +
            geom_point(
              aes(x = x1),
              color = "white",
              pch = 21,
              fill = palette[1],
              size = 3,
              stroke = 1.25
            ) +
            geom_point(
              aes(x = x2),
              color = "white",
              pch = 21,
              fill = palette[2],
              size = 3,
              stroke = 1.25
            ) +
            geom_text(
              aes(
                x = x1, y = 1.05,
                label = do.call(scales::label_number, text_args)(x1),
                ),
              # TODO: revisit horizontal adjustment
                # hjust = hjust_val[[1]],
              family = "mono",
              color = palette[1],
              size = text_size,

            ) +
            geom_text(
              aes(
                x = x2, y = 1.05,
                label = do.call(scales::label_number, text_args)(x2),
              ),
              # TODO: revisit horizontal adjustment
              # hjust = hjust_val[[2]],
              family = "mono",
              color = palette[2],
              size = text_size
            ) +
            coord_cartesian(xlim = rng_val) +
            scale_x_continuous(expand = expansion(mult = c(0.1, 0.1))) +
            scale_y_discrete(expand = expansion(mult = c(0.03, 0.095))) +
            theme(
              legend.position = "none",
              plot.margin = margin(0, 0, 0, 0, "pt"),
              plot.background = element_blank(),
              panel.background = element_blank()
            ) +
            theme_void()

          save_svg(plot_obj, height = 7, width = width, units = "mm")
        }

        tab_built <- mapply(
          dumbbell_fx,
          df_in[[1]],
          df_in[[2]],
          list(text_args),
          text_size,
          SIMPLIFY = FALSE
        )
        tab_built
      }
    ) %>%
    gt::cols_align(align = "left", columns = {{ col1 }}) %>%
    gt::cols_hide({{ col2 }})

  if(!is.null(label)){

    return(
      tab_out %>%
        cols_label({{ col1 }} := label)
    )
  }

  tab_out


}

