#' Add table styling to specific rows by group
#' @description
#' The `tab_style_by_grp` function takes an existing `gt_tbl` object and
#' styling according to each group. Currently it support styling the `max()`/`min()`
#' for each group.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column using tidy variable name or a number indicating which column should have the styling affect it.
#' @param fn The name of a summarizing function (ie `max()`, `min()`)
#' @param ... Arguments passed to `tab_style(style = ...)`
#' @return An object of class `gt_tbl`.
#' @export
#' @examples
#' library(gt)
#' df_in <- mtcars %>%
#'   dplyr::select(cyl:hp, mpg) %>%
#'   tibble::rownames_to_column() %>%
#'   dplyr::group_by(cyl) %>%
#'   dplyr::slice(1:4) %>%
#'   dplyr::ungroup()
#'
#' test_tab <- df_in %>%
#'   gt(groupname_col = "cyl") %>%
#'   tab_style_by_grp(mpg, fn = max,
#'                    cell_fill(color = "red", alpha = 0.5))
#'
#' @section Figures:
#' \if{html}{\figure{grp-tab-style.png}{options: width=20\%}}
#'
#' @family Utilities
#' @section Function ID:
#' 2-12

tab_style_by_grp <- function(gt_object, column, fn, ...){

  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))

  subset_log <- gt_object[["_boxhead"]][["type"]]=="row_group"
  grp_col <- gt_object[["_boxhead"]][["var"]][subset_log] %>% rlang::sym()

  row_ids <- gt_object[["_data"]] %>%
    mutate(row_id = row_number()) %>%
    group_by(!!grp_col) %>%
    filter({{column}} == do.call(what = fn, args = list({{column}}))) %>%
    pull(.data$row_id)

  gt_object %>%
    tab_style(
      style = ...,
      locations = cells_body(columns = {{column}}, rows = row_ids)
    )
}
