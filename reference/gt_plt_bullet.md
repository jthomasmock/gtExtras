# Create an inline 'bullet chart' in a gt table

Create an inline 'bullet chart' in a gt table

## Usage

``` r
gt_plt_bullet(
  gt_object,
  column = NULL,
  target = NULL,
  width = 65,
  palette = c("grey", "red"),
  palette_col = NULL
)
```

## Arguments

- gt_object:

  An existing gt table object of class `gt_tbl`

- column:

  The column where a 'bullet chart' will replace the inline values.

- target:

  The column indicating the target values that will be represented by a
  vertical line

- width:

  Width of the plot in pixels

- palette:

  Color of the bar and target line, defaults to `c("grey", "red")`, can
  use named colors or hex colors. Must be of length two, and the first
  color will always be used as the bar color.

- palette_col:

  An additional column that contains specific colors for the bar colors
  themselves. Defaults to NULL which skips this argument.

## Value

An object of class `gt_tbl`.

## Examples

    set.seed(37)
    bullet_tab <- tibble::rownames_to_column(mtcars) %>%
     dplyr::select(rowname, cyl:drat, mpg) %>%
     dplyr::group_by(cyl) %>%
     dplyr::mutate(target_col = mean(mpg)) %>%
     dplyr::slice_sample(n = 3) %>%
     dplyr::ungroup() %>%
     gt::gt() %>%
     gt_plt_bullet(column = mpg, target = target_col, width = 45,
                   palette = c("lightblue", "black")) %>%
     gt_theme_538()

![](figures/gt_bullet.png)

## Function ID

3-7

## See also

Other Themes:
[`gt_plt_conf_int()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_conf_int.md),
[`gt_plt_dot()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_dot.md),
[`gt_theme_538()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_538.md),
[`gt_theme_dark()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_dark.md),
[`gt_theme_dot_matrix()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_dot_matrix.md),
[`gt_theme_espn()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_espn.md),
[`gt_theme_excel()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_excel.md),
[`gt_theme_guardian()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_guardian.md),
[`gt_theme_nytimes()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_nytimes.md),
[`gt_theme_pff()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_pff.md)
