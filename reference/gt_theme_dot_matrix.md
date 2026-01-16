# Apply dot matrix theme to a gt table

Apply dot matrix theme to a gt table

## Usage

``` r
gt_theme_dot_matrix(gt_object, ..., color = "#b5dbb6", quiet = FALSE)
```

## Arguments

- gt_object:

  An existing gt table object of class `gt_tbl`

- ...:

  Additional arguments passed to
  [`gt::tab_options()`](https://gt.rstudio.com/reference/tab_options.html)

- color:

  A string indicating the color of the row striping, defaults to a light
  green. Accepts either named colors or hex colors.

- quiet:

  A logical to silence the warning about missing ID

## Value

An object of class `gt_tbl`.

## Examples

    library(gt)
    themed_tab <- head(mtcars) %>%
      gt() %>%
      gt_theme_dot_matrix() %>%
      tab_header(title = "Styled like dot matrix printer paper")

## Figures

![](figures/gt_dot_matrix.png)

## See also

Other Themes:
[`gt_plt_bullet()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_bullet.md),
[`gt_plt_conf_int()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_conf_int.md),
[`gt_plt_dot()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_dot.md),
[`gt_theme_538()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_538.md),
[`gt_theme_dark()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_dark.md),
[`gt_theme_espn()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_espn.md),
[`gt_theme_excel()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_excel.md),
[`gt_theme_guardian()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_guardian.md),
[`gt_theme_nytimes()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_nytimes.md),
[`gt_theme_pff()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_pff.md)
