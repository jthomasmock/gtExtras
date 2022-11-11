#' @title Add a color dot and thin bar chart to a table
#' @description This function takes a data column and a categorical column and
#' adds a colored dot and a colored dot to the categorical column. You can supply
#' a specific palette or a palette from the `{paletteer}` package.
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column which supplies values to create the inline bar plot
#' @param category_column The category column, where a colored dot and bar will be added
#' @param palette The colors or color function that values will be mapped to. Can be a character vector (eg `c("white", "red")` or hex colors) or a named palette from the `{paletteer}` package.
#' @param max_value A single numeric value indicating the max value, if left as `NULL` then the range of the `column` values will be used
#' @import gt
#' @return a `gt_tbl`
#' @export
#' @section Examples:
#' ```r
#' library(gt)
#' dot_bar_tab <- mtcars %>%
#'   head() %>%
#'   dplyr::mutate(cars = sapply(strsplit(rownames(.)," "), `[`, 1)) %>%
#'   dplyr::select(cars, mpg, disp) %>%
#'   gt() %>%
#'   gt_plt_dot(disp, cars, palette = "ggthemes::fivethirtyeight") %>%
#'   cols_width(cars ~ px(125))
#' ```
#' @section Figures:
#' \if{html}{\figure{gt_dot_bar.png}{options: width=50\%}}
#'
#' @family Themes

gt_plt_dot <- function(gt_object, column, category_column, palette = NULL,
                       max_value = NULL) {
  stopifnot("Table must be of class 'gt_tbl'" = "gt_tbl" %in% class(gt_object))

  # segment data with bare string column name
  cat_data_in <- gt_index(gt_object, {{ category_column }})

  cat_levels <- unique(cat_data_in)

  data_in <- gt_index(gt_object, {{ column }})

  total_max <- max(data_in, na.rm = TRUE)

  if (length(palette) == 1) {
    if (grepl(x = palette, pattern = "::", fixed = TRUE)) {
      palette <- paletteer::paletteer_d(
        palette = palette
      ) %>% as.character()
    } else {
      palette <- palette %>% rep(length(cat_levels))
    }
  } else if (is.null(palette)) {
    palette <- c(
      "#762a83", "#af8dc3", "#e7d4e8", "#f7f7f7",
      "#d9f0d3", "#7fbf7b", "#1b7837"
    )
  } else {
    palette <- palette
  }

  bar_chart <- function(value, fill = "red") {
    max_x <- if (is.null(max_value)) {
      max(as.double(data_in), na.rm = TRUE)
    } else {
      max_value
    }
    bar <- lapply(value, function(x) {
      scaled_value <- as.double(x) / max_x * 100

      glue::glue(
        "<div style='background:{fill};width:{scaled_value}%;height:4px;border-radius: 2px'></div>"
      )
    })

    chart <- lapply(bar, function(bar) {
      glue::glue(
        "<div style='flex-grow:1;margin-left:0px;'>{bar}</div>"
      ) %>%
        as.character() %>%
        gt::html()
    })

    chart
  }

  color_dots <- function(x) {
    if (x %in% c("NA", "NULL")) {
      return("<div></div>")
    }

    split_cols <- strsplit(x, "^split^", fixed = TRUE) %>% unlist()

    category_label <- split_cols[1]
    val_x <- split_cols[2]

    colors <- scales::col_factor(
      palette = palette,
      domain = NULL,
      levels = cat_levels
    )(category_label)

    htmltools::div(
      htmltools::div(
        category_label,
        style = paste0(
          "display:inline-block;float:left;",
          "margin-right:0px;"
        ),
        htmltools::div(
          style = paste0(
            glue::glue("height: 0.7em;width: 0.7em;background-color: {colors};"),
            "border-radius: 50%;margin-top:4px;display:inline-block;",
            "float:left;margin-right:2px;"
          )
        ),
        htmltools::div(
          style = paste0(
            "display: inline-block;float:right;line-height:20px;",
            "padding: 0px 2.5px;"
          )
        )
      ),
      htmltools::div(htmltools::div(bar_chart(val_x, fill = colors)),
        style = "position: relative;top: 1.2em;"
      )
    ) %>%
      as.character() %>%
      gt::html()
  }

  gt_object %>%
    gt::cols_merge(
      c({{ category_column }}, {{ column }}),
      pattern = "{1}^split^{2}",
      hide_columns = FALSE
    ) %>%
    gt::text_transform(
      locations = cells_body({{ category_column }}),
      fn = function(xz) {
        lapply(xz, color_dots)
      }
    )
}
