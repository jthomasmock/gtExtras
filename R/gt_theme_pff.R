#' Apply a table theme like PFF
#'
#' @param gt_object an existing gt_tbl object
#' @param ... Additional arguments passed to gt::tab_options()
#' @param divider A column name to add a divider to the left of - accepts tidy-eval column names.
#' @param spanners Character string that indicates the names of specific spanners you have created with gt::tab_spanner().
#' @param rank_col A column name to add a grey background to. Accepts tidy-eval column names.
#'
#' @return gt_tbl
#' @export
#'
#' @section Examples:
#'
#' ``` r
#' library(gt)
#'  out_df <- tibble::tribble(
#'    ~rank,            ~player, ~jersey, ~team,  ~g, ~pass, ~pr_snaps, ~rsh_pct, ~prp, ~prsh,
#'    1L, "Trey Hendrickson",    "91", "CIN", 16,  495,      454,     91.7, 10.8,  83.9,
#'    2L,        "T.J. Watt",    "90", "PIT", 15,  461,      413,     89.6, 10.7,  90.6,
#'    3L,      "Rashan Gary",    "52",  "GB", 16,  471,      463,     98.3, 10.4,  88.9,
#'    4L,      "Maxx Crosby",    "98",  "LV", 17,  599,      597,     99.7,   10,  91.8,
#'    5L,    "Matthew Judon",    "09",  "NE", 17,  510,      420,     82.4,  9.7,  73.2,
#'    6L,    "Myles Garrett",    "95", "CLV", 17,  554,      543,       98,  9.5,  92.7,
#'    7L,  "Shaquil Barrett",    "58",  "TB", 15,  563,      485,     86.1,  9.3,  81.5,
#'    8L,        "Nick Bosa",    "97",  "SF", 17,  529,      525,     99.2,  9.2,  89.8,
#'    9L, "Marcus Davenport",    "92",  "NO", 11,  302,      297,     98.3,  9.1,    82,
#'    10L,       "Joey Bosa",    "97", "LAC", 16,  495,      468,     94.5,  8.9,  90.3,
#'    11L,    "Robert Quinn",    "94", "CHI", 16,  445,      402,     90.3,  8.6,  79.7,
#'    12L,   "Randy Gregory",    "94", "DAL", 12,  315,      308,     97.8,  8.6,  84.4
#'  )
#'  out_df %>%
#'    gt() %>%
#'      tab_spanner(columns = pass:rsh_pct, label = "snaps") %>%
#'      tab_spanner(columns = prp:prsh, label = "grade") %>%
#'      gt_theme_pff(
#'        spanners = c("snaps", "grade"),
#'        divider = jersey, rank_col = rank
#'      ) %>%
#'      gt_color_box(
#'        columns = prsh, domain = c(0, 95), width = 50, accuracy = 0.1,
#'        palette = "pff"
#'      ) %>%
#'      cols_label(jersey = "#", g = "#G", rsh_pct = "RSH%") %>%
#'      tab_header(
#'        title = "Pass Rush Grades",
#'        subtitle = "Grades and pass rush stats"
#'      ) %>%
#'      gt_highlight_cols(columns = prp, fill = "#e4e8ec") %>%
#'      tab_style(
#'        style = list(
#'          cell_borders("bottom", "white"),
#'          cell_fill(color = "#393c40")
#'        ),
#'        locations = cells_column_labels(prp)
#' ```
#' @section Figures:
#' \if{html}{\figure{gt_theme_pff.png}{options: width=80\%}}
#'
#' @family Themes
gt_theme_pff <- function(gt_object, ..., divider, spanners, rank_col) {
  is_gt_stop(gt_object)

  built_table <- gt_object %>%
    opt_row_striping() %>%
    opt_all_caps() %>%
    tab_options(
      table_body.hlines.color = "transparent",
      table.border.top.width = px(3),
      table.border.top.color = "transparent",
      table.border.bottom.color = "lightgrey",
      table.border.bottom.width = px(1),
      column_labels.border.top.width = px(3),
      column_labels.padding = px(6),
      column_labels.border.top.color = "transparent",
      column_labels.border.bottom.width = px(3),
      column_labels.border.bottom.color = "transparent",
      row.striping.background_color = "#f5f5f5",
      data_row.padding = px(6),
      heading.align = "left",
      heading.title.font.size = px(30),
      heading.title.font.weight = "bold",
      heading.subtitle.font.size = px(16),
      table.font.size = px(12),
      ...
    ) %>%
    # customize font
    opt_table_font(
      font = google_font("Roboto")
    )

  if (!missing(spanners)) {
    span_vars <- unlist(gt_object[["_spanners"]][["vars"]])

    # add blank span and modify
    built_table <- built_table %>%
      tab_spanner(columns = c(gt::everything(), -any_of(span_vars)), label = " ", id = "blank") %>%
      tab_style(
        style = list(
          cell_fill(color = "transparent"),
          cell_text(color = "transparent", size = px(9), weight = "bold"),
          cell_borders(sides = "left", color = "transparent", weight = px(3)),
          cell_borders(sides = "top", color = "transparent", weight = px(3))
        ),
        locations = list(
          cells_column_spanners(
            spanners = "blank"
          )
        )
      ) %>%
      # add real spanners and style
      tab_style(
        style = list(
          cell_fill(color = "#f5f5f5"),
          cell_text(color = "#878e94", size = px(10), weight = "bold"),
          cell_borders(sides = "left", color = "white", weight = px(3)),
          cell_borders(sides = "top", color = "white", weight = px(3))
        ),
        locations = list(
          cells_column_spanners(
            spanners = spanners
          )
        )
      )
  }

  if (!missing(divider)) {
    built_table <- built_table %>%
      tab_style(
        style = cell_borders(sides = "left", color = "lightgrey", weight = px(2)),
        locations = cells_body(columns = {{ divider }})
      ) %>%
      tab_style(
        style = cell_borders("left", color = "#212426", weight = px(2)),
        locations = cells_column_labels(columns = {{ divider }})
      )
  }

  if (!missing(rank_col)) {
    built_table <- built_table %>%
      tab_style(
        style = list(
          cell_fill(color = "#e4e8ec"),
          cell_borders(color = "#e4e8ec")
        ),
        locations = cells_body(columns = {{ rank_col }})
      ) %>%
      cols_align("center", {{ rank_col }})
  }

  built_table %>%
    tab_style(
      style = list(
        cell_fill(color = "#585d63"),
        cell_text(color = "white", size = px(10), weight = "bold"),
        cell_borders(
          sides = c("bottom"), color = "#585d63",
          weight = px(2.5)
        )
      ),
      locations = list(
        gt::cells_column_labels(),
        gt::cells_stubhead()
      )
    )
}
