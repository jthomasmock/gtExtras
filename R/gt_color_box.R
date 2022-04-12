#' @title Add a small color box relative to the cell value.
#' @description Create `PFF`-style colorboxes in a `gt` table.
#'Note that rather than using `gt::fmt_` functions on this column, you can send
#' numeric formatting arguments via `...`. All arguments should be named
#' and are passed to `scales::label_number()`.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param columns The columns wherein changes to cell data colors should occur.
#' @param palette The colours or colour function that values will be mapped to. Can be a character vector (eg `c("white", "red")` or hex colors) or if `use_paletteer = TRUE`, a named palette from the `{paletteer}` package.
#' @param domain The possible values that can be mapped. This should be a simple numeric range (e.g. `c(0, 100)`)
#' @param width The width of the entire coloring area in pixels.
#' @param ... Additional arguments passed to `scales::label_number()`, primarily used to format the numbers inside the color box
#'
#' @return An object of class `gt_tbl`.
#' @export
#'
#' @examples
#' library(gt)
#' test_data <- dplyr::tibble(x = letters[1:10],
#'                     y = seq(100, 10, by = -10),
#'                     z = seq(10, 100, by = 10))
#' color_box_tab <- test_data %>%
#'   gt() %>%
#'   gt_color_box(columns = y, domain = 0:100, palette = "ggsci::blue_material") %>%
#'   gt_color_box(columns = z, domain = 0:100,
#'                palette = c("purple", "lightgrey", "green"))
#' @section Figures:
#' \if{html}{\figure{color_box.png}{options: width=30\%}}
#'
#' @family Colors
#' @section Function ID:
#' 4-3


gt_color_box <- function(gt_object, columns, palette = NULL, ..., domain = NULL,
                         width = 70){

  stopifnot("Table must be of class 'gt_tbl'" = "gt_tbl" %in% class(gt_object))

  color_boxes <- function(x){

    stopifnot("Error: 'domain' must be specified." = !is.null(domain))

    if(length(palette) == 1){
      if(grepl(x = palette, pattern = "::", fixed = TRUE)){
        palette <- paletteer::paletteer_d(
          palette = palette
        ) %>% as.character()
      } else {
        palette <- palette
      }
    } else if(is.null(palette)){
      palette <- c("#762a83", "#af8dc3", "#e7d4e8", "#f7f7f7",
                   "#d9f0d3", "#7fbf7b", "#1b7837")
    } else {
      palette <- palette
    }

    colors <- scales::col_numeric(palette = palette, domain = domain)(x)

    background_col <- scales::alpha(colors, alpha = 0.2)

    div(
      div(
        style = paste0(
          glue::glue(
            "height: 20px;width:{width}px; background-color: {background_col};"
            ),
          "border-radius:5px;)"
        ),
        div(
          style = paste0(
            glue::glue("height: 15px;width: 15px;background-color: {colors};"),
            "display: inline-block;border-radius:5px;float:left;",
            "position:relative;top:13%;left:5%;" # top 12%-15%
          )
        ),
        div(
          scales::label_number(...)(x),
          style = paste0(
            "display: inline-block;float:right;line-height:20px;",
            "padding: 0px 2.5px;"
          )
        )
      )
    ) %>%
      as.character() %>%
      html()
  }

  text_transform(
    gt_object,
    locations = cells_body({{ columns }}),
    fn = function(x){
      x <- as.double(x)
      lapply(x, color_boxes)
    }
  )

}
