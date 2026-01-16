# Return the underlying data, arranged by the internal index

This is a utility function to extract the underlying data from a `gt`
table. You can use it with a saved `gt` table, in the pipe (`%>%`) or
even within most other `gt` functions (eg
[`tab_style()`](https://gt.rstudio.com/reference/tab_style.html)). It
defaults to returning the column indicated as a vector, so that you can
work with the values. Typically this is used with logical statements to
affect one column based on the values in that specified secondary
column. Alternatively, you can extract the entire ordered data according
to the internal index as a `tibble`. This allows for even more complex
steps based on multiple indices.

## Usage

``` r
gt_index(gt_object, column, as_vector = TRUE)
```

## Arguments

- gt_object:

  An existing gt table object

- column:

  The column name that you intend to extract, accepts tidyeval semantics
  (ie `mpg` instead of `"mpg"`)

- as_vector:

  A logical indicating whether you'd like just the column indicated as a
  vector, or the entire dataframe

## Value

A vector or a `tibble`

## Figures

![](figures/gt_index_style.png)

## Function ID

2-20

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

# This is a key step, as gt will create the row groups
# based on first observation of the unique row items
# this sampling will return a row-group order for cyl of 6,4,8

set.seed(1234)
sliced_data <- mtcars %>%
  dplyr::group_by(cyl) %>%
  dplyr::slice_head(n = 3) %>%
  dplyr::ungroup() %>%
  # randomize the order
  dplyr::slice_sample(n = 9)

# not in "order" yet
sliced_data$cyl
#> [1] 6 6 6 4 8 4 8 8 4

# But unique order of 6,4,8
unique(sliced_data$cyl)
#> [1] 6 4 8

# creating a standalone basic table
test_tab <- sliced_data %>%
  gt(groupname_col = "cyl")

# can style a specific column based on the contents of another column
tab_out_styled <- test_tab %>%
  tab_style(
    locations = cells_body(mpg, rows = gt_index(., am) == 0),
    style = cell_fill("red")
  )

# OR can extract the underlying data in the "correct order"
# according to the internal gt structure, ie arranged by group
# by cylinder, 6,4,8
gt_index(test_tab, mpg, as_vector = FALSE)
#> # A tibble: 9 × 11
#>     mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
#>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1
#> 2  21       6  160    110  3.9   2.88  17.0     0     1     4     4
#> 3  21       6  160    110  3.9   2.62  16.5     0     1     4     4
#> 4  22.8     4  108     93  3.85  2.32  18.6     1     1     4     1
#> 5  24.4     4  147.    62  3.69  3.19  20       1     0     4     2
#> 6  22.8     4  141.    95  3.92  3.15  22.9     1     0     4     2
#> 7  14.3     8  360    245  3.21  3.57  15.8     0     0     3     4
#> 8  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2
#> 9  16.4     8  276.   180  3.07  4.07  17.4     0     0     3     3

# note that the order of the index data is
# not equivalent to the order of the input data
# however all the of the rows still match
sliced_data
#> # A tibble: 9 × 11
#>     mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
#>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1
#> 2  21       6  160    110  3.9   2.88  17.0     0     1     4     4
#> 3  21       6  160    110  3.9   2.62  16.5     0     1     4     4
#> 4  22.8     4  108     93  3.85  2.32  18.6     1     1     4     1
#> 5  14.3     8  360    245  3.21  3.57  15.8     0     0     3     4
#> 6  24.4     4  147.    62  3.69  3.19  20       1     0     4     2
#> 7  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2
#> 8  16.4     8  276.   180  3.07  4.07  17.4     0     0     3     3
#> 9  22.8     4  141.    95  3.92  3.15  22.9     1     0     4     2
```
