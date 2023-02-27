#' Render 'gt' Table to Temporary png File
#'
#' Saves a gt table to a temporary png image file and uses
#' `knitr::include_graphics()` to render tables in reproducible examples
#' like `reprex::reprex()` where the HTML is not transferrable to GitHub.
#'
#' @description Take a gt pipeline or object and print it as an image within
#' a reprex
#' @param gt_object An object of class `gt_tbl` usually created by [gt::gt()]
#' @importFrom knitr include_graphics
#'
#' @return a png image
#' @export
#'
gt_reprex_image <- function(gt_object) {

  stopifnot("Table must be of class 'gt_tbl'" = inherits(gt_object, "gt_tbl"))

  # create temp file
  img_out <- tempfile(fileext = ".png")

  # save image to temp
  save_obj <- gt::gtsave(gt_object, img_out) %>%
    utils::capture.output(type = "message") %>%
    invisible()

  if(!grepl("screenshot completed", tolower(save_obj))) print(save_obj)

  # just include the image
  knitr::include_graphics(img_out)

}
