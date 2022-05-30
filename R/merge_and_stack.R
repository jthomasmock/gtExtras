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
#' @param palette The colors for the text, where the first color is the top ,
#'   ie `col1` and the second color is the bottom, ie `col2`. Defaults to `c("black","grey")`.
#'   For more information on built-in color names, see [colors()].
#' @inheritDotParams scales::col2hcl -colour
#' @return An object of class `gt_tbl`.
#' @export
#' @examples
#' library(gt)
#' teams <- "https://github.com/nflverse/nflfastR-data/raw/master/teams_colors_logos.rds"
#' team_df <- readRDS(url(teams))
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

gt_merge_stack <- function(gt_object, col1, col2, palette = c("black","grey"), ...) {

  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))
  stopifnot("There must be two colors" = length(palette) == 2)

  # translate colors to hcl. Allows R color names like "grey30".
  colors <- scales::col2hcl(palette, ...)

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
          "<div style='line-height:10px'><span style='font-weight:bold;font-variant:small-caps;color:{colors[1]};font-size:14px'>{x}</div>
        <div style='line-height:12px'><span style ='font-weight:bold;color:{colors[2]};font-size:10px'>{data_in}</span></div>"
        )
      }
    ) %>%
    cols_hide(columns = {{ col2 }})

}
