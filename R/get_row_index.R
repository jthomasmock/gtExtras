#' Get underlying row index for gt tables
#' @description Provides underlying row index for grouped or ungrouped
#' `gt` tables. In some cases the visual representation of specific rows is
#' inconsistent with the "row number" so this function provides the final
#' output index for subsetting or targetting rows.
#' @param gt_object an existing gt table
#'
#' @return a vector of row indices
#' @export
#'
#' @section Examples:
#'
#' ### Create a helper function
#'
#' This helper functions lets us be a bit more efficient when showing the row
#' numbers/colors.
#'
#' ```r
#' library(gt)
#'
#' row_sty <- function(tab, row){
#'
#'   OkabeIto <- c("#E69F00", "#56B4E9", "#009E73", "#F0E442",
#'                 "#0072B2", "#D55E00", "#CC79A7", "#999999")
#'   tab %>%
#'     tab_style(
#'       cell_fill(color = OkabeIto[row]),
#'       locations = cells_body(rows = row)
#'     )
#' }
#' ```
#'
#' ### Randomize the data
#'
#' We will randomly sample the data to get it in a specific order.
#'
#' ```r
#' set.seed(37)
#' df <- mtcars %>%
#'   dplyr::group_by(cyl) %>%
#'   dplyr::slice_sample(n = 2) %>%
#'   dplyr::ungroup() %>%
#'   dplyr::slice_sample(n = 6) %>%
#'   dplyr::mutate(row_id = dplyr::row_number(), .before = 1)
#'
#' #> df
#' #> A tibble: 6 × 12
#' #> row_id  mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
#' #> <int>  <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#' #>   1    10.4   8    472    205  2.93  5.25  18.0     0     0     3     4
#' #>   2    18.1   6    225    105  2.76  3.46  20.2     1     0     3     1
#' #>   3    21.4   6    258    110  3.08  3.22  19.4     1     0     3     1
#' #>   4    13.3   8    350    245  3.73  3.84  15.4     0     0     3     4
#' #>   5    33.9   4     71.1  65   4.22  1.84  19.9     1     1     4     1
#' #>   6    22.8   4    108    93   3.85  2.32  18.6     1     1     4     1
#' ```
#' ### Ungrouped data
#'
#' Ungrouped data works just fine, and the row indices are identical between
#' the visual representation and the output.
#' ```r
#' gt(df) %>%
#'   row_sty(1) %>%
#'   row_sty(3) %>%
#'   row_sty(5)
#' ```
#' \if{html}{\figure{ungrouped-tab.png}{options: width=40\%}}
#' ### Grouped data
#'
#' However, for grouped data, the row indices are representative of the underlying
#' data before grouping, leading to some potential confusion.
#' ```r
#' tab2 <- gt(df, groupname_col = "cyl")
#'
#' tab2 %>%
#'   row_sty(1) %>% ## actually row 1
#'   row_sty(3) %>% ## actually row 5
#'   row_sty(5)     ## actually row 2
#' ```
#' \if{html}{\figure{grouped-tab.png}{options: width=40\%}}
#'
#' The `get_row_index()` function gives ability to create an index of the final
#' output, so you can reference specific rows by number.
#'
#' ```r
#' tab_index <- get_row_index(tab2)
#'
#' tab2 %>%
#'   row_sty(4) %>% ## wrong row, actually row 6 visually
#'   row_sty(tab_index[4]) ## correct row, actually row 4
#' ```
#' \if{html}{\figure{grouped-tab-row4.png}{options: width=40\%}}
#' ```r
#' tab2 %>%
#'   row_sty(tab_index[1]) %>%
#'   row_sty(tab_index[3]) %>%
#'   row_sty(tab_index[5])
#' ```
#' \if{html}{\figure{grouped-tab-index.png}{options: width=40\%}}
#'
get_row_index <- function(gt_object){

  is_gt_stop(gt_object)

  # find group_index
  subset_log <- gt_object[["_boxhead"]][["type"]]=="row_group"
  ## subset vars by vector
  grp_names <- gt_object[["_boxhead"]][["var"]][subset_log]
  ## create a list of symbols

  if(length(grp_names) >= 1){
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
      dplyr::pull(row_id)
  } else {
    row_ids <- nrow(gt_object[["_data"]])
  }

  row_ids
}
