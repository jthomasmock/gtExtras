# Insert an alert icon to a specific column

Insert an alert icon to a specific column

## Usage

``` r
gt_alert_icon(
  gt_object,
  column,
  palette = c("#a962b6", "#f1f1f1", "#378e38"),
  domain = NULL,
  height = "10px",
  direction = 1,
  align = "center",
  v_pad = -5
)
```

## Arguments

- gt_object:

  An existing gt table object of class `gt_tbl`

- column:

  The column wherein the numeric values should be replaced with circular
  alert icons.

- palette:

  The colours or colour function that values will be mapped to. Can be a
  character vector (eg `c("white", "red")` or hex colors) or a named
  palette from the `{paletteer}` package in the `package::palette_name`
  structure.

- domain:

  The possible values that can be mapped. This should be a simple
  numeric range (e.g. `c(0, 100)`)

- height:

  A character string indicating the height in pixels, like "10px"

- direction:

  The direction of the `paletteer` palette, should be either `-1` for
  reversed or the default of `1` for the existing direction.

- align:

  Character string indicating alignment of the column, defaults to
  "left"

- v_pad:

  A numeric value indicating the vertical padding, defaults to -5 to aid
  in centering within the vertical space.

## Value

a gt table

## Examples

    head(mtcars) %>%
      dplyr::mutate(warn = ifelse(mpg >= 21, 1, 0), .before = mpg) %>%
      gt::gt() %>%
      gt_alert_icon(warn)

![](figures/reference/figures/gt_alert_icon-binary.png)
