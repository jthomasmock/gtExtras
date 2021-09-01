#' Apply 'hulk' palette to specific columns in a gt table.
#' @description
#' The hulk names comes from the idea of a diverging purple and green theme
#' that is colorblind safe and visually appealing.
#' It is a useful alternative to the red/green palette where purple typically
#' can indicate low or "bad" value, and green can indicate a high or "good" value.
#'
#' @param gt_data An existing gt table object
#' @param ... Additional arguments passed to scales::col_numeric
#' @param trim trim the palette to give less intense maximal colors
#' @param na.color Applies to scales::col_numeric, the colour to return for NA values. Note that na.color = NA is valid.
#' @param alpha Applies to scales:col_numeric, Whether alpha channels should be respected or ignored. If TRUE then colors without explicit alpha information will be treated as fully opaque.
#' @param reverse Applied to scales::col_numeric, Whether the colors (or color function) in palette should be used in reverse order. The default order of this palette goes from purple to green, then reverse = TRUE will result in the colors going from green to purple.
#' @return Returns a gt table
#' @importFrom gt %>%
#' @importFrom scales col_numeric
#' @inheritParams scales::col_numeric
#' @export
#' @import gt
#' @examples
#'  library(gt)
#'  # basic use
#'  hulk_basic <- mtcars %>%
#'    head() %>%
#'    gt::gt() %>%
#'    gt_hulk_color(mpg)
#'
#'  hulk_trim <- mtcars %>%
#'    head() %>%
#'    gt::gt() %>%
#'    # trim gives small range of colors
#'    gt_hulk_color(mpg:disp, trim = TRUE)
#'
#'  # option to reverse the color palette
#'  hulk_rev <- mtcars %>%
#'    head() %>%
#'    gt::gt() %>%
#'    # trim gives small range of colors
#'    gt_hulk_color(mpg:disp, reverse = TRUE)
#'
#' @section Figures:
#' \if{html}{\figure{hulk_basic.png}{options: width=100\%}}
#'
#' \if{html}{\figure{hulk_trim.png}{options: width=100\%}}
#'
#' \if{html}{\figure{hulk_reverse.png}{options: width=100\%}}
#'
#' @family Colors
#' @section Function ID:
#' 2-1


gt_hulk_color <- function(gt_object, columns = NULL, ..., trim = FALSE){

  pal_hex <- c("#762a83", "#af8dc3", "#e7d4e8", "#f7f7f7",
               "#d9f0d3", "#7fbf7b", "#1b7837")

  pal_hex <- if(isTRUE(trim)){
    pal_hex[2:6]
  }else{
    pal_hex
  }

  hulk_pal <- function(x){
    scales::col_numeric(
      pal_hex,
      ...
    )(x)
  }

  gt::data_color(
    gt_object,
    columns = {{ columns }},
    colors = hulk_pal
                 )

}

