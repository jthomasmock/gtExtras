# Changelog

## gtExtras 0.6.1

CRAN release: 2025-10-10

- Resolve issues with ggplot2 v4

## gtExtras 0.6.0

CRAN release: 2025-05-29

- Handle interquartile range of zero in
  [`gt_plt_summary()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_summary.md) -
  [\#104](https://github.com/jthomasmock/gtExtras/issues/104)  
- Experimentally handle multiple types of plots in
  [`gt_plt_dist()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_dist.md) -
  [\#102](https://github.com/jthomasmock/gtExtras/issues/102)  
- Resolve issues with
  [`gt_plt_summary()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_summary.md) -
  [\#148](https://github.com/jthomasmock/gtExtras/issues/148) and
  [146](https://github.com/jthomasmock/gtExtras/issues/146)
- Address test issues with svglite -
  [\#147](https://github.com/jthomasmock/gtExtras/issues/147)
- Remove deprecated fontawesome functions `gt_fa_repeats()`, and
  `gt_fa_column()` in favor of `gt` native functions.
- Address CRAN issues

## gtExtras 0.5.0

CRAN release: 2023-09-15

- Refactor NA handling in `gt_fa_` functions - thanks to
  [@areckenrode](https://github.com/areckenrode) via
  [\#78](https://github.com/jthomasmock/gtExtras/issues/78)
- Allow for all negative values in
  [`gt_plt_bar()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_bar.md) -
  thanks to [@paspvik](https://github.com/paspvik) via
  [\#75](https://github.com/jthomasmock/gtExtras/pull/75)
- Respect max and negative range of target and column values in
  [`gt_plt_bullet()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_bullet.md) -
  thanks to [@zdenall](https://github.com/zdenall) via
  [\#79](https://github.com/jthomasmock/gtExtras/issues/79)
- Improve
  [`gt_theme_538()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_538.md)
  to better align with FiveThirtyEight style, namely improved font
  choices (“Cairo”)
- Address NAs properly in
  [`gt_fa_rank_change()`](https://jthomasmock.github.io/gtExtras/reference/gt_fa_rank_change.md) -
  thanks to [@moodymudskipper](https://github.com/moodymudskipper) via
  [\#80](https://github.com/jthomasmock/gtExtras/issues/80)
- Refactor
  [`fmt_symbol_first()`](https://jthomasmock.github.io/gtExtras/reference/fmt_symbol_first.md)
  to work correctly with any font, not just monospace fonts.
- Add an experimental `gt_render_reprex()` thanks to
  [@mrcaseb](https://github.com/mrcaseb) suggestion on Twitter
- Allow for entire NA columns in
  [`gt_plt_bar()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_bar.md)
  and
  [`gt_plt_bar_pct()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_bar_pct.md) -
  [\#86](https://github.com/jthomasmock/gtExtras/issues/86)
- Accommodate small values in
  [`gt_plt_bullet()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_bullet.md) -
  [\#87](https://github.com/jthomasmock/gtExtras/issues/87)
- Address some small bugs
  [\#94](https://github.com/jthomasmock/gtExtras/issues/94) and
  [\#95](https://github.com/jthomasmock/gtExtras/issues/95)
- Add an expandable tag to
  [`gt_plt_summary()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_summary.md)
- Add a labelling feature to
  [`gt_plt_bar_pct()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_bar_pct.md) -
  thanks to [@andreweatherman](https://github.com/andreweatherman) and
  [PR](https://github.com/jthomasmock/gtExtras/pull/100)

## gtExtras 0.4.5

CRAN release: 2022-11-28

- Refactor many functions to account for upstream changes in `gt` v0.8.0
- Add a `palette_col` argument to
  [`gt_plt_bullet()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_bullet.md)
  to accept a named column of palette colors as present in the data.
  Fixed [\#72](https://github.com/jthomasmock/gtExtras/issues/72)
- Fix internals of
  [`gt_theme_pff()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_pff.md)
  to use `table.font.size` inside
  [`tab_options()`](https://gt.rstudio.com/reference/tab_options.html)
  rather than
  [`tab_style()`](https://gt.rstudio.com/reference/tab_style.html).
  Fixed [\#74](https://github.com/jthomasmock/gtExtras/issues/74)
- Fix a few instances of
  [`geom_line()`](https://ggplot2.tidyverse.org/reference/geom_path.html)
  and `geom_v/hline()` that were throwing warnings for `ggplot2` v3.4.0
- Refactor internals of `fmt_pad_num` to align with
  [@mrcaseb](https://github.com/mrcaseb) implementation
  <https://gist.github.com/mrcaseb/f0f85b48df7957c27c4205cafccbc5a2>
- Refactor many functions that use lines with size parameter, to avoid
  ggplot2 v.3.4.0 deprecation warnings (affects `gt_plt_bar`,
  `gt_pct_bar`, `gt_plt_dist`, `gt_plt_conf_int`,
  `gt_plt_percentile_dot`, `gt_plt_point`, `gt_plt_sparkline`,
  `gt_win_loss`)

## gtExtras 0.4.3

CRAN release: 2022-11-05

- Modify internals of `gt_fa_column()` to accept factors with levels not
  present in the data, ignoring unneeded levels. Thank you to
  [@mikedolanfliss](https://github.com/mikedolanfliss) for the
  suggestion.
- Add
  [`gt_merge_stack_color()`](https://jthomasmock.github.io/gtExtras/reference/gt_merge_stack_color.md)
  to create a merge/stack with background color - per
  [@mrcaseb](https://github.com/mrcaseb) and issue
  [\#71](https://github.com/jthomasmock/gtExtras/issues/71)
- Add
  [`gt_alert_icon()`](https://jthomasmock.github.io/gtExtras/reference/gt_alert_icon.md)
  to create a colored circle based on the range of values in the column.
- Fix a CRAN extra check

## gtExtras 0.4.2

CRAN release: 2022-09-03

- Rebuild docs with latest `roxygen2` to fix HTML documentation issues
  on CRAN
- Add
  [`gt_img_multi_rows()`](https://jthomasmock.github.io/gtExtras/reference/gt_img_multi_rows.md)
  courtesy of Ryan Timpe per
  [\#63](https://github.com/jthomasmock/gtExtras/pull/63)
- Add “alt” argument to `man_get_image_tag()` helper - solves CRAN HTML
  issues for missing alt-text
- Use alt-text on
  [`gt_plt_summary()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_summary.md)
  and
  [`gt_plt_winloss()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_winloss.md)

## gtExtras 0.4.1

CRAN release: 2022-07-13

- Add explicit height argument to `gt_fa_column()`
- Add
  [`get_row_index()`](https://jthomasmock.github.io/gtExtras/reference/get_row_index.md)
  to assist in applying styles to specific rows visually
- Refactor
  [`last_row_id()`](https://jthomasmock.github.io/gtExtras/reference/last_row_id.md)
  to use
  [`get_row_index()`](https://jthomasmock.github.io/gtExtras/reference/get_row_index.md)
  internally.
- Refactor
  [`gt_index()`](https://jthomasmock.github.io/gtExtras/reference/gt_index.md)
  to respect multiple groups - closes
  [Issue](https://github.com/jthomasmock/gtExtras/issues/58)
  [\#58](https://github.com/jthomasmock/gtExtras/issues/58) - thanks
  [@jmbarbone](https://github.com/jmbarbone) !
- Refactor
  [`tab_style_by_grp()`](https://jthomasmock.github.io/gtExtras/reference/tab_style_by_grp.md)
  to respect multiple groups
- Add NA handling to
  [`gt_plt_conf_int()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_conf_int.md) -
  closes [\#52](https://github.com/jthomasmock/gtExtras/issues/52)
- Update readme content to reflect latest documentation
- Remove `use_paletteer` argument from documentation (inline operation
  in function)
- Convert `&nbsp` to `&nbsp;` in
  [`fmt_symbol_first()`](https://jthomasmock.github.io/gtExtras/reference/fmt_symbol_first.md)
  and
  [`fmt_pad_num()`](https://jthomasmock.github.io/gtExtras/reference/fmt_pad_num.md),
  convert tests to match
- Update documentation for
  [`gt_img_circle()`](https://jthomasmock.github.io/gtExtras/reference/gt_img_circle.md)
- Add
  [`gt_theme_pff()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_pff.md)
  for Pro Football Focus style tables
- Add a `"pff"` palette option to
  [`gt_color_box()`](https://jthomasmock.github.io/gtExtras/reference/gt_color_box.md)
- Add new arguments to
  [`gt_merge_stack()`](https://jthomasmock.github.io/gtExtras/reference/gt_merge_stack.md)
  per [issue 53](https://github.com/jthomasmock/gtExtras/issues/53)
- Bulk update of examples sections and updated images
- Remove background color from label in
  [`gt_plt_conf_int()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_conf_int.md) -
  closes [\#54](https://github.com/jthomasmock/gtExtras/issues/54)
- Add
  [`gt_index()`](https://jthomasmock.github.io/gtExtras/reference/gt_index.md)
  to internals of
  [`gt_merge_stack()`](https://jthomasmock.github.io/gtExtras/reference/gt_merge_stack.md)
  to prevent incorrect arrangement when grouping data - closes
  [issue](https://github.com/jthomasmock/gtExtras/issues/55)
  [\#55](https://github.com/jthomasmock/gtExtras/issues/55)
- Corrected
  [`gt_plt_sparkline()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_sparkline.md)
  where in some cases inline plots weren’t respecting shared limits.

## gtExtras 0.4.0

CRAN release: 2022-06-09

- Prep for and submit initial CRAN release :fingers-crossed:

## gtExtras 0.3.9

- Renamed colors arg in
  [`gt_merge_stack()`](https://jthomasmock.github.io/gtExtras/reference/gt_merge_stack.md)
  to be ‘palette’
- Renamed colors arg in
  [`gt_plt_bullet()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_bullet.md)
  to be ‘palette’
- Renamed pal arg in
  [`gt_plt_sparkline()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_sparkline.md)
  to be ‘palette’

## gtExtras 0.3.8

- Renamed `colors` argument in `gt_win_loss()` to `palette`
- Added NA handling to all
  [`fontawesome::fa()`](https://rstudio.github.io/fontawesome/reference/fa.html)
  functions, ie
  [`gt_fa_rank_change()`](https://jthomasmock.github.io/gtExtras/reference/gt_fa_rank_change.md),
  `gt_fa_repeats()`, `gt_fa_column()`
- Add missing data handling to more plotting functions
- Refactor testing to use
  [`webshot2::webshot()`](https://rstudio.github.io/webshot2/reference/webshot.html)
  over `webshot::webshot()`
- Remove `gt_sparkline()` - functions separated into
  [`gt_plt_sparkline()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_sparkline.md)
  and
  [`gt_plt_dist()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_dist.md)

## gtExtras 0.3.7

- Added basic support in
  [`gt_plt_summary()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_summary.md)
  for dates/times.
- Updated tests for
  [`gt_plt_summary()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_summary.md)
  to include dates/times

## gtExtras 0.3.6

- Remove `use_paletteer` arg from
  [`gt_color_rows()`](https://jthomasmock.github.io/gtExtras/reference/gt_color_rows.md)
  in favor of a hopefully more user friendly detection of `::`
- Convert
  [`gt_color_rows()`](https://jthomasmock.github.io/gtExtras/reference/gt_color_rows.md)
  ‘type’ argument to ‘pal_type’ to prevent an edge-case where a column
  named type conflicts with the `paletteer` “type” argument per
  [issue](https://github.com/jthomasmock/gtExtras/issues/50)
  [\#50](https://github.com/jthomasmock/gtExtras/issues/50)

## gtExtras 0.3.4

- Add initial version of a
  [`gt_plt_summary()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_summary.md)
  function, as inspired by the [Observable/SummaryTable
  function](https://observablehq.com/@observablehq/summary-table).
- `gt_sparkline()` will be removed soon now that `bstfun`/`gtsummary`
  are no longer depending on it.
  [`gt_plt_dist()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_dist.md)
  and
  [`gt_plt_sparkline()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_sparkline.md)
  will be the new preferred and enhanced versions of `gt_sparkline()`.
- Add tests for
  [`gt_plt_summary()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_summary.md)

## gtExtras 0.3.3

- Add `webshot2` as a dependency now that it’s on CRAN!

## gtExtras 0.3.2

- Remove `scales::scales_label_si()` in favor of
  `scales::label_number(scale_cut = cut_scale_short())` as the previous
  function was deprecated. Thanks to
  [@mrcaseb](https://github.com/mrcaseb) for pointing out in [Issue
  48](https://github.com/jthomasmock/gtExtras/issues/48)

## gtExtras 0.3

- Add [Daniel Sjoberg](https://github.com/ddsjoberg) as a contributor in
  honor of their major assistance with preparation towards CRAN
- Move past 0.2 release into a “next stop CRAN”… hopefully
- Vendor additional unexported functions from
  [gt](https://gt.rstudio.com) with attribution

## gtExtras 0.2.7

- Bring in `webshot2` as a remote dependency suggest and minor changes
  to clean up some R checks, thanks to a PR from the great [Daniel
  Sjoberg](https://github.com/jthomasmock/gtExtras/pull/43).

- Correct an internal bug in
  [`gt_plt_dist()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_dist.md)
  which was failing for plotting integers.

## gtExtras 0.2.6

- Exchange `webshot` for `webshot2` to enhance capabilities. Note that
  `webshot2` is GitHub only, install via:
  `remotes::install_github("rstudio/webshot2")`. This solves
  [issue](https://github.com/jthomasmock/gtExtras/issues/42)
  [\#42](https://github.com/jthomasmock/gtExtras/issues/42).

## gtExtras 0.2.5

- Updated
  [`gt_theme_guardian()`](https://jthomasmock.github.io/gtExtras/reference/gt_theme_guardian.md)
  to work with zero-length tables per [Issue
  41](https://github.com/jthomasmock/gtExtras/issues/41)

## gtExtras 0.2.4

- Added a `NEWS.md` file to track changes to the package.

### Bug Fixes prior to 0.2.4

- Use `gt_index` to prevent incorrect ordering of rows with
  [`gt_plt_bar_pct()`](https://jthomasmock.github.io/gtExtras/reference/gt_plt_bar_pct.md)
  per StackOverflow report

- Remove `keep_column` argument for `gt_plt_bullet`, this functionality
  is able to be achieved with
  [`gt_duplicate_column()`](https://jthomasmock.github.io/gtExtras/reference/gt_duplicate_column.md)
  upstream. This also solves naming confusion as seen in [issue
  37](https://github.com/jthomasmock/gtExtras/issues/37)
