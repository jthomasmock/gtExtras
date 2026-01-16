# Apply a table theme like PFF

Apply a table theme like PFF

## Usage

``` r
gt_theme_pff(gt_object, ..., divider, spanners, rank_col)
```

## Arguments

- gt_object:

  an existing gt_tbl object

- ...:

  Additional arguments passed to gt::tab_options()

- divider:

  A column name to add a divider to the left of - accepts tidy-eval
  column names.

- spanners:

  Character string that indicates the names of specific spanners you
  have created with gt::tab_spanner().

- rank_col:

  A column name to add a grey background to. Accepts tidy-eval column
  names.

## Value

gt_tbl

## Examples

    library(gt)
     out_df <- tibble::tribble(
       ~rank,            ~player, ~jersey, ~team,  ~g, ~pass, ~pr_snaps, ~rsh_pct, ~prp, ~prsh,
       1L, "Trey Hendrickson",    "91", "CIN", 16,  495,      454,     91.7, 10.8,  83.9,
       2L,        "T.J. Watt",    "90", "PIT", 15,  461,      413,     89.6, 10.7,  90.6,
       3L,      "Rashan Gary",    "52",  "GB", 16,  471,      463,     98.3, 10.4,  88.9,
       4L,      "Maxx Crosby",    "98",  "LV", 17,  599,      597,     99.7,   10,  91.8,
       5L,    "Matthew Judon",    "09",  "NE", 17,  510,      420,     82.4,  9.7,  73.2,
       6L,    "Myles Garrett",    "95", "CLV", 17,  554,      543,       98,  9.5,  92.7,
       7L,  "Shaquil Barrett",    "58",  "TB", 15,  563,      485,     86.1,  9.3,  81.5,
       8L,        "Nick Bosa",    "97",  "SF", 17,  529,      525,     99.2,  9.2,  89.8,
       9L, "Marcus Davenport",    "92",  "NO", 11,  302,      297,     98.3,  9.1,    82,
       10L,       "Joey Bosa",    "97", "LAC", 16,  495,      468,     94.5,  8.9,  90.3,
       11L,    "Robert Quinn",    "94", "CHI", 16,  445,      402,     90.3,  8.6,  79.7,
       12L,   "Randy Gregory",    "94", "DAL", 12,  315,      308,     97.8,  8.6,  84.4
     )
     out_df %>%
       gt() %>%
         tab_spanner(columns = pass:rsh_pct, label = "snaps") %>%
         tab_spanner(columns = prp:prsh, label = "grade") %>%
         gt_theme_pff(
           spanners = c("snaps", "grade"),
           divider = jersey, rank_col = rank
         ) %>%
         gt_color_box(
           columns = prsh, domain = c(0, 95), width = 50, accuracy = 0.1,
           palette = "pff"
         ) %>%
         cols_label(jersey = "#", g = "#G", rsh_pct = "RSH%") %>%
         tab_header(
           title = "Pass Rush Grades",
           subtitle = "Grades and pass rush stats"
         ) %>%
         gt_highlight_cols(columns = prp, fill = "#e4e8ec") %>%
         tab_style(
           style = list(
             cell_borders("bottom", "white"),
             cell_fill(color = "#393c40")
           ),
           locations = cells_column_labels(prp)

## Figures

![](figures/gt_theme_pff.png)

## See also

Other Themes:
[`gt_plt_bullet()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_bullet.md),
[`gt_plt_conf_int()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_conf_int.md),
[`gt_plt_dot()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_dot.md),
[`gt_theme_538()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_538.md),
[`gt_theme_dark()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_dark.md),
[`gt_theme_dot_matrix()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_dot_matrix.md),
[`gt_theme_espn()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_espn.md),
[`gt_theme_excel()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_excel.md),
[`gt_theme_guardian()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_guardian.md),
[`gt_theme_nytimes()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_nytimes.md)
