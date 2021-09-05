#' Add text and an image to the left or right of it
#' @description
#' The `gt_text_img` function takes an existing `gt_tbl` object and
#' adds some user specified text and an image url to a specific cell. This is a
#' wrapper raw HTML strings and `gt::web_image()`. Intended to be used inside
#' the header of a table via `gt::tab_header()`.
#'
#' @param text A text string to be added to the cell.
#' @inheritParams gt::web_image
#' @param left A logical TRUE/FALSE indicating if text should be on the left (TRUE) or right (FALSE)
#' @return An object of class `gt_tbl`.
#' @importFrom gt %>%
#' @export
#' @import gt
#' @importFrom kableExtra spec_plot
#' @importFrom glue glue
#'
#' @family Utilities
#' @section Function ID:
#' 1-7

gt_text_img <- function(text, url, height = 30, left = FALSE){

  text_div <- glue::glue("<div style='display:inline;vertical-align: top;'>{text}</div>")
  img_div <- glue::glue("<div style='display:inline;margin-left:10px'>{web_image(url = url, height = height)}</div>")

  if(isFALSE(left)){
    paste0(text_div, img_div) %>% gt::html()
  } else {
    paste0(img_div, text_div) %>% gt::html()
  }
}