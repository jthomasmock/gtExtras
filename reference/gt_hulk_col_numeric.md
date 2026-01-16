# Apply 'hulk' palette to specific columns in a gt table.

The hulk name comes from the idea of a diverging purple and green theme
that is colorblind safe and visually appealing. It is a useful
alternative to the red/green palette where purple typically can indicate
low or "bad" value, and green can indicate a high or "good" value.

## Usage

``` r
gt_hulk_col_numeric(
  gt_object,
  columns = NULL,
  domain = NULL,
  ...,
  trim = FALSE
)
```

## Arguments

- gt_object:

  An existing gt table object of class `gt_tbl`

- columns:

  The columns wherein changes to cell data colors should occur.

- domain:

  The possible values that can be mapped.

  For `col_numeric` and `col_bin`, this can be a simple numeric range
  (e.g. `c(0, 100)`); `col_quantile` needs representative numeric data;
  and `col_factor` needs categorical data.

  If `NULL`, then whenever the resulting colour function is called, the
  `x` value will represent the domain. This implies that if the function
  is invoked multiple times, the encoding between values and colours may
  not be consistent; if consistency is needed, you must provide a
  non-`NULL` domain.

- ...:

  Additional arguments passed to
  [`scales::col_numeric()`](https://scales.r-lib.org/reference/col_numeric.html)

- trim:

  trim the palette to give less intense maximal colors

## Value

An object of class `gt_tbl`.

## Examples

     library(gt)
     # basic use
     hulk_basic <- mtcars %>%
       head() %>%
       gt::gt() %>%
       gt_hulk_col_numeric(mpg)

     hulk_trim <- mtcars %>%
       head() %>%
       gt::gt() %>%
       # trim gives small range of colors
       gt_hulk_col_numeric(mpg:disp, trim = TRUE)

     # option to reverse the color palette
     hulk_rev <- mtcars %>%
       head() %>%
       gt::gt() %>%
       # trim gives small range of colors
       gt_hulk_col_numeric(mpg:disp, reverse = TRUE)

## Figures

![](figures/hulk_basic.png)

![](figures/hulk_trim.png)

![](figures/hulk_reverse.png)

## Function ID

4-1

## See also

Other Colors:
[`gt_color_box()`](https://jthomasmock.github.io/gtExtras/reference/gt_color_box.md),
[`gt_color_rows()`](https://jthomasmock.github.io/gtExtras/reference/gt_color_rows.md)
