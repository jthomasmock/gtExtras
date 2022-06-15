#' Apply 'hulk' palette to specific columns in a gt table.
#' @description
#' The hulk name comes from the idea of a diverging purple and green theme
#' that is colorblind safe and visually appealing.
#' It is a useful alternative to the red/green palette where purple typically
#' can indicate low or "bad" value, and green can indicate a high or "good" value.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param columns The columns wherein changes to cell data colors should occur.
#' @param trim trim the palette to give less intense maximal colors
#' @inheritParams scales::col_numeric
#' @param ... Additional arguments passed to `scales::col_numeric()`
#' @return An object of class `gt_tbl`.
#' @export
#' @section Examples:
#' ```r
#'  library(gt)
#'  # basic use
#'  hulk_basic <- mtcars %>%
#'    head() %>%
#'    gt::gt() %>%
#'    gt_hulk_col_numeric(mpg)
#'
#'  hulk_trim <- mtcars %>%
#'    head() %>%
#'    gt::gt() %>%
#'    # trim gives small range of colors
#'    gt_hulk_col_numeric(mpg:disp, trim = TRUE)
#'
#'  # option to reverse the color palette
#'  hulk_rev <- mtcars %>%
#'    head() %>%
#'    gt::gt() %>%
#'    # trim gives small range of colors
#'    gt_hulk_col_numeric(mpg:disp, reverse = TRUE)
#' ```
#' @section Figures:
#' \if{html}{\figure{hulk_basic.png}{options: width=100\%}}
#'
#' \if{html}{\figure{hulk_trim.png}{options: width=100\%}}
#'
#' \if{html}{\figure{hulk_reverse.png}{options: width=100\%}}
#'
#' @family Colors
#' @section Function ID:
#' 4-1
gt_hulk_col_numeric <- function(gt_object, columns = NULL, domain = NULL, ..., trim = FALSE){

  stopifnot("Input must be a gt table" = "gt_tbl" %in% class(gt_object))

  pal_hex <- c("#762a83", "#af8dc3", "#e7d4e8", "#f7f7f7",
               "#d9f0d3", "#7fbf7b", "#1b7837")

  if(isTRUE(trim)) pal_hex <- pal_hex[2:6]

  hulk_pal <- function(x){
    scales::col_numeric(
      pal_hex,
      domain = domain,
      ...
    )(x)
  }

  gt::data_color(
    gt_object,
    columns = {{ columns }},
    colors = hulk_pal
                 )

}

