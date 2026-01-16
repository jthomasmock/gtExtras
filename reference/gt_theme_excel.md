# Apply Excel-style theme to an existing gt table

Apply Excel-style theme to an existing gt table

## Usage

``` r
gt_theme_excel(gt_object, ..., color = "lightgrey")
```

## Arguments

- gt_object:

  An existing gt table object of class `gt_tbl`

- ...:

  Additional arguments passed to
  [`gt::tab_options()`](https://gt.rstudio.com/reference/tab_options.html)

- color:

  A string indicating the color of the row striping, defaults to a light
  gray Accepts either named colors or hex colors.

## Value

An object of class `gt_tbl`.

## Figures

![](figures/gt_excel.png)

## Function ID

1-7

## See also

Other Themes:
[`gt_plt_bullet()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_bullet.md),
[`gt_plt_conf_int()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_conf_int.md),
[`gt_plt_dot()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_dot.md),
[`gt_theme_538()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_538.md),
[`gt_theme_dark()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_dark.md),
[`gt_theme_dot_matrix()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_dot_matrix.md),
[`gt_theme_espn()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_espn.md),
[`gt_theme_guardian()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_guardian.md),
[`gt_theme_nytimes()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_nytimes.md),
[`gt_theme_pff()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_pff.md)

## Examples

``` r
library(gt)
themed_tab <- head(mtcars) %>%
  gt() %>%
  gt_theme_excel() %>%
  tab_header(title = "Styled like your old pal, Excel")
```
