# Add a dividing border to an existing `gt` table.

The `gt_add_divider` function takes an existing `gt_tbl` object and adds
borders or dividers to specific columns.

## Usage

``` r
gt_add_divider(
  gt_object,
  columns,
  sides = "right",
  color = "grey",
  style = "solid",
  weight = px(2),
  include_labels = TRUE
)
```

## Arguments

- gt_object:

  An existing gt table object of class `gt_tbl`

- columns:

  Specific columns to apply color to, accepts either `tidyeval` colum
  names or columns by position.

- sides:

  The border sides to be modified. Options include `"left"`, `"right"`,
  `"top"`, and `"bottom"`. For all borders surrounding the selected
  cells, we can use the \`"all"“ option.

- color, style, weight:

  The border color, style, and weight. The `color` can be defined with a
  color name or with a hexadecimal color code. The default `color` value
  is `"#00FFFFFF"` (black). The `style` can be one of either `"solid"`
  (the default), `"dashed"`, or `"dotted"`. The `weight` of the border
  lines is to be given in pixel values (the
  [`px()`](https://gt.rstudio.com/reference/px.html) helper function is
  useful for this. The default value for `weight` is `"1px"`.

- include_labels:

  A logical, either `TRUE` or `FALSE` indicating whether to also add
  dividers through the column labels.

## Value

An object of class `gt_tbl`.

## Examples

    library(gt)
    basic_divider <- head(mtcars) %>%
      gt() %>%
      gt_add_divider(columns = "cyl", style = "dashed")

## Figures

![](figures/add-divider.png)

## Function ID

2-11

## See also

Other Utilities:
[`add_text_img()`](https://jthomasmock.github.io/gtExtras/reference/add_text_img.md),
[`fa_icon_repeat()`](https://jthomasmock.github.io/gtExtras/reference/fa_icon_repeat.md),
[`fmt_pad_num()`](https://jthomasmock.github.io/gtExtras/reference/fmt_pad_num.md),
[`fmt_pct_extra()`](https://jthomasmock.github.io/gtExtras/reference/fmt_pct_extra.md),
[`fmt_symbol_first()`](https://jthomasmock.github.io/gtExtras/reference/fmt_symbol_first.md),
[`generate_df()`](https://jthomasmock.github.io/gtExtras/reference/generate_df.md),
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
