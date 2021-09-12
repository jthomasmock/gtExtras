#' Add a small color box relative to the cell value.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param columns he columns wherein changes to cell data colors should occur.
#' @param palette The colours or colour function that values will be mapped to. Can be a character vector (eg `c("white", "red")` or hex colors) or if `use_paletteer = TRUE`, a named palette from the `{paletteer}` package.
#' @param domain The possible values that can be mapped. This should be a simple numeric range (e.g. `c(0, 100)`)
#' @param use_paletteer Should the palette be passed as a "package::palette_name" to `paletteer` or should the palette be treated as a raw character string of colors. Defaults to `TRUE`. Note that if `FALSE`, that the "n", "direction", and "type" arguments are ignored, as they are passed only to `paletter::paletteer_d()`.
#' @param width The width of the entire coloring area in pixels.
#'
#' @return
#' @export
#'
#' @examples
#' library(gt)
#' test_data <- tibble(x = letters[1:10],
#'                     y = seq(100, 10, by = -10),
#'                     z = seq(10, 100, by = 10))
#' color_box_tab <- test_data %>%
#'   gt() %>%
#'   gt_color_box(columns = y, domain = 0:100,
#'                palette = "ggsci::blue_material", use_paletteer = TRUE) %>%
#'   gt_color_box(columns = z, domain = 0:100,
#'                palette = c("purple", "lightgrey", "green"))
#' @section Figures:
#' \if{html}{\figure{color_box.png.png}{options: width=30\%}}
#'
#' @family Colors
#' @section Function ID:
#' 2-4



gt_color_box <- function(gt_object, columns, palette = NULL, domain = NULL,
                         use_paletteer = FALSE, width = 70){

  color_boxes <- function(x){

    stopifnot("Error: 'domain' must be specified." = !is.null(domain))

    if(isTRUE(use_paletteer)){
      palette <- paletteer::paletteer_d(
        palette = palette
      ) %>% as.character()
    } else if(is.null(palette)){
      palette <- c("#762a83", "#af8dc3", "#e7d4e8", "#f7f7f7",
                   "#d9f0d3", "#7fbf7b", "#1b7837")
    } else {
      palette <- palette
    }

    colors <- scales::col_numeric(palette = palette, domain = domain)(x)

    background_col <- scales::alpha(colors, alpha = 0.1)

    div(
      div(
        style = paste0(
          glue::glue("height: 20px;width:{width}px; background-color: {background_col};"),
          "border-radius:5px;)"
        ),
        div(
          style = paste0(
            glue::glue("height: 15px;width: 15px;background-color: {colors};"),
            "display: inline-block;border-radius:5px;float:left;",
            "position:relative;top:12%;left:5%;"
          )
        ),
        div(
          format(x, nsmall = 1L, digits = 1L),
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
