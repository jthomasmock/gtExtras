# gtExtras 0.4.0

- Prep for and submit initial CRAN release :fingers-crossed:.

# gtExtras 0.3.9
- Renamed colors arg in `merge_and_stack()` to be 'palette'
- Renamed colors arg in `gt_plt_bullet()` to be 'palette'
- Renamed pal arg in `gt_plt_sparkline()` to be 'palette'

# gtExtras 0.3.8
- Renamed `colors` argument in `gt_win_loss() to `palette`
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
- `gt_sparkline()` will be removed soon now that [`bstfun`/`gtsummary`](https://github.com/ddsjoberg/bstfun/pull/102) are no longer depending on it. `gt_plt_dist()` and `gt_plt_sparkline()` will be the new preferred and enhanced versions of `gt_sparkline()`.
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
