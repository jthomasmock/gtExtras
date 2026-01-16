# Add rank change indicators to a gt table

Takes an existing `gt` table and converts a column of integers into
various types of up/down arrows. Note that you need to specify a palette
of three colors, in the order of up, neutral, down. Defaults to green,
grey, purple. There are 6 supported `fa_type`, representing various
arrows. Note that you can use `font_color = 'match'` to match the
palette across arrows and text. `show_text = FALSE` will remove the text
from the column, resulting only in colored arrows.

## Usage

``` r
gt_fa_rank_change(
  gt_object,
  column,
  palette = c("#1b7837", "lightgrey", "#762a83"),
  fa_type = c("angles", "arrow", "turn", "chevron", "caret"),
  font_color = "black",
  show_text = TRUE
)
```

## Arguments

- gt_object:

  An existing `gt` table object

- column:

  The single column that you would like to convert to rank change
  indicators.

- palette:

  A character vector of length 3. Colors can be represented as hex
  values or named colors. Colors should be in the order of up-arrow,
  no-change, down-arrow, defaults to green, grey, purple.

- fa_type:

  The name of the Fontawesome icon, limited to 5 types of various
  arrows, one of `c("angles", "arrow", "turn", "chevron", "caret")`

- font_color:

  A string, indicating the color of the font, can also be returned as
  `'match'` to match the font color to the arrow palette.

- show_text:

  A logical indicating whether to show/hide the values in the column.

## Value

a `gt` table

## Examples

    rank_table <- dplyr::tibble(x = c(1:3, -1, -2, -5, 0)) %>%
      gt::gt() %>%
      gt_fa_rank_change(x, font_color = "match")

## Figures

![](figures/fa_rank_change.png)

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
