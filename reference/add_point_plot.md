# Create a dot plot from any range - add_point_plot

Create a dot plot from any range - add_point_plot

## Usage

``` r
add_point_plot(data, palette, add_label, width, vals_range, accuracy)
```

## Arguments

- data:

  The single value that will be used to plot the point.

- palette:

  A length 3 palette, used to highlight high/med/low

- add_label:

  A logical indicating whether to add the label or note. This will only
  be added if it is the first or last row.

- width:

  A numeric indicating the

- vals_range:

  vector of length two indicating range

- accuracy:

  A number to round to. Use (e.g.) `0.01` to show 2 decimal places of
  precision. If `NULL`, the default, uses a heuristic that should ensure
  breaks have the minimum number of digits needed to show the difference
  between adjacent values.

  Applied to rescaled data.

## Value

gt table
