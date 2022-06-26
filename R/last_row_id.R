#' Get last row id/index even by group
#'
#' @param gt_object An existing gt table object of class `gt_tbl`

last_row_id <- function(gt_object){

  is_gt_stop(gt_object)

  get_row_index(gt_object) %>%
    dplyr::last()
}
