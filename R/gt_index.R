#' Return the underlying data, arranged by the internal index
#' @description This is a utility function to extract the underlying data from
#' a `gt` table. You can use it with a saved `gt` table, in the pipe (`%>%`)
#' or even within most other `gt` functions (eg `tab_style()`). It defaults to
#' returning the column indicated as a vector, so that you can work with the
#' values. Typically this is used with logical statements to affect one column
#' based on the values in that specified secondary column.
#' Alternatively, you can extract the entire ordered data according to the
#' internal index as a `tibble`. This allows for even more complex steps
#' based on multiple indices.
#'
#' @param gt_object An existing gt table object
#' @param column The column name that you intend to extract, accepts tidyeval semantics (ie `mpg` instead of `"mpg"`)
#' @param as_vector A logical indicating whether you'd like just the column indicated as a vector, or the entire dataframe
#' @return A vector or a `tibble`
#' @export
#'
#' @examples
#' library(gt)
#'
#' # This is a key step, as gt will create the row groups
#' # based on first observation of the unique row items
#' # this sampling will return a row-group order for cyl of 6,4,8
#'
#' set.seed(1234)
#' sliced_data <- mtcars %>%
#'   dplyr::group_by(cyl) %>%
#'   dplyr::slice_head(n = 3) %>%
#'   dplyr::ungroup() %>%
#'   # randomize the order
#'   dplyr::slice_sample(n = 9)
#'
#' # not in "order" yet
#' sliced_data$cyl
#'
#' # But unique order of 6,4,8
#' unique(sliced_data$cyl)
#'
#' # creating a standalone basic table
#' test_tab <- sliced_data %>%
#'   gt(groupname_col = "cyl")
#'
#' # can style a specific column based on the contents of another column
#' tab_out_styled <- test_tab %>%
#'   tab_style(locations = cells_body(mpg, rows = gt_index(., am) == 0),
#'             style = cell_fill("red")
#'   )
#'
#' # OR can extract the underlying data in the "correct order"
#' # according to the internal gt structure, ie arranged by group
#' # by cylinder, 6,4,8
#' gt_index(test_tab, mpg, as_vector = FALSE)
#'
#' # note that the order of the index data is
#' # not equivalent to the order of the input data
#' # however all the of the rows still match
#' sliced_data
#' @section Figures:
#' \if{html}{\figure{gt_index_style.png}{options: width=50\%}}
#'
#' @family Utilities
#' @section Function ID:
#' 2-20

gt_index <- function(gt_object, column, as_vector = TRUE){

  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))
  stopifnot("'as_vector' must be a TRUE or FALSE" = is.logical(as_vector))

  if(isTRUE(identical(gt_object[["_row_groups"]],character(0)))){

    # if the data is not grouped, then it will just "work"
    df_ordered <- gt_object[["_data"]]

  } else {

    # if the data is grouped you need to identify the group column
    # and arrange by that column. I convert to a factor so that the
    # columns don't default to arrange by other defaults
    #  (ie alphabetical or numerical)
    gt_row_grps <- gt_object[["_row_groups"]]

    gt_boxhead <- gt_object[["_boxhead"]]

    # slice index to only the row_group variable
    grp_col_name <- gt_boxhead[["var"]][gt_boxhead[["type"]]=="row_group"]

    # get this as a tidyeval column
    grp_col_sym <- rlang::sym(grp_col_name)

    #  now it's "just" a df with tidyeval
    df_ordered <- gt_object[["_data"]] %>%
      # need to use walrus equal to get the !! semantics to work
      dplyr::mutate(!!grp_col_sym := factor(!!grp_col_sym,
                                            levels = gt_row_grps)) %>%
      dplyr::arrange(!!grp_col_sym) %>%
      dplyr::mutate(!!grp_col_sym := as.character(!!grp_col_sym))
  }

  # return as vector or tibble in correct, gt-indexed ordered
  if(isTRUE(as_vector)){
    df_ordered %>%
      dplyr::pull({{column}})
  } else {
    df_ordered
  }

}
