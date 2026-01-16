# Add a dumbbell plot in place of two columns

Add a dumbbell plot in place of two columns

## Usage

``` r
gt_plt_dumbbell(
  gt_object,
  col1 = NULL,
  col2 = NULL,
  label = NULL,
  palette = c("#378E38", "#A926B6", "#D3D3D3"),
  width = 70,
  text_args = list(accuracy = 1),
  text_size = 2.5
)
```

## Arguments

- gt_object:

  an existing gt_tbl or pipeline

- col1:

  column 1, plot will replace this column

- col2:

  column 2, will be hidden

- label:

  an optional new label for the transformed column

- palette:

  must be 3 colors in order of col1, col2, bar color

- width:

  width in mm, defaults to 70

- text_args:

  A list of named arguments. Optional text arguments passed as a list to
  [`scales::label_number`](https://scales.r-lib.org/reference/label_number.html).

- text_size:

  A number indicating the size of the text indicators in the plot.
  Defaults to 1.5. Can also be set to `0` to "remove" the text itself.

## Value

a gt_object table

## Examples

    head(mtcars) %>%
      gt() %>%
      gt_plt_dumbbell(disp, mpg)

## Figures

![](figures/gt_plt_dumbell.png)
