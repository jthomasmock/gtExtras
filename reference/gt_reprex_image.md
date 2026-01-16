# Render 'gt' Table to Temporary png File

Take a gt pipeline or object and print it as an image within a reprex

## Usage

``` r
gt_reprex_image(gt_object)
```

## Arguments

- gt_object:

  An object of class `gt_tbl` usually created by
  [`gt::gt()`](https://gt.rstudio.com/reference/gt.html)

## Value

a png image

## Details

Saves a gt table to a temporary png image file and uses
[`knitr::include_graphics()`](https://rdrr.io/pkg/knitr/man/include_graphics.html)
to render tables in reproducible examples like `reprex::reprex()` where
the HTML is not transferrable to GitHub.
