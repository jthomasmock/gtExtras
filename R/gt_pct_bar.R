#' Add a percent stacked barchart in place of existing data.
#' @description
#' The `gt_plt_bar_stack` function takes an existing `gt_tbl` object and
#' converts the existing values into a percent stacked barchart. The bar chart
#' will represent either 2 or 3 user-specified values per row, and requires
#' a list column ahead of time. The palette and labels need to be equal length.
#' The values must either add up to 100 ie as percentage points if using
#' `position = 'fill'`, or can be raw values with `position = 'stack'`. Note that
#' the labels can be controlled via the `fmt_fn` argument and the
#' `scales::label_???()` family of function.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column wherein the percent stacked barchart should replace existing data. Note that the data *must* be represented as a list of numeric values ahead of time.
#' @param palette A color palette of length 2 or 3, represented either by hex colors (`"#ff4343"`) or named colors (`"red"`).
#' @param labels A vector of strings of length 2 or 3, representing the labels for the bar chart, will be colored according to the palette as well.
#' @param position An string indicator passed to `ggplot2` indicating if the bar should be a percent of total `"fill"` or stacked as the raw values `"stack"`.
#' @param width An integer representing the width of the bar chart in pixels.
#' @param fmt_fn A specific function from `scales::label_???` family. Defaults to `scales::label_number()`
#' @param font A string representing the font family of the numbers of the bar labels. Defaults to `mono`.
#' @return An object of class `gt_tbl`.
#' @export
#' @family Plotting
#' @section Examples:
#'
#' ```r
#' library(gt)
#' library(dplyr)
#'
#' ex_df <- dplyr::tibble(
#'   x = c("Example 1","Example 1",
#'         "Example 1","Example 2","Example 2","Example 2",
#'         "Example 3","Example 3","Example 3","Example 4","Example 4",
#'         "Example 4"),
#'   measure = c("Measure 1","Measure 2",
#'               "Measure 3","Measure 1","Measure 2","Measure 3",
#'               "Measure 1","Measure 2","Measure 3","Measure 1","Measure 2",
#'               "Measure 3"),
#'   data = c(30, 20, 50, 30, 30, 40, 30, 40, 30, 30, 50, 20)
#' )
#'
#'
#' tab_df <- ex_df %>%
#'   group_by(x) %>%
#'   summarise(list_data = list(data))
#'
#' tab_df
#'
#' ex_tab <- tab_df %>%
#'   gt() %>%
#'   gt_plt_bar_stack(column = list_data)
#' ```
#' \if{html}{\figure{plt-bar-stack.png}{options: width=70\%}}

gt_plt_bar_stack <- function(
  gt_object,
  column = NULL,
  palette = c("#ff4343", "#bfbfbf", "#0a1c2b"),
  labels = c("Group 1", "Group 2", "Group 3"),
  position = "fill",
  width = 70,
  fmt_fn = scales::label_number(scale_cut = cut_short_scale(), trim = TRUE),
  font = "mono"
) {
  stopifnot("Table must be of class 'gt_tbl'" = "gt_tbl" %in% class(gt_object))
  stopifnot("There must be 2 or 3 labels" = (length(labels) %in% c(2:3)))
  stopifnot(
    "There must be 2 or 3 colors in the palette" = (length(palette) %in% c(2:3))
  )
  stopifnot(
    "`position` must be one of 'stack' or 'fill'" = (position %in%
      c("stack", "fill"))
  )

  var_sym <- rlang::enquo(column)
  var_bare <- rlang::as_label(var_sym)

  all_vals <- gt_index(gt_object, {{ column }}) %>%
    lapply(X = ., FUN = sum, na.rm = TRUE) %>%
    unlist()

  if (length(all_vals) == 0) {
    return(gt_object)
  }

  total_rng <- max(all_vals, na.rm = TRUE)

  tab_out <- text_transform(
    gt_object,
    locations = cells_body({{ column }}),
    fn = function(x) {
      bar_fx <- function(x_val) {
        if (x_val %in% c("NA", "NULL")) {
          return("<div></div>")
        }

        col_pal <- palette

        vals <- strsplit(x_val, split = ", ") %>%
          unlist() %>%
          as.double()

        n_val <- length(vals)

        stopifnot("There must be 2 or 3 values" = (n_val %in% c(2, 3)))

        col_fill <- if (n_val == 2) {
          c(1, 2)
        } else {
          c(1:3)
        }

        df_in <- dplyr::tibble(
          x = vals,
          y = rep(1, n_val),
          fill = col_pal[col_fill]
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
          geom_col(position = position, color = "white", width = 1) +
          geom_text(
            aes(label = fmt_fn(x)),
            hjust = 0.5,
            size = 3,
            family = font,
            position = if (position == "fill") {
              position_fill(vjust = .5)
            } else if (position == "stack") {
              position_stack(vjust = .5)
            },
            color = "white"
          ) +
          scale_x_continuous(
            expand = if (position == "stack") {
              expansion(mult = c(0, 0.1))
            } else {
              c(0, 0)
            },
            limits = if (position == "stack") {
              c(0, total_rng)
            } else {
              NULL
            }
          ) +
          scale_y_discrete(expand = c(0, 0)) +
          coord_cartesian(clip = "off") +
          theme_void() +
          theme(
            legend.position = "none",
            plot.margin = margin(0, 0, 0, 0, "pt")
          )

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

      tab_built <- lapply(X = x, FUN = bar_fx)
    }
  )

  label_built <- if (length(labels) == 2) {
    lab_pal1 <- palette[1]
    lab_pal2 <- palette[2]

    lab1 <- labels[1]
    lab2 <- labels[2]

    glue::glue(
      "<span style='color:{lab_pal1}'><b>{lab1}</b></span>",
      "||",
      "<span style='color:{lab_pal2}'><b>{lab2}</b></span>"
    ) %>%
      gt::html()
  } else {
    lab_pal1 <- palette[1]
    lab_pal2 <- palette[2]
    lab_pal3 <- palette[3]

    lab1 <- labels[1]
    lab2 <- labels[2]
    lab3 <- labels[3]

    glue::glue(
      "<div><span style='color:{lab_pal1}'><b>{lab1}</b></span>",
      "||",
      "<span style='color:{lab_pal2}'><b>{lab2}</b></span>",
      "||",
      "<span style='color:{lab_pal3}'><b>{lab3}</b></span></div>"
    ) %>%
      gt::html()
  }

  # Get the columns supplied in `columns` as a character vector
  tab_out <-
    dt_boxhead_edit_column_label(
      data = tab_out,
      var = var_bare,
      column_label = label_built
    )
  suppressWarnings(
    tab_out %>%
      # format the label 'column' as gt::html
      cols_label(
        {{ column }} := gt::html(label_built)
      )
  )
}
