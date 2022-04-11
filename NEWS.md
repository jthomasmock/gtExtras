# gtExtras (development version)

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
