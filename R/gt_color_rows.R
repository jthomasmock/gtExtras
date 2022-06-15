#' Add scaled colors according to numeric values or categories/factors
#' @description
#' The `gt_color_rows` function takes an existing `gt_tbl` object and
#' applies pre-existing palettes from the `{paletteer}` package or custom
#' palettes defined by the user. This function is a custom wrapper around
#'  `gt::data_color()`, and uses some of the boilerplate code. Basic use
#'  is simpler than `data_color()`.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param columns The columns wherein changes to cell data colors should occur.
#' @param pal_type A string indicating the palette type (one of `c("discrete", "continuous")`)
#' @param ... Additional arguments passed to `scales::col_numeric()`
#' @inheritParams scales::col_numeric
#' @inheritParams paletteer::paletteer_d
#' @return An object of class `gt_tbl`.
#' @export
#' @section Examples:
#' ```r
#'  library(gt)
#'  # basic use
#'  basic_use <- mtcars %>%
#'    head(15) %>%
#'    gt() %>%
#'    gt_color_rows(mpg:disp)
#'  # change palette to one that paletteer recognizes
#'  change_pal <- mtcars %>%
#'    head(15) %>%
#'    gt() %>%
#'    gt_color_rows(mpg:disp, palette = "ggsci::blue_material")
#'  # change palette to raw values
#'  vector_pal <- mtcars %>%
#'    head(15) %>%
#'    gt() %>%
#'    gt_color_rows(
#'      mpg:disp, palette = c("white", "green"))
#'      # could also use palette = c("#ffffff", "##00FF00")
#'
#'  # use discrete instead of continuous palette
#'  discrete_pal <- mtcars %>%
#'   head(15) %>%
#'   gt() %>%
#'   gt_color_rows(
#'   cyl, pal_type = "discrete",
#'   palette = "ggthemes::colorblind", domain = range(mtcars$cyl)
#'     )
#'  # use discrete and manually define range
#'  range_pal <- mtcars %>%
#'    dplyr::select(gear, mpg:hp) %>%
#'    head(15) %>%
#'    gt() %>%
#'    gt_color_rows(
#'    gear, pal_type = "discrete", direction = -1,
#'    palette = "colorblindr::OkabeIto_black", domain = c(3,4,5))
#' ```
#' @section Figures:
#' \if{html}{\figure{basic-pal.png}{options: width=100\%}}
#'
#' \if{html}{\figure{blue-pal.png}{options: width=100\%}}
#'
#' \if{html}{\figure{custom-pal.png}{options: width=100\%}}
#'
#' \if{html}{\figure{discrete-pal.png}{options: width=100\%}}
#'
#' @family Colors
#' @section Function ID:
#' 4-2
gt_color_rows <- function(
  gt_object,
  columns,
  palette = "ggsci::red_material",
  direction = 1,
  domain = NULL,
  pal_type = c("discrete", "continuous"),
  ...
) {

  stopifnot("Table must be of class 'gt_tbl'" = "gt_tbl" %in% class(gt_object))
  if(is.null(domain)){
    warning(
      "Domain not specified, defaulting to observed range within each specified column.",
      call. = FALSE
      )
    }

  gt_object %>%
    data_color(
      columns = {{ columns }},
      colors = scales::col_numeric(
        palette = if(grepl(x = palette[1], pattern = "::")){
          paletteer::paletteer_d(
            palette = palette,
            direction = direction,
            type = pal_type
          ) %>% as.character()
        } else {
          if(direction == -1){
            rev(palette)
          } else {
            palette
          }
        },
        ...,
        domain = domain
      )
    )
}
