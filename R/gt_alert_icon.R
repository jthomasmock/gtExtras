#' Insert an alert icon to a specific column
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column wherein the numeric values should be replaced with circular alert icons.
#' @param palette The colours or colour function that values will be mapped to. Can be a character vector (eg `c("white", "red")` or hex colors) or a named palette from the `{paletteer}` package in the `package::palette_name` structure.
#' @param height A character string indicating the height in pixels, like "10px"
#' @param direction The direction of the `paletteer` palette, should be either `-1` for reversed or the default of `1` for the existing direction.
#' @param domain The possible values that can be mapped. This should be a simple numeric range (e.g. `c(0, 100)`)
#' @param align Character string indicating alignment of the column, defaults to "left"
#' @param v_pad A numeric value indicating the vertical padding, defaults to -5 to aid in centering within the vertical space.
#' @importFrom scales col_numeric
#' @importFrom paletteer paletteer_d
#' @import gt glue
#' @importFrom htmltools div
#' @importFrom fontawesome fa
#' @return a gt table
#' @export
#'
#' @section Examples:
#'
#' ```r
#' head(mtcars) %>%
#'   dplyr::mutate(warn = ifelse(mpg >= 21, 1, 0), .before = mpg) %>%
#'   gt::gt() %>%
#'   gt_alert_icon(warn)
#' ```
#' \if{html}{\figure{man/figures/gt_alert_icon-binary.png}{options: width=100\%}}
gt_alert_icon <- function(gt_object,
                          column,
                          palette = c("#a962b6", "#f1f1f1", "#378e38"),
                          domain = NULL,
                          height = "10px",
                          direction = 1,
                          align = "center",
                          v_pad = -5) {
  stopifnot("Table must be of class 'gt_tbl'" = "gt_tbl" %in% class(gt_object))
  stopifnot("align must be one of 'center', 'left', or 'right'" = align %in% c("center", "left", "right"))

  if (is.null(domain)) {
    message(
      "Domain not specified, defaulting to observed range within each specified column. Silence this message by setting domain argument."
    )
  }

  text_transform(
    gt_object,
    locations = cells_body(columns = {{ column }}),
    fn = function(x) {
      scaled_colors <- scales::col_numeric(
        palette = if (grepl(x = palette[1], pattern = "::")) {
          paletteer::paletteer_d(
            palette = palette,
            direction = direction,
            type = "continuous"
          ) %>% as.character()
        } else {
          if (direction == -1) {
            rev(palette)
          } else {
            palette
          }
        },
        domain = domain
      )(as.double(x))

      Map(
        function(fill, ht) {
          htmltools::div(
            fontawesome::fa("circle", fill = fill, height = ht),
            style = glue::glue("margin-top: {v_pad}px; top: 50%;")
          )
        },
        scaled_colors, height
      )
    }
  ) %>%
    gt::cols_align(align = align, columns = {{ column }})
}
