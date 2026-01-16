# Apply FiveThirtyEight theme to a gt table

Apply FiveThirtyEight theme to a gt table

## Usage

``` r
gt_theme_538(gt_object, ..., quiet = FALSE)
```

## Arguments

- gt_object:

  An existing gt table object of class `gt_tbl`

- ...:

  Optional additional arguments to `gt::table_options()`

- quiet:

  A logical to silence the warning about missing ID

## Value

An object of class `gt_tbl`.

## Examples

    library(gt)
    themed_tab <- head(mtcars) %>%
      gt() %>%
      gt_theme_538()

## Figures

![](figures/gt_538.png)

## Function ID

1-1

## See also

Other Themes:
[`gt_plt_bullet()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_bullet.md),
[`gt_plt_conf_int()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_conf_int.md),
[`gt_plt_dot()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_dot.md),
[`gt_theme_dark()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_dark.md),
[`gt_theme_dot_matrix()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_dot_matrix.md),
[`gt_theme_espn()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_espn.md),
[`gt_theme_excel()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_excel.md),
[`gt_theme_guardian()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_guardian.md),
[`gt_theme_nytimes()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_nytimes.md),
[`gt_theme_pff()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_pff.md)
