
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gtExtras

<!-- badges: start -->
<!-- badges: end -->

The goal of gtExtras is to provide some additional helper functions to
assist in creating beautiful tables with `{gt}`

## Installation

You can install the dev version of gtExtras from
[GitHub](https://github.com/jthomasmock/gtExtra) with:

``` r
remotes::install_github("jthomasmock/gtExtras")
```

### `fmt_symbol_first`

This function allows you to format your columns only on the first row,
where remaining rows in that column have whitespace added to the end to
maintain proper alignment.

``` r
library(gtExtras)
library(gt)

gtcars %>%
  head() %>%
  dplyr::select(mfr, year, bdy_style, mpg_h, hp) %>%
  dplyr::mutate(mpg_h = rnorm(n = dplyr::n(), mean = 22, sd = 1)) %>%
  gt::gt() %>%
  gt::opt_table_lines() %>%
  fmt_symbol_first(column = mfr, symbol = "&#x24;", last_row_n = 6) %>%
  fmt_symbol_first(column = year, suffix = "%") %>%
  fmt_symbol_first(column = mpg_h, symbol = "&#37;", decimals = 1) %>%
  fmt_symbol_first(hp, symbol = "&#176;", suffix = "F", symbol_first = TRUE)
```

<p align="center">
<img src="man/figures/gt_fmt_first.png" width="700px">
</p>

### `pad_fn`

You can use `pad_fn()` with `gt::fmt()` to pad specific columns that
contain numeric values. You will use it when you want to “decimal align”
the values in the column, but not require printing extra trailing
zeroes.

``` r
data.frame(x = c(1.2345, 12.345, 123.45, 1234.5, 12345)) %>%
  gt() %>%
  fmt(fns = function(x){pad_fn(x, nsmall = 4)}) %>%
  tab_style(
    # MUST USE A MONO-SPACED FONT
    style = cell_text(font = google_font("Fira Mono")),
    locations = cells_body(columns = x)
    )
```

<p align="center">
<img src="man/figures/gt_pad_fn.png" width="200px">
</p>

### Themes

The package includes two different themes, the `gt_theme_538()` styled
after FiveThirtyEight style tables, and `gt_theme_espn()` styled after
ESPN style tables.

``` r
head(mtcars) %>%
  gt() %>% 
  gt_theme_538()
```

<p align="center">
<img src="man/figures/gt_538.png" width="700px">
</p>

``` r
head(mtcars) %>%
  gt() %>% 
  gt_theme_538()
```

<p align="center">
<img src="man/figures/gt_espn.png" width="700px">
</p>

``` r
head(mtcars) %>% 
  gt() %>% 
  gt_theme_nytimes() %>% 
  tab_header(title = "Table styled like the NY Times")
```

<p align="center">
<img src="man/figures/gt_nyt.png" width="700px">
</p>

### Hulk data_color

This is an opinionated diverging color palette. It diverges from low to
high as purple to green. It is a good alternative to a red-green
diverging palette as a color-blind friendly palette. The specific colors
come from
[colorbrewer2](https://colorbrewer2.org/#type=diverging&scheme=PRGn&n=7).

Basic usage below, where a specific column is passed.

``` r
# basic use
head(mtcars) %>%
  gt::gt() %>%
  gt_hulk_col_numeric(mpg)
```

<p align="center">
<img src="man/figures/hulk_basic.png" width="700px">
</p>

Trim provides a tighter range of purple/green so the colors are less
pronounced.

``` r
head(mtcars) %>%
  gt::gt() %>%
  # trim gives smaller range of colors
  # so the green and purples are not as dark
  gt_hulk_col_numeric(mpg:disp, trim = TRUE) 
```

<p align="center">
<img src="man/figures/hulk_trim.png" width="700px">
</p>

<!-- width="1200px" -->

Reverse makes higher values represented by purple and lower by green.
The default is to have high = green, low = purple.

``` r
# option to reverse the color palette
# so that purple is higher
head(mtcars) %>%
  gt::gt() %>%
  # reverse = green for low, purple for high
  gt_hulk_col_numeric(mpg:disp, reverse = FALSE) 
```

<p align="center">
<img src="man/figures/hulk_reverse.png" width="700px">
</p>

### `gt_color_rows()`

The `gt_color_rows()` function is a thin boilerplate wrapper around
`gt::data_color()`. It’s simpler to use but still provides rich color
choices thanks to the inclusion of `paletteer::paletteer_d()`. This can
provide 100s of discrete (ie categorical) or continuous color palettes.

``` r
# basic use
mtcars %>%
  head() %>%
  gt() %>%
  gt_color_rows(mpg:disp)
```

<p align="center">
<img src="man/figures/basic-pal.png" width="700px">
</p>

You can change the specific palette with
`palette = "package_name::palette_name"`

``` r
# recognizes all of the dynamic palettes from paletteer
mtcars %>%
  head() %>%
  gt() %>%
  gt_color_rows(mpg:disp, palette = "ggsci::blue_material")
```

<p align="center">
<img src="man/figures/blue-pal.png" width="700px">
</p>

You can also use custom-defined palettes if you wish with
`use_paletteer = FALSE`.

``` r
mtcars %>%
  head() %>%
  gt() %>%
  gt_color_rows(
    mpg:disp, palette = c("white", "green"),
    # could also use palette = c("#ffffff", "##00FF00")
    use_paletteer = FALSE)
```

<p align="center">
<img src="man/figures/custom-pal.png" width="700px">
</p>

Lastly, you can also provide categorical or discrete data to be colored.

``` r
# provide type = "discrete"
mtcars %>%
  head() %>%
  gt() %>%
  gt_color_rows(
    cyl, type = "discrete",
    palette = "ggthemes::colorblind", 
    # note that you can manually define range like c(4, 6, 8)
    domain = range(mtcars$cyl)
   )
```

<p align="center">
<img src="man/figures/discrete-pal.png" width="700px">
</p>

### `gt_kable_sparkline()`

``` r
mtcars %>%
  dplyr::group_by(cyl) %>%
  # must end up with list of data for each row in the input dataframe
  dplyr::summarize(mpg_data = list(mpg), .groups = "drop") %>%
  gt() %>%
  gt_kable_sparkline(mpg_data, height = 45)
```

<p align="center">
<img src="man/figures/kable-sparkline.png" width="200px">
</p>

### `gt_bar_plot()`

The `gt_bar_plot` function takes an existing `gt_tbl` object and adds
horizontal barplots via native HTML. This is a wrapper around raw HTML
strings, `gt::text_transform()` and `gt::cols_align()`. Note that values
default to being normalized to the percent of the maximum observed value
in the specified column. You can turn this off if the values already
represent a percentage value representing 0-100.

``` r
mtcars %>%
  head() %>%
  dplyr::select(cyl, mpg) %>%
  dplyr::mutate(mpg_pct_max = round(mpg/max(mpg) * 100, digits = 2),
                mpg_scaled = mpg/max(mpg) * 100) %>%
  dplyr::mutate(mpg_unscaled = mpg) %>%
  gt() %>%
  gt_bar_plot(column = mpg_scaled, scaled = TRUE) %>%
  gt_bar_plot(column = mpg_unscaled, scaled = FALSE, fill = "blue", background = "lightblue") %>%
  cols_align("center", contains("scale")) %>%
  cols_width(4 ~ px(125),
             5 ~ px(125))
```

<p align="center">
<img src="man/figures/gt_bar_plot.png" width="700px">
</p>
