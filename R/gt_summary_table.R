#' Create a summary table from a dataframe
#' @description Create a summary table from a dataframe with inline
#' histograms or area bar charts. Inspired by the Observable team and
#' the observablehq/SummaryTable function: https://observablehq.com/d/d8d2929832202050
#' @param df a dataframe or tibble
#' @param title a character string to be used in the table title
#' @importFrom stats median sd
#' @import gt
#' @importFrom gt %>%
#' @importFrom stats IQR
#' @importFrom utils packageVersion
#' @return a gt table
#' @export
#' @section Examples:
#'
#' Create a summary table from a `data.frame` or `tibble`.
#'
#' ```r
#' gt_plt_summary(datasets::ChickWeight)
#' ```
#' \if{html}{\out{
#' `r man_get_image_tag(file = "gt_plt_summary-chicks.png", alt = "A summary table of the chicks dataset.")`
#' }}

gt_plt_summary <- function(df, title = NULL) {
  # if no title, return name of input dataframe
  # returns a . for df %>% gt_plt_summary()
  if (is.null(title)) title <- deparse(substitute(df))

  sum_table <- create_sum_table(df)

  dim_df <- dim(df)

  tab_out <- sum_table %>%
    gt() %>%
    text_transform(
      cells_body(name),
      fn = function(x){
        temp_df <- gtExtras::gt_index(gt_object = ., name, as_vector = FALSE)

        apply_detail <- function(type, name, value){
          if (grepl(x = type, pattern = "factor|character|ordered")){

            value_count <- tapply(value,value,length) %>%
              sort(decreasing = TRUE) %>%
              labels() %>% unlist()

            html(
              glue::glue(
                "<div style='max-width: 150px;'>
                <details style='font-weight: normal !important;'>
                <summary style='font-weight: bold !important;'>{name}</summary>
            {glue::glue_collapse(value_count, ', ', last = ' and ')}
            </details></div>"
              )
            )

          } else {
            name
          }
        }

        mapply(
          FUN = apply_detail,
            temp_df$type,
            temp_df$name,
            temp_df$value,
          MoreArgs = NULL
        )

      }
    ) %>%
    text_transform(cells_body(value),
      fn = function(x) {
        .mapply(
          FUN = plot_data,
          list(
            gtExtras::gt_index(gt_object = ., value),
            gtExtras::gt_index(gt_object = ., name)
          ),
          MoreArgs = NULL
        )
      }
    ) %>%
    # add number formatting to numeric cols
    fmt_number(
      Mean:SD,
      decimals = 1,
      rows = type %in% c("numeric", "double", "integer")
    ) %>%
    fmt_percent(n_missing, decimals = 1) %>%
    # add symbols for specific types
    text_transform(
      cells_body(type),
      fn = function(x) {
        lapply(x, function(z) {
          if (grepl(x = z, pattern = "factor|character|ordered")) {
            fontawesome::fa("list", "#4e79a7", height = "20px")
          } else if (grepl(x = z, pattern = "number|numeric|double|integer|complex")) {
            fontawesome::fa("signal", "#f18e2c", height = "20px")
          } else if (grepl(x = z, pattern = "date|time|posix|hms", ignore.case = TRUE)) {
            fontawesome::fa("clock", "#73a657", height = "20px")
          } else {
            fontawesome::fa("question", "black", height = "20px")
          }
        })
      }
    ) %>%
    cols_label(
      name = "Column",
      value = "Plot Overview",
      type = "", n_missing = "Missing"
    ) %>%
    gtExtras::gt_theme_espn() %>%
    tab_style(cells_body(name),
      style = cell_text(weight = "bold")
    ) %>%
    tab_header(
      title = title,
      subtitle = glue::glue("{dim_df[1]} rows x {dim_df[2]} cols")
    ) %>%
    tab_options(
      column_labels.border.top.width = px(0),
      heading.border.bottom.width = px(0)
    )

  {
    if (utils::packageVersion("gt")$minor >= 6) {
      tab_out %>% sub_missing(Mean:SD)
    } else {
      tab_out %>% fmt_missing(Mean:SD)
    }
  }
}


#' Create a summary table from a dataframe
#'
#' @param df a dataframe or tibble
#'
#' @return A summary dataframe as a tibble
#' @export
#'
#' @examples
#' \dontrun{
#' create_sum_table(iris)
#' #>   # A tibble: 5 × 7
#' #>   type    name         value       n_missing  Mean Median     SD
#' #>   <chr>   <chr>        <list>          <dbl> <dbl>  <dbl>  <dbl>
#' #> 1 numeric Sepal.Length <dbl [150]>         0  5.84   5.8   0.828
#' #> 2 numeric Sepal.Width  <dbl [150]>         0  3.06   3     0.436
#' #> 3 numeric Petal.Length <dbl [150]>         0  3.76   4.35  1.77
#' #> 4 numeric Petal.Width  <dbl [150]>         0  1.20   1.3   0.762
#' #> 5 factor  Species      <fct [150]>         0  NA     NA    NA
#' }
#'
create_sum_table <- function(df) {
  sum_table <- df %>%
    dplyr::summarise(dplyr::across(dplyr::everything(), list)) %>%
    tidyr::pivot_longer(dplyr::everything()) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      type = paste0(class(value), collapse = " "),
      n_missing = sum(is.na(value) | is.null(value)) / length(value)
    ) %>%
    dplyr::mutate(
      Mean = ifelse(type %in% c("double", "integer", "numeric"), mean(value, na.rm = TRUE), NA),
      Median = ifelse(type %in% c("double", "integer", "numeric"), median(value, na.rm = TRUE), NA),
      SD = ifelse(type %in% c("double", "integer", "numeric"), sd(value, na.rm = TRUE), NA)
    ) %>%
    dplyr::ungroup() %>%
    dplyr::select(type, name, dplyr::everything())
  sum_table
}

#' Create inline plots for a summary table
#'
#' @param col The column of data to be used for plotting
#' @param col_name the name of the column - use for reporting warnings
#' @param ... additional arguments passed to scales::label_number()
#' @import ggplot2 dplyr
#' @importFrom scales seq_gradient_pal expand_range label_number cut_long_scale label_date
#' @return svg text encoded as HTML
plot_data <- function(col, col_name, ...) {
  col_type <- paste0(class(col), collapse = " ")

  col <- col[!is.na(col)]

  if (col_type %in% c("factor", "character", "ordered factor")) {
    n_unique <- length(unique(col))

    cat_lab <- ifelse(col_type == "ordered factor", "categories, ordered", "categories")

    cc <- scales::seq_gradient_pal(low = "#3181bd", high = "#ddeaf7", space = "Lab")(seq(0, 1, length.out = n_unique))

    plot_out <- dplyr::tibble(vals = as.character(col)) %>%
      dplyr::group_by(vals) %>%
      dplyr::mutate(n = n(), .groups = "drop") %>%
      dplyr::arrange(desc(n)) %>%
      dplyr::ungroup() %>%
      dplyr::mutate(vals = factor(vals, levels = unique(rev(vals)), ordered = TRUE)) %>%
      ggplot(aes(y = 1, fill = vals)) +
      geom_bar(position = "fill") +
      guides(fill = "none") +
      scale_fill_manual(values = rev(cc)) +
      theme_void() +
      theme(
        axis.title.x = element_text(hjust = 0, size = 8),
        plot.margin = margin(3, 1, 3, 1)
      ) +
      scale_x_continuous(expand = c(0, 0)) +
      labs(x = paste(n_unique, cat_lab))
  } else if (col_type %in% c("numeric", "double", "integer", "complex")) {
    df_in <- dplyr::tibble(x = col) %>%
      dplyr::filter(!is.na(x))

    rng_vals <- scales::expand_range(range(col, na.rm = TRUE), mul = 0.01)

    # auto binwidth per Rob Hyndman
    # https://stats.stackexchange.com/questions/798/calculating-optimal-number-of-bins-in-a-histogram
    bw <- 2 * IQR(col, na.rm = TRUE) / length(col)^(1 / 3)

    plot_out <- ggplot(df_in, aes(x = x)) +
      geom_histogram(color = "white", fill = "#f8bb87", binwidth = bw) +
      scale_x_continuous(
        breaks = range(col),
        labels = scales::label_number(big.mark = ",", ..., scale_cut = scales::cut_long_scale())(range(col, na.rm = TRUE))
      ) +
      geom_point(data = NULL, aes(x = rng_vals[1], y = 1), color = "transparent", size = 0.1) +
      geom_point(data = NULL, aes(x = rng_vals[2], y = 1), color = "transparent", size = 0.1) +
      scale_y_continuous(expand = c(0, 0)) +
      {
        if (length(unique(col)) > 2) geom_vline(xintercept = median(col, na.rm = TRUE))
      } +
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
  } else if (grepl(x = col_type, pattern = "date|posix|time|hms", ignore.case = TRUE)) {
    # message(glue::glue("Dates and times are not fully supported yet - plot and summaries skipped for col {col_name}"))

    df_in <- dplyr::tibble(x = col) %>%
      dplyr::filter(!is.na(x))

    bw <- 2 * IQR(col, na.rm = TRUE) / length(col)^(1 / 5)

    plot_out <- ggplot(data = df_in, aes(x = x)) +
      geom_histogram(color = "white", fill = "#73a657", binwidth = bw) +
      {
        if ("continuous" %in% ggplot2::scale_type(col)) {
          scale_x_continuous(
            breaks = range(col, na.rm = TRUE),
            labels = scales::label_date()(range(col, na.rm = TRUE))
          )
        } else if ("time" %in% ggplot2::scale_type(col)) {
          scale_x_time(
            breaks = range(col, na.rm = TRUE)
          )
        } else {
          scale_x_discrete(
            breaks = range(col, na.rm = TRUE)
          )
        }
      } +
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

  ggsave(out_name,
    plot = plot_out, dpi = 25.4,
    height = 12, width = 50, units = "mm",
    device = "svg"
  )

  img_plot <- readLines(out_name) %>%
    paste0(collapse = "") %>%
    gt::html()

  on.exit(file.remove(out_name), add = TRUE)

  img_plot
}
