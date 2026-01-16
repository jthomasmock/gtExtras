# Take data, a gt-generating function, and create a list of two tables

The `gt_double_table` function takes some data and a user-supplied
function to generate two tables in a list. To convert existing
[`gt::gt()`](https://gt.rstudio.com/reference/gt.html) code to a
function, you can follow the approximate pattern:
`gt_fn <- function(x){gt(x) %>% more_gt_code}`

Your function should only have a **single argument**, which is the
**data** to be supplied directly into the
[`gt::gt()`](https://gt.rstudio.com/reference/gt.html) function. This
function is intended to be passed directly into
[`gt_two_column_layout()`](https://jthomasmock.github.io/gtExtras/reference/gt_two_column_layout.md),
for printing it to the viewer, saving it to a `.png`, or returning the
raw HTML.

## Usage

``` r
gt_double_table(data, gt_fn, nrows = NULL, noisy = TRUE)
```

## Arguments

- data:

  A `tibble` or dataframe to be passed into the supplied `gt_fn`

- gt_fn:

  A user-defined function that has one argument, this argument should
  pass data to the
  [`gt::gt()`](https://gt.rstudio.com/reference/gt.html) function, which
  will be supplied by the `data` argument. It should follow the pattern
  of `gt_function <- function(x) gt(x) %>% more_gt_code...`.

- nrows:

  The number of rows to split at, defaults to `NULL` and will attempt to
  split approximately 50/50 in the left vs right table.

- noisy:

  A logical indicating whether to return the warning about not supplying
  `nrows` argument.

## Value

a [`list()`](https://rdrr.io/r/base/list.html) of two `gt` tables

## Examples

    library(gt)
    # define your own function
    my_gt_function <- function(x) {
      gt(x) %>%
        gtExtras::gt_color_rows(columns = mpg, domain = range(mtcars$mpg)) %>%
        tab_options(data_row.padding = px(3))
    }

    two_tables <- gt_double_table(mtcars, my_gt_function, nrows = 16)

    # list of two gt_tbl objects
    # ready to pass to gtExtras::gt_two_column_layout()
    str(two_tables, max.level = 1)

    #> List of 2
    #> $ :List of 16
    #> ..- attr(*, "class")= chr [1:2] "gt_tbl" "list"
    #> $ :List of 16
    #> ..- attr(*, "class")= chr [1:2] "gt_tbl" "list"

## Function ID

2-13

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
[`gt_two_column_layout()`](https://jthomasmock.github.io/gtExtras/reference/gt_two_column_layout.md),
[`gtsave_extra()`](https://jthomasmock.github.io/gtExtras/reference/gtsave_extra.md),
[`img_header()`](https://jthomasmock.github.io/gtExtras/reference/img_header.md),
[`pad_fn()`](https://jthomasmock.github.io/gtExtras/reference/pad_fn.md),
[`tab_style_by_grp()`](https://jthomasmock.github.io/gtExtras/reference/tab_style_by_grp.md)
