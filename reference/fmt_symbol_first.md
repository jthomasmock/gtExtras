# Aligning first-row text only

This is an experimental function that allows you to apply a
suffix/symbol to only the first row of a table, and maintain the
alignment with whitespace in the remaining rows.

## Usage

``` r
fmt_symbol_first(
  gt_object,
  column = NULL,
  symbol = NULL,
  suffix = "",
  decimals = NULL,
  last_row_n = NULL,
  symbol_first = FALSE,
  scale_by = NULL,
  gfont = NULL
)
```

## Arguments

- gt_object:

  An existing gt table object of class `gt_tbl`

- column:

  columns to apply color to with tidyeval

- symbol:

  The HTML code or raw character string of the symbol being inserted,
  optionally

- suffix:

  a suffix to add, optionally

- decimals:

  the number of decimal places to round to

- last_row_n:

  Defining the last row to apply this to. The function will attempt to
  guess the proper length, but you can always hardcode a specific
  length.

- symbol_first:

  TRUE/FALSE - symbol before after suffix.

- scale_by:

  A numeric value to multiply the values by. Useful for scaling
  percentages from 0 to 1 to 0 to 100.

- gfont:

  A string passed to
  [`gt::google_font()`](https://gt.rstudio.com/reference/google_font.html) -
  Existing Google Monospaced fonts are available at:
  [fonts.google.com](https://fonts.google.com/?category=Monospace&preview.text=0123456789&preview.text_type=custom)

## Value

An object of class `gt_tbl`.

## Figures

![](figures/gt_fmt_first.png)

## Function ID

2-1

## See also

Other Utilities:
[`add_text_img()`](https://jthomasmock.github.io/gtExtras/reference/add_text_img.md),
[`fa_icon_repeat()`](https://jthomasmock.github.io/gtExtras/reference/fa_icon_repeat.md),
[`fmt_pad_num()`](https://jthomasmock.github.io/gtExtras/reference/fmt_pad_num.md),
[`fmt_pct_extra()`](https://jthomasmock.github.io/gtExtras/reference/fmt_pct_extra.md),
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
[`gt_merge_stack()`](https://jthomasmock.github.io/gtExtras/reference/gt_merge_stack.md),
[`gt_merge_stack_color()`](https://jthomasmock.github.io/gtExtras/reference/gt_merge_stack_color.md),
[`gt_two_column_layout()`](https://jthomasmock.github.io/gtExtras/reference/gt_two_column_layout.md),
[`gtsave_extra()`](https://jthomasmock.github.io/gtExtras/reference/gtsave_extra.md),
[`img_header()`](https://jthomasmock.github.io/gtExtras/reference/img_header.md),
[`pad_fn()`](https://jthomasmock.github.io/gtExtras/reference/pad_fn.md),
[`tab_style_by_grp()`](https://jthomasmock.github.io/gtExtras/reference/tab_style_by_grp.md)

## Examples

``` r
library(gt)
fmted_tab <- gtcars %>%
  head() %>%
  dplyr::select(mfr, year, bdy_style, mpg_h, hp) %>%
  dplyr::mutate(mpg_h = rnorm(n = dplyr::n(), mean = 22, sd = 1)) %>%
  gt::gt() %>%
  gt::opt_table_lines() %>%
  fmt_symbol_first(column = mfr, symbol = "&#x24;", last_row_n = 6) %>%
  fmt_symbol_first(column = year, suffix = "%") %>%
  fmt_symbol_first(column = mpg_h, symbol = "&#37;", decimals = 1) %>%
  fmt_symbol_first(hp, symbol = "&#176;", suffix = "F", symbol_first = TRUE)
```
