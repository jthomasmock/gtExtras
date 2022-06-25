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
#' @section Examples:
#' ```r
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
#' ```
#' @section Figures:
#' \if{html}{\figure{grp-tab-style.png}{options: width=40\%}}
#'
#' @family Utilities
#' @section Function ID:
#' 2-12

tab_style_by_grp <- function(gt_object, column, fn, ...){

  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))

  # extract group names as a character and then turn into sym
  # for later tidyeveal
  ## logical vector
  subset_log <- gt_object[["_boxhead"]][["type"]]=="row_group"
  ## subset vars by vector
  grp_names <- gt_object[["_boxhead"]][["var"]][subset_log]
  ## create a list of symbols
  grp_col <- rlang::syms(grp_names)

  # ordered levels of the row groups
  gt_row_grps <- gt_object[["_row_groups"]]

  # pull the ordered row numbers
  grp_vec_ord <- gt_object[["_stub_df"]] %>%
    dplyr::mutate(group_id = factor(group_id, levels = gt_row_grps)) %>%
    dplyr::arrange(group_id) %>%
    dplyr::pull(rownum_i)

  # get the actual row id of the data for gt to target
  row_ids <- gt_object[["_data"]] %>%
    dplyr::mutate(row_id = dplyr::row_number()) %>%
    dplyr::slice(grp_vec_ord) %>%
    ### !!! to evaluate the list of symbols
    dplyr::group_by(!!!grp_col) %>%
    dplyr::filter({{column}} == do.call(what = fn, args = list({{column}}))) %>%
    dplyr::ungroup() %>%
    dplyr::pull(row_id)

  gt_object %>%
    tab_style(
      style = ...,
      locations = cells_body(columns = {{column}}, rows = row_ids)
    )
}
