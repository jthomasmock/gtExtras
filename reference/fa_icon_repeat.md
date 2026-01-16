# Repeat `{fontawesome}` icons and convert to HTML

The `fa_icon_repeat` function takes an
[fontawesome](https://fontawesome.com/) icon and repeats it `n` times.

## Usage

``` r
fa_icon_repeat(
  name = "star",
  repeats = 1,
  fill = NULL,
  fill_opacity = NULL,
  stroke = NULL,
  stroke_width = NULL,
  stroke_opacity = NULL,
  height = NULL,
  width = NULL,
  margin_left = NULL,
  margin_right = NULL,
  position = NULL,
  title = NULL,
  a11y = c("deco", "sem", "none")
)
```

## Arguments

- name:

  The name of the Font Awesome icon. This could be as a short name
  (e.g., "npm", "drum", etc.), or, a full name (e.g., "fab fa-npm", "fas
  fa-drum", etc.). The names should correspond to current Version 5 Font
  Awesome names. A list of short and full names can be accessed through
  the fa_metadata() function with fa_metadata()\$icon_names and
  fa_metadata()\$icon_names_full. If supplying a Version 4 icon name, it
  will be internally translated to the Version 5 icon name and a Version
  5 icon will be returned. A data frame containing the short names that
  changed from version 4 (v4_name) to version 5 (v5_name) can be
  obtained by using fa_metadata()\$v4_v5_name_tbl.

- repeats:

  An integer indicating the number of repeats for that specific
  icon/row.

- fill, fill_opacity:

  The fill color of the icon can be set with fill. If not provided then
  the default value of "currentColor" is applied so that the SVG fill
  matches the color of the parent HTML element's color attribute. The
  opacity level of the SVG fill can be controlled with a decimal value
  between 0 and 1.

- stroke, stroke_width, stroke_opacity:

  The stroke options allow for setting the color, width, and opacity of
  the SVG outline stroke. By default, the stroke width is very small at
  "1px" so a size adjustment with "stroke_width" can be useful. The
  "stroke_opacity" value can be any decimal values between 0 and 1
  (bounds included).

- height, width:

  The height and width style attributes of the rendered SVG. If nothing
  is provided for height then a default value of "1em" will be applied.
  If a width isn't given, then it will be calculated in units of "em" on
  the basis of the icon's SVG "viewBox" dimensions.

- margin_left, margin_right:

  The length value for the margin that's either left or right of the
  icon. By default, "auto" is used for both properties. If space is
  needed on either side then a length of "0.2em" is recommended as a
  starting point.

- position:

  The value for the position style attribute. By default, "relative" is
  used here.

- title:

  An option for populating the SVG 'title' attribute, which provides
  on-hover text for the icon. By default, no title text is given to the
  icon. If a11y == "semantic" then title text will be automatically
  given to the rendered icon, however, providing text here will override
  that.

- a11y:

  Cases that distinguish the role of the icon and inform which
  accessibility attributes to be used. Icons can either be "deco"
  (decorative, the default case) or "sem" (semantic). Using "none" will
  result in no accessibility features for the icon.

## Value

A character string of class HTML, representing repeated SVG logos

## Function ID

2-4

## See also

Other Utilities:
[`add_text_img()`](https://jthomasmock.github.io/gtExtras/reference/add_text_img.md),
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
[`gt_two_column_layout()`](https://jthomasmock.github.io/gtExtras/reference/gt_two_column_layout.md),
[`gtsave_extra()`](https://jthomasmock.github.io/gtExtras/reference/gtsave_extra.md),
[`img_header()`](https://jthomasmock.github.io/gtExtras/reference/img_header.md),
[`pad_fn()`](https://jthomasmock.github.io/gtExtras/reference/pad_fn.md),
[`tab_style_by_grp()`](https://jthomasmock.github.io/gtExtras/reference/tab_style_by_grp.md)
