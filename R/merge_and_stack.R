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
#' @param small_cap a logical indicating whether to use 'small-cap' on the top line of text
#' @param font_size a string of length 2 indicating the font-size in px of the top and bottom text
#' @param font_weight a string of length 2 indicating the 'font-weight' of the top and bottom text. Must be one of 'bold', 'normal', 'lighter'
#' @inheritDotParams scales::col2hcl -colour
#' @return An object of class `gt_tbl`.
#' @export
#' @section Examples:
#'
#' ```r
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
#' ```
#' @section Figures:
#' \if{html}{\figure{merge-stack.png}{options: width=50\%}}
#'
#' @family Utilities
#' @section Function ID:
#' 2-6

gt_merge_stack <- function(gt_object, col1, col2, palette = c("black", "grey"), ..., small_cap = TRUE,
                           font_size = c("14px", "10px"), font_weight = c("bold", "bold")) {
  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))
  stopifnot("There must be two colors" = length(palette) == 2)
  stopifnot("There must be two 'font_size'" = length(font_size) == 2)
  stopifnot("There must be two 'font_weight'" = length(font_weight) == 2)

  stopifnot("'font_size' must be a string with 'px'" = all(grepl(x = font_size, pattern = "px")))
  stopifnot("'font_weight' must be a 'bold', 'normal' or 'lighter'" = font_weight %in% c("bold", "normal", "lighter"))

  # translate colors to hcl. Allows R color names like "grey30".
  colors <- scales::col2hcl(palette, ...)

  col1_bare <- rlang::enexpr(col1) %>% rlang::as_string()

  row_name_var <- gt_object[["_boxhead"]][["var"]][which(gt_object[["_boxhead"]][["type"]] == "stub")]

  # segment data with bare string column name
  data_in <- gt_index(gt_object, column = {{ col2 }})

  gt_object %>%
    text_transform(
      locations = if (isTRUE(row_name_var == col1_bare)) {
        cells_stub(rows = gt::everything())
      } else {
        cells_body(columns = {{ col1 }})
      },
      fn = function(x) {
        if (small_cap) {
          font_variant <- "small-caps"
        } else {
          font_variant <- "normal"
        }

        glue::glue(
          "<div style='line-height:{font_size[1]}'><span style='font-weight:{font_weight[1]};font-variant:{font_variant};color:{colors[1]};font-size:{font_size[1]}'>{x}</span></div>
        <div style='line-height:{font_size[2]}'><span style ='font-weight:{font_weight[2]};color:{colors[2]};font-size:{font_size[2]}'>{data_in}</span></div>"
        )
      }
    ) %>%
    cols_hide(columns = {{ col2 }})
}

#' Merge and stack text with background coloring from two columns in `gt`
#'
#' @description
#' The `gt_merge_stack_color()` function takes an existing `gt` table and merges
#' column 1 and column 2, stacking column 1's text on top of column 2's.
#' This variant also accepts a palette argument to colorize the background
#' values.
#'
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param top_val The column to stack on top. Will be converted to all caps, with bold text by default.
#' @param color_val The column to merge and place below, and controls the background color value. Will be smaller by default.
#' @param palette The colours or colour function that values will be mapped to, accepts a string or named palettes from paletteer.
#' @param domain The possible values that can be mapped. This can be a simple numeric range (e.g. `c(0, 100)`).
#' @param small_cap a logical indicating whether to use 'small-cap' on the top line of text, defaults to `TRUE`.
#' @param font_size a string of length 2 indicating the font-size in px of the top and bottom text
#' @param font_weight a string of length 2 indicating the 'font-weight' of the top and bottom text. Must be one of 'bold', 'normal', 'lighter'
#'
#' @return An object of class `gt_tbl`.
#' @export
#'
#' @section Examples:
#'
#' ```r
#' set.seed(12345)
#'  dplyr::tibble(
#'    value = sample(state.name, 5),
#'    color_by = seq.int(10, 98, length.out = 5)
#'  ) %>%
#'    gt::gt() %>%
#'    gt_merge_stack_color(value, color_by)
#' ```
#' @section Figures:
#' \if{html}{\figure{merge-stack-color.png}{options: width=50\%}}
#'
#' @family Utilities

gt_merge_stack_color <- function(gt_object, top_val, color_val,
                                 palette = c("#512daa", "white", "#2d6a22"),
                                 domain = NULL,
                                 small_cap = TRUE,
                                 font_size = c("14px", "10px"),
                                 font_weight = c("bold", "bold")) {
  stopifnot("Table must be of class 'gt_tbl'" = "gt_tbl" %in% class(gt_object))
  if (is.null(domain)) {
    warning(
      "Domain not specified, defaulting to observed range within each specified column.",
      call. = FALSE
    )
  }

  if (small_cap) {
    font_variant <- "small-caps"
  } else {
    font_variant <- "normal"
  }

  data_in <- gt_index(gt_object, column = {{ top_val }})

  gt_object %>%
    data_color(
      columns = {{ color_val }},
      fn = scales::col_numeric(
        palette = if (grepl(x = palette[1], pattern = "::")) {
          paletteer::paletteer_d(
            palette = palette
          ) %>% as.character()
        } else {
          palette
        },
        domain = domain
      )
    ) %>%
    text_transform(
      locations = cells_body({{ color_val }}),
      fn = function(x) {
        merge_pattern <- glue::glue(
          '<div style="font-size:{font_size[1]}; font-weight:{font_weight[1]};font-variant:{font_variant};">{data_in}<br>',
          '</div><div style="font-size:{font_size[2]};font-weight:{font_weight[2]};">{x}</div>'
        )
      }
    ) %>%
    cols_hide(columns = {{ top_val }})
}
