#' Add local or web images into rows of a `gt` table
#' @description
#' The `gt_img_rows` function takes an existing `gt_tbl` object and
#' converts filenames or urls to images into inline images. This is a wrapper
#' around `gt::text_transform()` + `gt::web_image()`/`gt::local_image()` with
#' the necessary boilerplate already applied.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param columns The columns wherein changes to cell data colors should occur.
#' @param img_source A string, specifying either "local" or "web" as the source of the images.
#' @inheritParams gt::web_image
#' @inheritParams gt::local_image
#' @return An object of class `gt_tbl`.
#' @export
#' @section Examples:
#' ```r
#' library(gt)
#' teams <- "https://github.com/nflverse/nflfastR-data/raw/master/teams_colors_logos.rds"
#' team_df <- readRDS(url(teams))
#'
#'  logo_table <- team_df %>%
#'    dplyr::select(team_wordmark, team_abbr, logo = team_logo_espn, team_name:team_conf) %>%
#'    head() %>%
#'    gt() %>%
#'    gt_img_rows(columns = team_wordmark, height = 25) %>%
#'    gt_img_rows(columns = logo, img_source = "web", height = 30) %>%
#'    tab_options(data_row.padding = px(1))
#' ```
#' @section Figures:
#' \if{html}{\figure{img-rows.png}{options: width=100\%}}
#'
#' @family Utilities
#' @section Function ID:
#' 2-7

gt_img_rows <- function(gt_object, columns, img_source = "web", height = 30) {
  stopifnot("Table must be of class 'gt_tbl'" = "gt_tbl" %in% class(gt_object))
  # convert tidyeval column to bare strings
  column_names <- resolve_cols_c(
    expr = {{ columns }},
    data = gt_object
  )

  stub_var <- gt_object[["_boxhead"]][["var"]][which(gt_object[["_boxhead"]][["type"]] == "stub")]
  grp_var <- gt_object[["_boxhead"]][["var"]][which(gt_object[["_boxhead"]][["type"]] == "row_group")]

  stopifnot("img_source must be 'web' or 'local'" = img_source %in% c("web", "local"))

  gt_object %>%
    text_transform(
      locations = if (isTRUE(grp_var %in% column_names)) {
        cells_row_groups()
      } else if (isTRUE(stub_var %in% column_names)) {
        cells_stub(rows = !is.na({{ columns }}))
      } else {
        cells_body({{ columns }}, rows = !is.na({{ columns }}))
      },
      fn = function(x) {
        if (img_source == "web") {
          web_image(url = x, height = height)
        } else if (img_source == "local") {
          local_image(filename = x, height = height)
        }
      }
    ) %>%
    # NA Handling so doesn't return broken img
    text_transform(
      locations = if (isTRUE(stub_var %in% column_names)) {
        cells_stub(rows = is.na({{ columns }}))
      } else {
        cells_body({{ columns }}, rows = is.na({{ columns }}))
      },
      fn = function(x) {
        # warning("Column has some NA values, returning empty row", call. = FALSE)
        ""
      }
    )
}
