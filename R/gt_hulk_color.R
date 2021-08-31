#' Apply 'hulk' palette to specific columns in a gt table. The hulk names comes from the idea of a divergin purple and green theme that is colorblind safe and visually appealing. It is a useful alternative to the red/green palette.
#'
#' @param gt_object An existing gt table object
#' @param ... columns to apply color to
#' @param trim trim the palette to give less intense maximal colors
#' @param reverse reverse the color palette. The default is green = high and purple = low, but reverse = TRUE will make purple high and green low.
#' @return Returns a gt table
#' @importFrom gt %>%
#' @importFrom scales col_numeric
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


gt_hulk_color <- function(gt_object, ..., domain = NULL, trim = FALSE, reverse = FALSE){

  pal_hex <- c("#1b7837", "#7fbf7b", "#d9f0d3", "#f7f7f7",
               "#e7d4e8", "#af8dc3", "#762a83")

  pal_hex <- if(isTRUE(trim)){
    pal_hex[2:6]
  }else{
    pal_hex
  }

  pal_hex <- if(isTRUE(reverse)){
    pal_hex
  }else{
    rev(pal_hex)
  }

  hulk_pal <- function(x){
    scales::col_numeric(
      pal_hex,
      domain = domain
    )(x)
  }

  gt::data_color(
    gt_object,
    columns = ...,
    colors = hulk_pal
                 )

}

