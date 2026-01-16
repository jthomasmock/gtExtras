# Merge and stack text with background coloring from two columns in `gt`

The `gt_merge_stack_color()` function takes an existing `gt` table and
merges column 1 and column 2, stacking column 1's text on top of column
2's. This variant also accepts a palette argument to colorize the
background values.

## Usage

``` r
gt_merge_stack_color(
  gt_object,
  top_val,
  color_val,
  palette = c("#512daa", "white", "#2d6a22"),
  domain = NULL,
  small_cap = TRUE,
  font_size = c("14px", "10px"),
  font_weight = c("bold", "bold")
)
```

## Arguments

- gt_object:

  An existing gt table object of class `gt_tbl`

- top_val:

  The column to stack on top. Will be converted to all caps, with bold
  text by default.

- color_val:

  The column to merge and place below, and controls the background color
  value. Will be smaller by default.

- palette:

  The colours or colour function that values will be mapped to, accepts
  a string or named palettes from paletteer.

- domain:

  The possible values that can be mapped. This can be a simple numeric
  range (e.g. `c(0, 100)`).

- small_cap:

  a logical indicating whether to use 'small-cap' on the top line of
  text, defaults to `TRUE`.

- font_size:

  a string of length 2 indicating the font-size in px of the top and
  bottom text

- font_weight:

  a string of length 2 indicating the 'font-weight' of the top and
  bottom text. Must be one of 'bold', 'normal', 'lighter'

## Value

An object of class `gt_tbl`.

## Examples

    set.seed(12345)
     dplyr::tibble(
       value = sample(state.name, 5),
       color_by = seq.int(10, 98, length.out = 5)
     ) %>%
       gt::gt() %>%
       gt_merge_stack_color(value, color_by)

## Figures

![](figures/merge-stack-color.png)

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
[`gt_merge_stack()`](https://jthomasmock.github.io/gtExtras/reference/gt_merge_stack.md),
[`gt_two_column_layout()`](https://jthomasmock.github.io/gtExtras/reference/gt_two_column_layout.md),
[`gtsave_extra()`](https://jthomasmock.github.io/gtExtras/reference/gtsave_extra.md),
[`img_header()`](https://jthomasmock.github.io/gtExtras/reference/img_header.md),
[`pad_fn()`](https://jthomasmock.github.io/gtExtras/reference/pad_fn.md),
[`tab_style_by_grp()`](https://jthomasmock.github.io/gtExtras/reference/tab_style_by_grp.md)
