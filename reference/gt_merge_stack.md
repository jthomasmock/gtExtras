# Merge and stack text from two columns in `gt`

The `gt_merge_stack()` function takes an existing `gt` table and merges
column 1 and column 2, stacking column 1's text on top of column 2's.
Top text is in all caps with black bold text, while the lower text is
smaller and dark grey.

## Usage

``` r
gt_merge_stack(
  gt_object,
  col1,
  col2,
  palette = c("black", "grey"),
  ...,
  small_cap = TRUE,
  font_size = c("14px", "10px"),
  font_weight = c("bold", "bold")
)
```

## Arguments

- gt_object:

  An existing gt table object of class `gt_tbl`

- col1:

  The column to stack on top. Will be converted to all caps, with black
  and bold text.

- col2:

  The column to merge and place below. Will be smaller and dark grey.

- palette:

  The colors for the text, where the first color is the top , ie `col1`
  and the second color is the bottom, ie `col2`. Defaults to
  `c("black","grey")`. For more information on built-in color names, see
  [`colors()`](https://rdrr.io/r/grDevices/colors.html).

- ...:

  Arguments passed on to
  [`scales::col2hcl`](https://scales.r-lib.org/reference/col2hcl.html)

  `h`

  :   Hue, `[0, 360]`

  `c`

  :   Chroma, `[0, 100]`

  `l`

  :   Luminance, `[0, 100]`

  `alpha`

  :   Alpha, `[0, 1]`.

- small_cap:

  a logical indicating whether to use 'small-cap' on the top line of
  text

- font_size:

  a string of length 2 indicating the font-size in px of the top and
  bottom text

- font_weight:

  a string of length 2 indicating the 'font-weight' of the top and
  bottom text. Must be one of 'bold', 'normal', 'lighter'

## Value

An object of class `gt_tbl`.

## Examples

    library(gt)
    teams <- "https://github.com/nflverse/nflfastR-data/raw/master/teams_colors_logos.rds"
    team_df <- readRDS(url(teams))

    stacked_tab <- team_df %>%
     dplyr::select(team_nick, team_abbr, team_conf, team_division, team_wordmark) %>%
     head(8) %>%
     gt(groupname_col = "team_conf") %>%
     gt_merge_stack(col1 = team_nick, col2 = team_division) %>%
     gt_img_rows(team_wordmark)

## Figures

![](figures/merge-stack.png)

## Function ID

2-6

## See also

Other Utilities:
[`add_text_img()`](https://jthomasmock.github.io/gtExtras/reference/add_text_img.md),
[`fa_icon_repeat()`](https://jthomasmock.github.io/gtExtras/reference/fa_icon_repeat.md),
[`fmt_pad_num()`](https://jthomasmock.github.io/gtExtras/reference/fmt_pad_num.md),
[`fmt_pct_extra()`](https://jthomasmock.github.io/gtExtras/reference/fmt_pct_extra.md),
[`fmt_symbol_first()`](https://jthomasmock.github.io/gtExtras/reference/fmt_symbol_first.md),
[`generate_df()`](https://jthomasmock.github.io/gtExtras/reference/generate_df.md),
[`gt_add_divider()`](https://jthomasmock.github.io/gtExtras/reference/gt_add_divider.md),
[`gt_badge()`](https://jthomasmock.github.io/gtExtras/reference/gt_badge.md),
[`gt_double_table()`](https://jthomasmock.github.io/gtExtras/reference/gt_double_table.md),
[`gt_duplicate_column()`](https://jthomasmock.github.io/gtExtras/reference/gt_duplicate_column.md),
[`gt_fa_rank_change()`](https://jthomasmock.github.io/gtExtras/reference/gt_fa_rank_change.md),
[`gt_fa_rating()`](https://jthomasmock.github.io/gtExtras/reference/gt_fa_rating.md),
[`gt_highlight_cols()`](https://jthomasmock.github.io/gtExtras/reference/gt_highlight_cols.md),
[`gt_highlight_rows()`](https://jthomasmock.github.io/gtExtras/reference/gt_highlight_rows.md),
[`gt_img_border()`](https://jthomasmock.github.io/gtExtras/reference/gt_img_border.md),
[`gt_img_circle()`](https://jthomasmock.github.io/gtExtras/reference/gt_img_circle.md),
[`gt_img_multi_rows()`](https://jthomasmock.github.io/gtExtras/reference/gt_img_multi_rows.md),
[`gt_img_rows()`](https://jthomasmock.github.io/gtExtras/reference/gt_img_rows.md),
[`gt_index()`](https://jthomasmock.github.io/gtExtras/reference/gt_index.md),
[`gt_merge_stack_color()`](https://jthomasmock.github.io/gtExtras/reference/gt_merge_stack_color.md),
[`gt_two_column_layout()`](https://jthomasmock.github.io/gtExtras/reference/gt_two_column_layout.md),
[`gtsave_extra()`](https://jthomasmock.github.io/gtExtras/reference/gtsave_extra.md),
[`img_header()`](https://jthomasmock.github.io/gtExtras/reference/img_header.md),
[`pad_fn()`](https://jthomasmock.github.io/gtExtras/reference/pad_fn.md),
[`tab_style_by_grp()`](https://jthomasmock.github.io/gtExtras/reference/tab_style_by_grp.md)
