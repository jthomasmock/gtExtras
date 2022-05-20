#' Create a summary table from a dataframe
#' @description Create a summary table from a dataframe with inline
#' histograms or area bar charts. Inspired by the Observable team and
#' the observablehq/SummaryTable function: https://observablehq.com/d/d8d2929832202050
#' @param df a dataframe or tibble
#' @param title a character string to be used in the table title
#' @importFrom stats median sd
#' @import gt
#' @return a gt table
#' @export

gt_plt_summary <- function(df, title){

  sum_table <- create_sum_table(df)

  dim_df <- dim(df)

  sum_table %>%
    gt() %>%
    text_transform(cells_body(value),
      fn = function(x){
        lapply(gtExtras::gt_index(gt_object = ., value), plot_data)
      }) %>%
    text_transform(
      cells_body(type),
      fn = function(x){

        lapply(x, function(z){

          if(z == "factor"){
            fontawesome::fa("list", "#4e79a7", height = "20px")
          } else {
            fontawesome::fa("signal", "#f18e2c", height = "20px")
          }

        })
      }
    ) %>%
    fmt_missing(Mean:SD) %>%
    fmt_number(Mean:SD, decimals = 1) %>%
    fmt_percent(n_missing, decimals = 1) %>%
    cols_label(name = "Column",
      value = "Snapshot",
      type = "", n_missing = "Missing") %>%
    gtExtras::gt_theme_espn() %>%
    tab_style(cells_body(name),
      style = cell_text(weight = "bold")) %>%
    tab_header(
      title = title,
      subtitle = glue::glue("{dim_df[1]} cols x {dim_df[2]} rows")) %>%
    tab_options(
      column_labels.border.top.width = px(0),
      heading.border.bottom.width = px(0)
    )

}


#' Create a summary table from a dataframe
#'
#' @param df a dataframe or tibble
#'
#' @return A summary dataframe as a tibble
#' @export
#'
#' @examples
#' \dontrun{create_sum_table(iris)
#'  #>   # A tibble: 5 × 7
#'  #>   type    name         value       n_missing  Mean Median     SD
#'  #>   <chr>   <chr>        <list>          <dbl> <dbl>  <dbl>  <dbl>
#'  #> 1 numeric Sepal.Length <dbl [150]>         0  5.84   5.8   0.828
#'  #> 2 numeric Sepal.Width  <dbl [150]>         0  3.06   3     0.436
#'  #> 3 numeric Petal.Length <dbl [150]>         0  3.76   4.35  1.77
#'  #> 4 numeric Petal.Width  <dbl [150]>         0  1.20   1.3   0.762
#'  #> 5 factor  Species      <fct [150]>         0 NA     NA    NA
#' }

create_sum_table <- function(df){
  sum_table <- df |>
    dplyr::summarise(dplyr::across(dplyr::everything(), list)) |>
    tidyr::pivot_longer(dplyr::everything()) |>
    dplyr::rowwise() |>
    dplyr::mutate(
      type = class(value),
      n_missing = sum(is.na(value) | is.null(value)) / length(value)
    ) |>
    dplyr::mutate(
      Mean = ifelse(type %in% c("double", "integer", "numeric"), mean(value, na.rm = TRUE), NA),
      Median = ifelse(type %in% c("double", "integer", "numeric"), median(value, na.rm = TRUE), NA),
      SD = ifelse(type %in% c("double", "integer", "numeric"), sd(value, na.rm = TRUE), NA)
    ) |>
    dplyr::ungroup() |>
    dplyr::select(type, name, dplyr::everything())
  sum_table
}

#' Create inline plots for a summary table
#'
#' @param col The column of data to be used for plotting
#' @param ... additional arguments passed to scales::label_number()
#' @import ggplot2 dplyr
#' @importFrom scales seq_gradient_pal expand_range label_number
#' @return svg text encoded as HTML
plot_data <- function(col, ...) {
  col_type <- class(col)

  col <- col[!is.na(col)]

  if (col_type %in% c("factor", "character")) {
    n_unique <- length(unique(col))

    cc <- scales::seq_gradient_pal("#3181bd", "#9ecae0", "#ddeaf7")(seq(0, 1, length.out = n_unique))

    plot_out <- dplyr::tibble(vals = as.character(col)) |>
      dplyr::group_by(vals) |>
      dplyr::mutate(n = n(), .groups = "drop") |>
      dplyr::arrange(desc(n)) |>
      dplyr::ungroup() |>
      dplyr::mutate(vals = factor(vals, levels = unique(rev(vals)), ordered = TRUE)) |>
      ggplot(aes(y = 1, fill = vals)) +
      geom_bar(position = "fill") +
      guides(fill = "none") +
      scale_fill_manual(values = rev(cc)) +
      theme_void() +
      theme(axis.title.x = element_text(hjust = 0, size = 6)) +
      scale_x_continuous(expand = c(0, 0)) +
      labs(x = paste(n_unique, "categories"))
  } else {

    df_in <- dplyr::tibble(x = col) %>%
      dplyr::filter(!is.na(x))

    rng_vals <- scales::expand_range(range(col, na.rm = TRUE), mul = 0.01)

    plot_out <- ggplot(df_in, aes(x = x)) +
      geom_histogram(color = "white", fill = "#f8bb87",
        bins = 30) +
      scale_x_continuous(
        breaks = range(col),
        labels = scales::label_number(big.mark = ",", ...)(range(col))
      ) +
      geom_point(data = NULL, aes(x = rng_vals[1], y = 1), color = "transparent", size = 0.1) +
      geom_point(data = NULL, aes(x = rng_vals[2], y = 1), color = "transparent", size = 0.1) +
      scale_y_continuous(expand = c(0, 0)) +
      {if(length(unique(col)) > 2) geom_vline(xintercept = median(col, na.rm = TRUE)) } +
      theme_void() +
      theme(
        axis.text.x = element_text(
          color = "black",
          vjust = -2,
          size = 6
        ),
        axis.line.x = element_line(color = "black"),
        axis.ticks.x = element_line(color = "black"),
        axis.ticks.length.x = unit(1, "mm"),
        plot.margin = margin(1, 1, 3, 1),
        text = element_text(family = "mono", size = 6)
      )
  }

  out_name <- file.path(tempfile(
    pattern = "file",
    tmpdir = tempdir(),
    fileext = ".svg"
  ))

  ggsave(out_name, plot = plot_out, dpi = 25.4,
    height = 12, width = 50, units = "mm",
    device = "svg"
  )

  img_plot <- readLines(out_name) %>%
    paste0(collapse = "") %>%
    gt::html()

  on.exit(file.remove(out_name))

  img_plot

}

