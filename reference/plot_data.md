# Create inline plots for a summary table

Create inline plots for a summary table

## Usage

``` r
plot_data(col, col_name, n_missing, ...)
```

## Arguments

- col:

  The column of data to be used for plotting

- col_name:

  the name of the column - use for reporting warnings

- n_missing:

  Number of missing - used if all missing

- ...:

  additional arguments passed to scales::label_number()

## Value

svg text encoded as HTML
