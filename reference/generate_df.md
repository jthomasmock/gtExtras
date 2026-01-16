# Generate pseudorandom dataframes with specific parameters

This function is a small utility to create a specific length dataframe
with a set number of groups, specific mean/sd per group. Note that the
total length of the dataframe will be `n` \* `n_grps`.

## Usage

``` r
generate_df(n = 10L, n_grps = 1L, mean = c(10), sd = mean/10, with_seed = NULL)
```

## Arguments

- n:

  An integer indicating the number of rows per group, default to `10`

- n_grps:

  An integer indicating the number of rows per group, defaults to `1`

- mean:

  A number indicating the mean of the randomly generated values, must be
  a vector of equal length to the `n_grps`

- sd:

  A number indicating the standard deviation of the randomly generated
  values, must be a vector of equal length to the `n_grps`

- with_seed:

  A seed to make the randomization reproducible

## Value

a tibble/dataframe

## Function ID

2-19

## See also

Other Utilities:
[`add_text_img()`](https://jthomasmock.github.io/gtExtras/reference/add_text_img.md),
[`fa_icon_repeat()`](https://jthomasmock.github.io/gtExtras/reference/fa_icon_repeat.md),
[`fmt_pad_num()`](https://jthomasmock.github.io/gtExtras/reference/fmt_pad_num.md),
[`fmt_pct_extra()`](https://jthomasmock.github.io/gtExtras/reference/fmt_pct_extra.md),
[`fmt_symbol_first()`](https://jthomasmock.github.io/gtExtras/reference/fmt_symbol_first.md),
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
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
generate_df(
  100L,
  n_grps = 5,
  mean = seq(10, 50, length.out = 5)
) %>%
  group_by(grp) %>%
  summarise(
    mean = mean(values), # mean is approx mean
    sd = sd(values), # sd is approx sd
    n = n(), # each grp is of length n
    # showing that the sd default of mean/10 works
    `mean/sd` = round(mean / sd, 1)
  )
#> # A tibble: 5 × 5
#>   grp    mean    sd     n `mean/sd`
#>   <chr> <dbl> <dbl> <int>     <dbl>
#> 1 grp-1  9.87  1.01   100       9.7
#> 2 grp-2 19.9   1.95   100      10.2
#> 3 grp-3 29.6   2.78   100      10.6
#> 4 grp-4 39.6   3.92   100      10.1
#> 5 grp-5 50.1   5.13   100       9.8
```
