# Add color highlighting to a specific row

The `gt_highlight_rows` function takes an existing `gt_tbl` object and
adds highlighting color to the cell background of a specific row. The
function accepts rows only by number (not by logical expression) for
now.

## Usage

``` r
gt_highlight_rows(
  gt_object,
  columns = gt::everything(),
  rows = TRUE,
  fill = "#80bcd8",
  alpha = 0.8,
  font_weight = "bold",
  font_color = "#000000",
  bold_target_only = FALSE,
  target_col = c()
)
```

## Arguments

- gt_object:

  An existing gt table object of class `gt_tbl`

- columns:

  Specific columns to apply color to, accepts either `tidyeval` colum
  names or columns by position.

- rows:

  The rows to apply the highlight to. Can either by a `tidyeval`
  compliant statement (like `cyl == 4`), a number indicating specific
  row(s) to apply color to or `TRUE` to indicate all rows.

- fill:

  A character string indicating the fill color. If nothing is provided,
  then "#80bcd8" (light blue) will be used as a default.

- alpha:

  An optional alpha transparency value for the color as single value in
  the range of 0 (fully transparent) to 1 (fully opaque). If not
  provided the fill color will either be fully opaque or use alpha
  information from the color value if it is supplied in the \#RRGGBBAA
  format.

- font_weight:

  A string or number indicating the weight of the font. Can be a
  text-based keyword such as "normal", "bold", "lighter", "bolder", or,
  a numeric value between 1 and 1000, inclusive. Note that only variable
  fonts may support the numeric mapping of weight.

- font_color:

  A character string indicating the text color. If nothing is provided,
  then "#000000" (black) will be used as a default.

- bold_target_only:

  A logical of TRUE/FALSE indicating whether to apply bold to only the
  specific `target_col`. You must indicate a specific column with
  `target_col`.

- target_col:

  A specific `tidyeval` column to apply bold text to, which allows for
  normal weight text for the remaining highlighted columns.

## Value

An object of class `gt_tbl`.

## Examples

    library(gt)
    basic_use <- head(mtcars[,1:5]) %>%
     tibble::rownames_to_column("car") %>%
       gt() %>%
       gt_highlight_rows(rows = 2, font_weight = "normal")

    target_bold_column <- head(mtcars[,1:5]) %>%
       tibble::rownames_to_column("car") %>%
       gt() %>%
       gt_highlight_rows(
         rows = 5,
         fill = "lightgrey",
         bold_target_only = TRUE,
         target_col = car
       )

## Figures

![](figures/highlight-basic.png)![](figures/highlight-target.png)

## Function ID

2-10

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
