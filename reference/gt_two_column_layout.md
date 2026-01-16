# Create a two-column layout from a list of two gt tables

This function takes a [`list()`](https://rdrr.io/r/base/list.html) of
two gt-tables and returns them as a two-column layout. The expectation
is that the user either supplies two tables like `list(table1, table2)`,
or passes the output of
[`gt_double_table()`](https://jthomasmock.github.io/gtExtras/reference/gt_double_table.md)
into this function. The user should indicate whether they want to return
the HTML to R's viewer with `output = "viewer"` to "view" the final
output, or to save to disk as a `.png` via `output = "save".` Note that
this is a relatively complex wrapper around
[`htmltools::div()`](https://rstudio.github.io/htmltools/reference/builder.html) +
[`webshot2::webshot()`](https://rstudio.github.io/webshot2/reference/webshot.html).
Additional arguments can be passed to
[`webshot2::webshot()`](https://rstudio.github.io/webshot2/reference/webshot.html)
if the automatic output is not satisfactory. In most situations,
modifying the `vwidth` argument is sufficient to get the desired output,
but all arguments to
[`webshot2::webshot()`](https://rstudio.github.io/webshot2/reference/webshot.html)
are available by their original name via the passed `...`.

## Usage

``` r
gt_two_column_layout(
  tables = NULL,
  output = "viewer",
  filename = NULL,
  path = NULL,
  vwidth = 992,
  vheight = 600,
  ...,
  zoom = 2,
  expand = 5,
  tab_header_from = NULL
)
```

## Arguments

- tables:

  A [`list()`](https://rdrr.io/r/base/list.html) of two tables,
  typically supplied by
  [`gt_double_table()`](https://jthomasmock.github.io/gtExtras/reference/gt_double_table.md)

- output:

  A character string indicating the desired output, either `"save"` to
  save it to disk via `webshot`, `"viewer"` to return it to the RStudio
  Viewer, or `"html"` to return the raw HTML.

- filename:

  The filename of the table, must contain `.png` and only used if
  `output = "save"`

- path:

  An optional path of where to save the printed `.png`, used in
  conjunction with `filename`.

- vwidth:

  Viewport width. This is the width of the browser "window" when passed
  to
  [`webshot2::webshot()`](https://rstudio.github.io/webshot2/reference/webshot.html).

- vheight:

  Viewport height This is the height of the browser "window" when passed
  to
  [`webshot2::webshot()`](https://rstudio.github.io/webshot2/reference/webshot.html).

- ...:

  Additional arguments passed to
  [`webshot2::webshot()`](https://rstudio.github.io/webshot2/reference/webshot.html),
  only to be used if `output = "save"`, saving the two-column layout
  tables to disk as a `.png`.

- zoom:

  Argument to
  [`webshot2::webshot()`](https://rstudio.github.io/webshot2/reference/webshot.html).
  A number specifying the zoom factor. A zoom factor of 2 will result in
  twice as many pixels vertically and horizontally. Note that using 2 is
  not exactly the same as taking a screenshot on a HiDPI (Retina)
  device: it is like increasing the zoom to 200 doubling the height and
  width of the browser window. This differs from using a HiDPI device
  because some web pages load different, higher-resolution images when
  they know they will be displayed on a HiDPI device (but using zoom
  will not report that there is a HiDPI device).

- expand:

  Argument to
  [`webshot2::webshot()`](https://rstudio.github.io/webshot2/reference/webshot.html).
  A numeric vector specifying how many pixels to expand the clipping
  rectangle by. If one number, the rectangle will be expanded by that
  many pixels on all sides. If four numbers, they specify the top,
  right, bottom, and left, in that order. When taking screenshots of
  multiple URLs, this parameter can also be a list with same length as
  url with each element of the list containing a single number or four
  numbers to use for the corresponding URL.

- tab_header_from:

  If `NULL` (the default) renders tab headers of each table
  individually. If one of "table1" or "table2", the function extracts
  tab header information (including styling) from table 1 or table 2
  respectively and renders it as high level header for the combined view
  (individual headers will be removed).

## Value

Saves a `.png` to disk if `output = "save"`, returns HTML to the viewer
via
[`htmltools::browsable()`](https://rstudio.github.io/htmltools/reference/browsable.html)
when `output = "viewer"`, or returns raw HTML if `output = "html"`.

## Examples

Add row numbers and drop some columns

    library(gt)
    my_cars <- mtcars %>%
      dplyr::mutate(row_n = dplyr::row_number(), .before = mpg) %>%
      dplyr::select(row_n, mpg:drat)

Create two tables, just split half/half

    tab1 <- my_cars %>%
      dplyr::slice(1:16) %>%
      gt() %>%
      gtExtras::gt_color_rows(columns = row_n, domain = 1:32)

    tab2 <- my_cars %>%
      dplyr::slice(17:32) %>%
      gt() %>%
      gtExtras::gt_color_rows(columns = row_n, domain = 1:32)

Put the tables in a list and then pass list to the
`gt_two_column_layout` function.

    listed_tables <- list(tab1, tab2)

    gt_two_column_layout(listed_tables)

A better option - write a small function, use
[`gt_double_table()`](https://jthomasmock.github.io/gtExtras/reference/gt_double_table.md)
to generate the tables and then pass it to
[`gt_double_table()`](https://jthomasmock.github.io/gtExtras/reference/gt_double_table.md)

    my_gt_fn <- function(x) {
      gt(x) %>%
        gtExtras::gt_color_rows(columns = row_n, domain = 1:32)
    }

    my_tables <- gt_double_table(my_cars, my_gt_fn, nrows = nrow(my_cars) / 2)

This will return it to the viewer

    gt_two_column_layout(my_tables)

If you wanted to save it out instead, could use the code below

    gt_two_column_layout(my_tables, output = "save",
                         filename = "basic-two-col.png",
                          vwidth = 550, vheight = 620)

## Figures

![](figures/basic-two-col.png)

## See also

Other Utilities:
[`add_text_img()`](https://jthomasmock.github.io/gtExtras/reference/add_text_img.md),
[`fa_icon_repeat()`](https://jthomasmock.github.io/gtExtras/reference/fa_icon_repeat.md),
[`fmt_pad_num()`](https://jthomasmock.github.io/gtExtras/reference/fmt_pad_num.md),
[`fmt_pct_extra()`](https://jthomasmock.github.io/gtExtras/reference/fmt_pct_extra.md),
[`fmt_symbol_first()`](https://jthomasmock.github.io/gtExtras/reference/fmt_symbol_first.md),
[`generate_df()`](https://jthomasmock.github.io/gtExtras/reference/generate_df.md),
[`gt_add_divider()`](https://jthomasmock.github.io/gtExtras/reference/gt_add_divider.md),
[`gt_badge()`](https://jthomasmock.github.io/gtExtras/reference/gt_badge.md),
[`gt_double_table()`](https://jthomasmock.github.io/gtExtras/reference/gt_double_table.md),
[`gt_duplicate_column()`](https://jthomasmock.github.io/gtExtras/reference/gt_duplicate_column.md),
[`gt_fa_rank_change()`](https://jthomasmock.github.io/gtExtras/reference/gt_fa_rank_change.md),
[`gt_fa_rating()`](https://jthomasmock.github.io/gtExtras/reference/gt_fa_rating.md),
[`gt_highlight_cols()`](https://jthomasmock.github.io/gtExtras/reference/gt_highlight_cols.md),
[`gt_highlight_rows()`](https://jthomasmock.github.io/gtExtras/reference/gt_highlight_rows.md),
[`gt_img_border()`](https://jthomasmock.github.io/gtExtras/reference/gt_img_border.md),
[`gt_img_circle()`](https://jthomasmock.github.io/gtExtras/reference/gt_img_circle.md),
[`gt_img_multi_rows()`](https://jthomasmock.github.io/gtExtras/reference/gt_img_multi_rows.md),
[`gt_img_rows()`](https://jthomasmock.github.io/gtExtras/reference/gt_img_rows.md),
[`gt_index()`](https://jthomasmock.github.io/gtExtras/reference/gt_index.md),
[`gt_merge_stack()`](https://jthomasmock.github.io/gtExtras/reference/gt_merge_stack.md),
[`gt_merge_stack_color()`](https://jthomasmock.github.io/gtExtras/reference/gt_merge_stack_color.md),
[`gtsave_extra()`](https://jthomasmock.github.io/gtExtras/reference/gtsave_extra.md),
[`img_header()`](https://jthomasmock.github.io/gtExtras/reference/img_header.md),
[`pad_fn()`](https://jthomasmock.github.io/gtExtras/reference/pad_fn.md),
[`tab_style_by_grp()`](https://jthomasmock.github.io/gtExtras/reference/tab_style_by_grp.md)
