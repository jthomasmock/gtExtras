# Package index

## Themes

Full blown [gt](https://gt.rstudio.com) themes that affect most if not
all visual components of the table. Similar in spirit to
[ggplot2](https://ggplot2.tidyverse.org) themes like
[`ggplot2::theme_minimal()`](https://ggplot2.tidyverse.org/reference/ggtheme.html)
or [ggthemes](https://jrnold.github.io/ggthemes/) like
`ggthemes::theme_fivethirtyeight()`.

- [`gt_theme_538()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_538.md)
  : Apply FiveThirtyEight theme to a gt table

- [`gt_theme_espn()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_espn.md)
  : Apply ESPN theme to a gt table

- [`gt_theme_nytimes()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_nytimes.md)
  :

  Apply NY Times theme to a `gt` table

- [`gt_theme_guardian()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_guardian.md)
  :

  Apply Guardian theme to a `gt` table

- [`gt_theme_dot_matrix()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_dot_matrix.md)
  : Apply dot matrix theme to a gt table

- [`gt_theme_dark()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_dark.md)
  :

  Apply dark theme to a `gt` table

- [`gt_theme_excel()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_excel.md)
  : Apply Excel-style theme to an existing gt table

- [`gt_theme_pff()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_pff.md)
  : Apply a table theme like PFF

## Plotting

Add plots to specific rows of an existing table

- [`gt_plt_bar()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_bar.md)
  :

  Add bar plots into rows of a `gt` table

- [`gt_plt_bar_pct()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_bar_pct.md)
  :

  Add HTML-based bar plots into rows of a `gt` table

- [`gt_plt_bar_stack()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_bar_stack.md)
  : Add a percent stacked barchart in place of existing data.

- [`gt_plt_bullet()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_bullet.md)
  : Create an inline 'bullet chart' in a gt table

- [`gt_plt_conf_int()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_conf_int.md)
  : Plot a confidence interval around a point

- [`gt_plt_dist()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_dist.md)
  :

  Add distribution plots into rows of a `gt` table

- [`gt_plt_dot()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_dot.md)
  : Add a color dot and thin bar chart to a table

- [`gt_plt_dumbbell()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_dumbbell.md)
  : Add a dumbbell plot in place of two columns

- [`gt_plt_percentile()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_percentile.md)
  : Create a dot plot for percentiles

- [`gt_plt_point()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_point.md)
  : Create a point plot in place of each value.

- [`gt_plt_sparkline()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_sparkline.md)
  :

  Add sparklines into rows of a `gt` table

- [`gt_plt_summary()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_summary.md)
  : Create a summary table from a dataframe

- [`gt_plt_winloss()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_winloss.md)
  :

  Add win loss point plot into rows of a `gt` table

## Images and icons

Add fontawesome icons or web images to a table

- [`fa_icon_repeat()`](https://jthomasmock.github.io/gtExtras/reference/fa_icon_repeat.md)
  :

  Repeat [fontawesome](https://github.com/rstudio/fontawesome) icons and
  convert to HTML

- [`gt_fa_rating()`](https://jthomasmock.github.io/gtExtras/reference/gt_fa_rating.md)
  : Add rating "stars" to a gt column

- [`gt_fa_rank_change()`](https://jthomasmock.github.io/gtExtras/reference/gt_fa_rank_change.md)
  : Add rank change indicators to a gt table

- [`add_text_img()`](https://jthomasmock.github.io/gtExtras/reference/add_text_img.md)
  : Add text and an image to the left or right of it

- [`img_header()`](https://jthomasmock.github.io/gtExtras/reference/img_header.md)
  : Add images as the column label for a table

- [`gt_img_rows()`](https://jthomasmock.github.io/gtExtras/reference/gt_img_rows.md)
  :

  Add local or web images into rows of a `gt` table

- [`gt_img_multi_rows()`](https://jthomasmock.github.io/gtExtras/reference/gt_img_multi_rows.md)
  :

  Add multiple local or web images into rows of a `gt` table

- [`gt_img_circle()`](https://jthomasmock.github.io/gtExtras/reference/gt_img_circle.md)
  : Create circular border around an image

- [`gt_img_border()`](https://jthomasmock.github.io/gtExtras/reference/gt_img_border.md)
  : Create an identifier line border at the bottom of an image

## Colors

Add color to the entire table or to specific locations. Includes
wrappers around the [scales](https://scales.r-lib.org) and
[paletteer](https://emilhvitfeldt.github.io/paletteer/) packages that
provide easier or more succinct applications of palettes and colors
inside [gt](https://gt.rstudio.com).

- [`gt_hulk_col_numeric()`](https://jthomasmock.github.io/gtExtras/reference/gt_hulk_col_numeric.md)
  : Apply 'hulk' palette to specific columns in a gt table.
- [`gt_color_rows()`](https://jthomasmock.github.io/gtExtras/reference/gt_color_rows.md)
  : Add scaled colors according to numeric values or categories/factors
- [`gt_color_box()`](https://jthomasmock.github.io/gtExtras/reference/gt_color_box.md)
  : Add a small color box relative to the cell value.
- [`gt_alert_icon()`](https://jthomasmock.github.io/gtExtras/reference/gt_alert_icon.md)
  : Insert an alert icon to a specific column

## HTML Helpers

Various HTML helpers to avoid repeated boilerplate

- [`gt_label_details()`](https://jthomasmock.github.io/gtExtras/reference/gt_label_details.md)
  : Add a simple table with column names and matching labels
- [`with_tooltip()`](https://jthomasmock.github.io/gtExtras/reference/with_tooltip.md)
  : A helper to add basic tooltip inside a gt table
- [`gt_hyperlink()`](https://jthomasmock.github.io/gtExtras/reference/gt_hyperlink.md)
  : Add a basic hyperlink in a gt table

## Utilities

Helper functions and utilities with features not *yet* built into
[gt](https://gt.rstudio.com).

- [`fmt_symbol_first()`](https://jthomasmock.github.io/gtExtras/reference/fmt_symbol_first.md)
  : Aligning first-row text only

- [`fmt_pad_num()`](https://jthomasmock.github.io/gtExtras/reference/fmt_pad_num.md)
  : Format numeric columns to align at decimal point without trailing
  zeroes

- [`fmt_pct_extra()`](https://jthomasmock.github.io/gtExtras/reference/fmt_pct_extra.md)
  : Convert to percent and show less than 1% as \<1% in grey

- [`pad_fn()`](https://jthomasmock.github.io/gtExtras/reference/pad_fn.md)
  : Pad a vector of numbers to align on the decimal point.

- [`gt_merge_stack()`](https://jthomasmock.github.io/gtExtras/reference/gt_merge_stack.md)
  :

  Merge and stack text from two columns in `gt`

- [`gt_merge_stack_color()`](https://jthomasmock.github.io/gtExtras/reference/gt_merge_stack_color.md)
  :

  Merge and stack text with background coloring from two columns in `gt`

- [`gt_highlight_rows()`](https://jthomasmock.github.io/gtExtras/reference/gt_highlight_rows.md)
  : Add color highlighting to a specific row

- [`gt_highlight_cols()`](https://jthomasmock.github.io/gtExtras/reference/gt_highlight_cols.md)
  : Add color highlighting to a specific column(s)

- [`gt_add_divider()`](https://jthomasmock.github.io/gtExtras/reference/gt_add_divider.md)
  :

  Add a dividing border to an existing `gt` table.

- [`tab_style_by_grp()`](https://jthomasmock.github.io/gtExtras/reference/tab_style_by_grp.md)
  : Add table styling to specific rows by group

- [`gt_double_table()`](https://jthomasmock.github.io/gtExtras/reference/gt_double_table.md)
  : Take data, a gt-generating function, and create a list of two tables

- [`gt_two_column_layout()`](https://jthomasmock.github.io/gtExtras/reference/gt_two_column_layout.md)
  : Create a two-column layout from a list of two gt tables

- [`gtsave_extra()`](https://jthomasmock.github.io/gtExtras/reference/gtsave_extra.md)
  : Use webshot2 to save a gt table as a PNG

- [`gt_duplicate_column()`](https://jthomasmock.github.io/gtExtras/reference/gt_duplicate_column.md)
  : Duplicate an existing column in a gt table

- [`gt_index()`](https://jthomasmock.github.io/gtExtras/reference/gt_index.md)
  : Return the underlying data, arranged by the internal index

- [`get_row_index()`](https://jthomasmock.github.io/gtExtras/reference/get_row_index.md)
  : Get underlying row index for gt tables

- [`generate_df()`](https://jthomasmock.github.io/gtExtras/reference/generate_df.md)
  : Generate pseudorandom dataframes with specific parameters

- [`gt_reprex_image()`](https://jthomasmock.github.io/gtExtras/reference/gt_reprex_image.md)
  : Render 'gt' Table to Temporary png File
