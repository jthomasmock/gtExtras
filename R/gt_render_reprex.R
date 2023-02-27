#' Helper for gt reprex screenshots
#'
#' @description Take a gt pipeline or object and print it within reprex
#' @param gt_object an existing gt table
#' @importFrom knitr include_graphics
#'
#' @return a png image
#' @export
#'
gt_render_reprex <- function(gt_object, imgur = FALSE) {

  stopifnot("Table must be of class 'gt_tbl'" = inherits(gt_object, "gt_tbl"))

  # create temp file
  img_out <- tempfile(fileext = ".png")

  # save image to temp
  save_obj <- gt::gtsave(gt_object, img_out) %>%
    utils::capture.output(type = "message") %>%
    invisible()

  # just include the image
  knitr::include_graphics(img_out)

}
