# Add local or web images into rows of a `gt` table

The `gt_img_rows` function takes an existing `gt_tbl` object and
converts filenames or urls to images into inline images. This is a
wrapper around
[`gt::text_transform()`](https://gt.rstudio.com/reference/text_transform.html) +
[`gt::web_image()`](https://gt.rstudio.com/reference/web_image.html)/[`gt::local_image()`](https://gt.rstudio.com/reference/local_image.html)
with the necessary boilerplate already applied.

## Usage

``` r
gt_img_rows(gt_object, columns, img_source = "web", height = 30)
```

## Arguments

- gt_object:

  An existing gt table object of class `gt_tbl`

- columns:

  The columns wherein changes to cell data colors should occur.

- img_source:

  A string, specifying either "local" or "web" as the source of the
  images.

- height:

  *Height of image*

  `scalar<numeric|integer>` // *default:* `30`

  The absolute height of the image in the table cell (in `"px"` units).
  By default, this is set to `"30px"`.

## Value

An object of class `gt_tbl`.

## Examples

    library(gt)
    teams <- "https://github.com/nflverse/nflfastR-data/raw/master/teams_colors_logos.rds"
    team_df <- readRDS(url(teams))

     logo_table <- team_df %>%
       dplyr::select(team_wordmark, team_abbr, logo = team_logo_espn, team_name:team_conf) %>%
       head() %>%
       gt() %>%
       gt_img_rows(columns = team_wordmark, height = 25) %>%
       gt_img_rows(columns = logo, img_source = "web", height = 30) %>%
       tab_options(data_row.padding = px(1))

## Figures

![](figures/img-rows.png)

## Function ID

2-7

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
[`gt_index()`](https://jthomasmock.github.io/gtExtras/reference/gt_index.md),
[`gt_merge_stack()`](https://jthomasmock.github.io/gtExtras/reference/gt_merge_stack.md),
[`gt_merge_stack_color()`](https://jthomasmock.github.io/gtExtras/reference/gt_merge_stack_color.md),
[`gt_two_column_layout()`](https://jthomasmock.github.io/gtExtras/reference/gt_two_column_layout.md),
[`gtsave_extra()`](https://jthomasmock.github.io/gtExtras/reference/gtsave_extra.md),
[`img_header()`](https://jthomasmock.github.io/gtExtras/reference/img_header.md),
[`pad_fn()`](https://jthomasmock.github.io/gtExtras/reference/pad_fn.md),
[`tab_style_by_grp()`](https://jthomasmock.github.io/gtExtras/reference/tab_style_by_grp.md)
