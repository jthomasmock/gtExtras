# Create a summary table from a dataframe

Create a summary table from a dataframe with inline histograms or area
bar charts. Inspired by the Observable team and the
observablehq/SummaryTable function:
https://observablehq.com/d/d8d2929832202050

## Usage

``` r
gt_plt_summary(df, title = NULL)
```

## Arguments

- df:

  a dataframe or tibble

- title:

  a character string to be used in the table title

## Value

a gt table

## Examples

Create a summary table from a `data.frame` or `tibble`.

    gt_plt_summary(datasets::ChickWeight)

![A summary table of the chicks
dataset.](https://raw.githubusercontent.com/jthomasmock/gtExtras/master/images/gt_plt_summary-chicks.png)
