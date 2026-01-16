# Add scaled colors according to numeric values or categories/factors

The `gt_color_rows` function takes an existing `gt_tbl` object and
applies pre-existing palettes from the `{paletteer}` package or custom
palettes defined by the user. This function is a custom wrapper around
[`gt::data_color()`](https://gt.rstudio.com/reference/data_color.html),
and uses some of the boilerplate code. Basic use is simpler than
[`data_color()`](https://gt.rstudio.com/reference/data_color.html).

## Usage

``` r
gt_color_rows(
  gt_object,
  columns,
  palette = "ggsci::red_material",
  direction = 1,
  domain = NULL,
  pal_type = c("discrete", "continuous"),
  ...
)
```

## Arguments

- gt_object:

  An existing gt table object of class `gt_tbl`

- columns:

  The columns wherein changes to cell data colors should occur.

- palette:

  The colours or colour function that values will be mapped to

- direction:

  Either `1` or `-1`. If `-1` the palette will be reversed.

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

- pal_type:

  A string indicating the palette type (one of
  `c("discrete", "continuous")`)

- ...:

  Additional arguments passed to
  [`scales::col_numeric()`](https://scales.r-lib.org/reference/col_numeric.html)

## Value

An object of class `gt_tbl`.

## Examples

     library(gt)
     # basic use
     basic_use <- mtcars %>%
       head(15) %>%
       gt() %>%
       gt_color_rows(mpg:disp)
     # change palette to one that paletteer recognizes
     change_pal <- mtcars %>%
       head(15) %>%
       gt() %>%
       gt_color_rows(mpg:disp, palette = "ggsci::blue_material")
     # change palette to raw values
     vector_pal <- mtcars %>%
       head(15) %>%
       gt() %>%
       gt_color_rows(
         mpg:disp, palette = c("white", "green"))
         # could also use palette = c("#ffffff", "##00FF00")

     # use discrete instead of continuous palette
     discrete_pal <- mtcars %>%
      head(15) %>%
      gt() %>%
      gt_color_rows(
      cyl, pal_type = "discrete",
      palette = "ggthemes::colorblind", domain = range(mtcars$cyl)
        )
     # use discrete and manually define range
     range_pal <- mtcars %>%
       dplyr::select(gear, mpg:hp) %>%
       head(15) %>%
       gt() %>%
       gt_color_rows(
       gear, pal_type = "discrete", direction = -1,
       palette = "colorblindr::OkabeIto_black", domain = c(3,4,5))

## Figures

![](figures/basic-pal.png)

![](figures/blue-pal.png)

![](figures/custom-pal.png)

![](figures/discrete-pal.png)

## Function ID

4-2

## See also

Other Colors:
[`gt_color_box()`](https://jthomasmock.github.io/gtExtras/reference/gt_color_box.md),
[`gt_hulk_col_numeric()`](https://jthomasmock.github.io/gtExtras/reference/gt_hulk_col_numeric.md)
