# Create circular border around an image

Create circular border around an image

## Usage

``` r
gt_img_circle(
  gt_object,
  column,
  height = 25,
  border_color = "black",
  border_weight = 1.5
)
```

## Arguments

- gt_object:

  An existing gt object

- column:

  The column to apply the transformation to

- height:

  A number indicating the height of the image in pixels.

- border_color:

  The color of the circular border, can either be a single value ie
  (`white` or `#FF0000`) or a vector where the length of the vector is
  equal to the number of rows.

- border_weight:

  A number indicating the weight of the border in pixels.

## Value

a gt object

## Examples

    library(gt)
    gt_img_tab <- dplyr::tibble(
      x = 1:4,
      names = c("Rich Iannone",  "Katie Masiello", "Tom Mock","Hadley Wickham"),
      img = c(
         "https://pbs.twimg.com/profile_images/961326215792533504/Ih6EsvtF_400x400.jpg",
         "https://pbs.twimg.com/profile_images/1471188460220260354/rHhoIXkZ_400x400.jpg",
         "https://pbs.twimg.com/profile_images/1467219661121064965/Lfondr9M_400x400.jpg",
         "https://pbs.twimg.com/profile_images/905186381995147264/7zKAG5sY_400x400.jpg"
      )
    ) %>%
      gt() %>%
      gt_img_circle(img)

## Figures

![](figures/gt_img_circle.png)

## Function ID

2-15

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
