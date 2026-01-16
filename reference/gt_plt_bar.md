# Add bar plots into rows of a `gt` table

The `gt_plt_bar` function takes an existing `gt_tbl` object and adds
horizontal barplots via `ggplot2`. Note that values are plotted on a
shared x-axis, and a vertical black bar is added at x = zero. To add
labels to each of the of the bars, set `scale_type` to either
`'percent'` or `'number`'.

## Usage

``` r
gt_plt_bar(
  gt_object,
  column = NULL,
  color = "purple",
  ...,
  keep_column = FALSE,
  width = 40,
  scale_type = "none",
  text_color = "white"
)
```

## Arguments

- gt_object:

  An existing gt table object of class `gt_tbl`

- column:

  A single column wherein the bar plot should replace existing data.

- color:

  A character representing the color for the bar, defaults to purple.
  Accepts a named color (eg `'purple'`) or a hex color.

- ...:

  Additional arguments passed to
  [`scales::label_number()`](https://scales.r-lib.org/reference/label_number.html)
  or
  [`scales::label_percent()`](https://scales.r-lib.org/reference/label_percent.html),
  depending on what was specified in `scale_type`

- keep_column:

  `TRUE`/`FALSE` logical indicating if you want to keep a copy of the
  "plotted" column as raw values next to the plot itself..

- width:

  An integer indicating the width of the plot in pixels.

- scale_type:

  A string indicating additional text formatting and the addition of
  numeric labels to the plotted bars if not `'none'`. If `'none'`, no
  numbers will be added to the bar, but if `"number"` or `"percent"` are
  used, then the numbers in the plotted column will be added as a
  bar-label and formatted according to
  [`scales::label_percent()`](https://scales.r-lib.org/reference/label_percent.html)
  or
  [`scales::label_number()`](https://scales.r-lib.org/reference/label_number.html).

- text_color:

  A string indicating the color of text if `scale_type` is used.
  Defaults to `"white"`

## Value

An object of class `gt_tbl`.

## Examples

    library(gt)
    gt_plt_bar_tab <- mtcars %>%
      head() %>%
      gt() %>%
      gt_plt_bar(column = mpg, keep_column = TRUE)

![](figures/gt_plt_bar.png)

## Function ID

3-4

## See also

Other Plotting:
[`gt_plt_bar_pct()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_bar_pct.md),
[`gt_plt_bar_stack()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_bar_stack.md),
[`gt_plt_dist()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_dist.md),
[`gt_plt_percentile()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_percentile.md),
[`gt_plt_point()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_point.md),
[`gt_plt_sparkline()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_sparkline.md),
[`gt_plt_winloss()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_winloss.md)
