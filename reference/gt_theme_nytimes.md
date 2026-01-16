# Apply NY Times theme to a `gt` table

Apply NY Times theme to a `gt` table

## Usage

``` r
gt_theme_nytimes(gt_object, ...)
```

## Arguments

- gt_object:

  An existing gt table object of class `gt_tbl`

- ...:

  Optional additional arguments to `gt::table_options()`

## Value

An object of class `gt_tbl`.

## Figures

![](figures/gt_nyt.png)

## Function ID

1-3

## See also

Other Themes:
[`gt_plt_bullet()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_bullet.md),
[`gt_plt_conf_int()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_conf_int.md),
[`gt_plt_dot()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_dot.md),
[`gt_theme_538()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_538.md),
[`gt_theme_dark()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_dark.md),
[`gt_theme_dot_matrix()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_dot_matrix.md),
[`gt_theme_espn()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_espn.md),
[`gt_theme_excel()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_excel.md),
[`gt_theme_guardian()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_guardian.md),
[`gt_theme_pff()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_pff.md)

## Examples

``` r
library(gt)
nyt_tab <- head(mtcars) %>%
  gt() %>%
  gt_theme_nytimes() %>%
  tab_header(title = "Table styled like the NY Times")
```
