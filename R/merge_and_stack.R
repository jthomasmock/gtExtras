#' Merge and stack text from two columns in `gt`
#'
#' @description
#' The `gt_merge_stack()` function takes an existing `gt` table and merges
#' column 1 and column 2, stacking column 1's text on top of column 2's.
#' Top text is in all caps with black bold text, while the lower text is smaller
#' and dark grey.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param col1 The column to stack on top. Will be converted to all caps, with black and bold text.
#' @param col2 The column to merge and place below. Will be smaller and dark grey.
#' @return An object of class `gt_tbl`.
#' @importFrom gt %>%
#' @importFrom glue glue
#' @export
#' @import gt
#' @examples
#' library(gt)
#' team_df <- readRDS(url("https://github.com/nflverse/nflfastR-data/raw/master/teams_colors_logos.rds"))
#'
#' stacked_tab <- team_df %>%
#'  dplyr::select(team_nick, team_abbr, team_conf, team_division, team_wordmark) %>%
#'  head(8) %>%
#'  gt(groupname_col = "team_conf") %>%
#'  gt_merge_stack(col1 = team_nick, col2 = team_division) %>%
#'  gt_img_rows(team_wordmark)
#'
#' @section Figures:
#' \if{html}{\figure{merge-stack.png}{options: width=50\%}}
#'
#' @family Utilities
#' @section Function ID:
#' 2-6

gt_merge_stack <- function(gt_object, col1, col2) {
  col1_bare <- rlang::enexpr(col1) %>% rlang::as_string()

  row_name_var <- gt_object[["_boxhead"]][["var"]][which(gt_object[["_boxhead"]][["type"]] == "stub")]

  col2_bare <- rlang::enexpr(col2) %>% rlang::as_string()
  # segment data with bare string column name
  data_in <- gt_object[["_data"]][[col2_bare]]

  gt_object %>%
    text_transform(
      locations = if (isTRUE(row_name_var == col1_bare)) {
        cells_stub(rows = gt::everything())
      } else {
        cells_body(columns = {{ col1 }})
      },
      fn = function(x) {
        glue::glue(
          "<div style='line-height:10px'><span style='font-weight:bold;font-variant:small-caps;font-size:14px'>{x}</div>
        <div style='line-height:12px'><span style ='font-weight:bold;color:grey;font-size:10px'>{data_in}</span></div>"
        )
      }
    ) %>%
    cols_hide(columns = {{ col2 }})

}
