#' Add sparklines into rows of a `gt` table
#' @description
#' The `gt_sparkline` function takes an existing `gt_tbl` object and
#' adds sparklines via the `ggplot2`. This is a wrapper around
#' `gt::text_transform()` + `ggplot2` with the necessary boilerplate already applied.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column wherein the sparkline plot should replace existing data. Note that the data *must* be represented as a list of numeric values ahead of time.
#' @param line_color Color for the line, defaults to `"lightgrey"`. Accepts a named color (eg 'blue') or a hex color.
#' @param range_colors A vector of two valid color names or hex codes, the first color represents the min values and the second color represents the highest point per plot. Defaults to `c("blue", "blue")`. Accepts a named color (eg `'blue'`) or a hex color like `"#fafafa"`.
#' @param same_lim A logical indicating that the plots will use the same y-axis range (`TRUE`) or have individual y-axis ranges (`FALSE`).
#' @return An object of class `gt_tbl`.
#' @importFrom gt %>%
#' @export
#' @import gt ggplot2 dplyr
#' @examples
#'  library(gt)
#'  gt_sparkline_tab <- mtcars %>%
#'     dplyr::group_by(cyl) %>%
#'     # must end up with list of data for each row in the input dataframe
#'     dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
#'     gt() %>%
#'     gt_sparkline(mpg_data)
#'
#' @section Figures:
#' \if{html}{\figure{ggplot2-sparkline.png}{options: width=20\%}}
#'
#' @family Plotting
#' @section Function ID:
#' 1-4

gt_sparkline <- function(
  gt_object, column,
  line_color = "lightgrey",
  range_colors = c("red", "blue"),
  same_limit = FALSE
) {

  # convert tidyeval column to bare string
  col_bare <- rlang::enexpr(column) %>% rlang::as_string()
  # segment data with bare string column name
  data_in = gt_object[["_data"]][[col_bare]]

  stopifnot("Specified column must contain list of values" = class(data_in) %in% "list")
  stopifnot("You must supply two colors for the max and min values." = length(range_colors) == 2L)

  # convert to a single vector
  data_in <- unlist(data_in)
  # range to be used for plotting if same axis
  total_rng <- range(data_in, na.rm = TRUE)

  plot_fn_spark <- function(x){

    vals <- strsplit(x, split = ", ") %>%
      unlist() %>%
      as.double()

    max_val <- max(vals, na.rm = TRUE)
    min_val <- min(vals, na.rm = TRUE)

    x_max <- vals[vals==max_val]
    x_min <- vals[vals==min_val]

    point_data <- dplyr::tibble(
      x = c(
        c(1:length(vals))[vals == min_val],
        c(1:length(vals))[vals == max_val]
      ),
      y = c(x_min, x_max),
      colors = c(rep(range_colors[1], length(x_min)), rep(range_colors[2], length(x_max)))
    )

    input_data <- dplyr::tibble(
      x = 1:length(vals),
      y = vals
    )

    plot_base <- ggplot(input_data) +
      theme_void()  +
      coord_cartesian(clip = "off")

      if(isTRUE(same_limit)){
        plot_base <- plot_base +
          scale_y_continuous(limits = total_rng,
                             expand = expansion(mult = 0.2))
      } else {
        plot_base <- plot_base +
          scale_y_continuous(limits = range(vals, na.rm = TRUE),
                             expand = expansion(mult = 0.2))
      }

      plot_out <- plot_base +
        geom_line(aes(x = x, y = y), size =0.5, color = line_color) +
        geom_point(data = point_data,
                   aes(x = x, y = y, color = I(colors)), size = 0.5)

    out_name <- file.path(
      tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".svg")
    )

    ggsave(out_name, plot = plot_out,
           dpi = 20, height = 0.15, width = 0.9)

    img_plot <- out_name %>%
      readLines() %>%
      paste0(collapse = "") %>%
      gt::html()

    on.exit(file.remove(out_name))

    img_plot

  }

  text_transform(
    gt_object,
    locations = cells_body(columns = {{ column }}),
    fn = function(x){
      lapply(
        x, plot_fn_spark
      )
    }
  )

}
