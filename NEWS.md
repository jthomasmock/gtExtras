# gtExtras (development version)

# gtExtras 0.5.0

- Refactor NA handling in `gt_fa_` functions - thanks to @areckenrode via [#78](https://github.com/jthomasmock/gtExtras/issues/78)
- Allow for all negative values in `gt_plt_bar()` - thanks to @paspvik via [#75](https://github.com/jthomasmock/gtExtras/pull/75)
- Respect max and negative range of target and column values in `gt_plt_bullet()` - thanks to @zdenall via [#79](https://github.com/jthomasmock/gtExtras/issues/79)
- Improve `gt_theme_538()` to better align with FiveThirtyEight style, namely improved font choices ("Cairo")
- Address NAs properly in `gt_fa_rank_change()` - thanks to @moodymudskipper via [#80](https://github.com/jthomasmock/gtExtras/issues/80)
- Refactor `fmt_symbol_first()` to work correctly with any font, not just monospace fonts.
- Add an experimental `gt_render_reprex()` thanks to @mrcaseb suggestion on [Twitter](https://twitter.com/mrcaseb/status/1628122417523527697?s=20)
- Allow for entire NA columns in `gt_plt_bar()` and `gt_plt_bar_pct()` - [#86](https://github.com/jthomasmock/gtExtras/issues/86)
- Accommodate small values in `gt_plt_bullet()` - [#87](https://github.com/jthomasmock/gtExtras/issues/87)
- Address some small bugs #94 and #95
- Add an expandable tag to `gt_plt_summary()` - [Request](https://twitter.com/AdriMichelson/status/1697020677952557103?s=20)
- Add a labelling feature to `gt_plt_bar_pct()` - thanks to @andreweatherman and [PR](https://github.com/jthomasmock/gtExtras/pull/100)

# gtExtras 0.4.5
- Refactor many functions to account for upstream changes in `gt` v0.8.0
- Add a `palette_col` argument to `gt_plt_bullet()` to accept a named column of palette colors as present in the data. Fixed #72
- Fix internals of `gt_theme_pff()` to use `table.font.size` inside `tab_options()` rather than `tab_style()`. Fixed #74
- Fix a few instances of `geom_line()` and `geom_v/hline()` that were throwing warnings for `ggplot2` v3.4.0
- Refactor internals of `fmt_pad_num` to align with @mrcaseb implementation https://gist.github.com/mrcaseb/f0f85b48df7957c27c4205cafccbc5a2
- Refactor many functions that use lines with size parameter, to avoid ggplot2 v.3.4.0 deprecation warnings (affects `gt_plt_bar`, `gt_pct_bar`, `gt_plt_dist`, `gt_plt_conf_int`, `gt_plt_percentile_dot`, `gt_plt_point`, `gt_plt_sparkline`, `gt_win_loss`)

# gtExtras 0.4.3
- Modify internals of `gt_fa_column()` to accept factors with levels not present in the data, ignoring unneeded levels. Thank you to @mikedolanfliss for the suggestion.
- Add `gt_merge_stack_color()` to create a merge/stack with background color - per @mrcaseb and issue #71 
- Add `gt_alert_icon()` to create a colored circle based on the range of values in the column.
- Fix a CRAN extra check

# gtExtras 0.4.2

- Rebuild docs with latest `roxygen2` to fix HTML documentation issues on CRAN
- Add `gt_img_multi_rows()` courtesy of Ryan Timpe per [#63](https://github.com/jthomasmock/gtExtras/pull/63)
- Add "alt" argument to `man_get_image_tag()` helper - solves CRAN HTML issues for missing alt-text
- Use alt-text on `gt_plt_summary()` and `gt_plt_winloss()`

# gtExtras 0.4.1

- Add explicit height argument to `gt_fa_column()`
- Add `get_row_index()` to assist in applying styles to specific rows visually
- Refactor `last_row_id()` to use `get_row_index()` internally.
- Refactor `gt_index()` to respect multiple groups - closes [Issue #58](https://github.com/jthomasmock/gtExtras/issues/58) - thanks @jmbarbone !
- Refactor `tab_style_by_grp()` to respect multiple groups
- Add NA handling to `gt_plt_conf_int()` - closes [#52](https://github.com/jthomasmock/gtExtras/issues/52)
- Update readme content to reflect latest documentation
- Remove `use_paletteer` argument from documentation (inline operation in function)
- Convert `&nbsp` to `&nbsp;` in `fmt_symbol_first()` and `fmt_pad_num()`, convert tests to match
- Update documentation for `gt_img_circle()`
- Add `gt_theme_pff()` for Pro Football Focus style tables
- Add a `"pff"` palette option to `gt_color_box()`
- Add new arguments to `gt_merge_stack()`  per [issue 53](https://github.com/jthomasmock/gtExtras/issues/53)
- Bulk update of examples sections and updated images
- Remove background color from label in `gt_plt_conf_int()` - closes [#54](https://github.com/jthomasmock/gtExtras/issues/54)
- Add `gt_index()` to internals of `gt_merge_stack()` to prevent incorrect arrangement when grouping data - closes [issue #55](https://github.com/jthomasmock/gtExtras/issues/55)
- Corrected `gt_plt_sparkline()` where in some cases inline plots weren't respecting shared limits.

# gtExtras 0.4.0

- Prep for and submit initial CRAN release :fingers-crossed:

# gtExtras 0.3.9
- Renamed colors arg in `gt_merge_stack()` to be 'palette'
- Renamed colors arg in `gt_plt_bullet()` to be 'palette'
- Renamed pal arg in `gt_plt_sparkline()` to be 'palette'

# gtExtras 0.3.8
- Renamed `colors` argument in `gt_win_loss()` to `palette`
- Added NA handling to all `fontawesome::fa()` functions, ie `gt_fa_rank_change()`, `gt_fa_repeats()`, `gt_fa_column()`
- Add missing data handling to more plotting functions
- Refactor testing to use `webshot2::webshot()` over `webshot::webshot()`
- Remove `gt_sparkline()` - functions separated into `gt_plt_sparkline()` and `gt_plt_dist()`

# gtExtras 0.3.7
- Added basic support in `gt_plt_summary()` for dates/times. 
- Updated tests for `gt_plt_summary()` to include dates/times

# gtExtras 0.3.6

- Remove `use_paletteer` arg from `gt_color_rows()` in favor of a hopefully more user friendly detection of `::`
- Convert `gt_color_rows()` 'type' argument to 'pal_type' to prevent an edge-case where a column named type conflicts with the `paletteer` "type" argument per [issue #50](https://github.com/jthomasmock/gtExtras/issues/50)

# gtExtras 0.3.4

- Add initial version of a `gt_plt_summary()` function, as inspired by the [Observable/SummaryTable function](https://observablehq.com/@observablehq/summary-table).
- `gt_sparkline()` will be removed soon now that `bstfun`/`gtsummary` are no longer depending on it. `gt_plt_dist()` and `gt_plt_sparkline()` will be the new preferred and enhanced versions of `gt_sparkline()`.
- Add tests for `gt_plt_summary()`

# gtExtras 0.3.3

- Add `webshot2` as a dependency now that it's on CRAN!

# gtExtras 0.3.2

* Remove `scales::scales_label_si()` in favor of `scales::label_number(scale_cut = cut_scale_short())` as the previous function was deprecated. Thanks to [@mrcaseb](https://github.com/mrcaseb) for pointing out in [Issue 48](https://github.com/jthomasmock/gtExtras/issues/48)

# gtExtras 0.3

* Add [Daniel Sjoberg](https://github.com/ddsjoberg) as a contributor in honor of their major assistance with preparation towards CRAN
* Move past 0.2 release into a "next stop CRAN"... hopefully
* Vendor additional unexported functions from `{gt}` with attribution

# gtExtras 0.2.7

* Bring in `webshot2` as a remote dependency suggest and minor changes to clean up some R checks, thanks to a PR from the great [Daniel Sjoberg](https://github.com/jthomasmock/gtExtras/pull/43). 

* Correct an internal bug in `gt_plt_dist()` which was failing for plotting integers.

# gtExtras 0.2.6

* Exchange `webshot` for `webshot2` to enhance capabilities. Note that `webshot2` is GitHub only, install via: `remotes::install_github("rstudio/webshot2")`. This solves [issue #42](https://github.com/jthomasmock/gtExtras/issues/42).

# gtExtras 0.2.5

* Updated `gt_theme_guardian()` to work with zero-length tables per [Issue 41](https://github.com/jthomasmock/gtExtras/issues/41)

# gtExtras 0.2.4

* Added a `NEWS.md` file to track changes to the package.

## Bug Fixes prior to 0.2.4

* Use `gt_index` to prevent incorrect ordering of rows with `gt_plt_bar_pct()` per [StackOverflow report](https://stackoverflow.com/questions/71313688/gtextras-column-showing-in-wrong-order-in-gt-table-when-grouped?noredirect=1#comment126232993_71313688)

* Remove `keep_column` argument for `gt_plt_bullet`, this functionality is able to be achieved with `gt_duplicate_column()` upstream. This also solves naming confusion as seen in [issue 37](https://github.com/jthomasmock/gtExtras/issues/37)
