#' Duplicate an existing column in a gt table
#' @description This function takes an existing gt table and will duplicate a column.
#' You also have the option to specify where the column ends up, and what will
#' be appending to the end of the column name to differentiate it.
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column to be duplicated
#' @param after The column to place the duplicate column after
#' @param append_text The text to add to the column name to differentiate it from the original column name
#' @param dupe_name A full name for the "new" duplicated column, will override `append_text`
#' @return An object of class `gt_tbl`.
#' @export
#' @examples
#' library(gt)
#' dupe_table <- head(mtcars) %>%
#'   dplyr::select(mpg, disp) %>%
#'   gt() %>%
#'   gt_duplicate_column(mpg, after = disp, append_text = "2")
#'
#' @family Utilities
#' @section Function ID:
#' 2-15
#'
gt_duplicate_column <- function(gt_object, column, after = dplyr::last_col(), append_text = "_dupe",
                                dupe_name = NULL){

  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))

  columns <-
    resolve_cols_c(
      expr = {{ column }},
      data = gt_object
    )

  col_dupe_name <- if (is.null(dupe_name)) {
    stopifnot("Appended text must be at least 1 character" = nchar(append_text) > 0)
    paste0(columns, append_text)
    } else {
    dupe_name
    }

  # add a duplicate column in the raw data
  gt_object[["_data"]] <-
    gt_object[["_data"]] %>%
    dplyr::mutate(!!col_dupe_name := {{column}})

  added_row <- gt_object[["_boxhead"]] %>%
    dplyr::filter(.data$var == columns) %>%
    dplyr::mutate(var = !!col_dupe_name,
                  column_label = list(!!col_dupe_name))

  # add metadata for gt about new column
  gt_object[["_boxhead"]] <-
    gt_object[["_boxhead"]] %>%
    dplyr::bind_rows(added_row)

  gt_object %>%
    cols_move(!!col_dupe_name, after = {{ after }})

}
