#' Take data, a gt-generating function, and create a list of two tables
#'
#' @description The `gt_double_table` function takes some data and a user-supplied
#' function to generate two tables in a list. To convert existing `gt::gt()`
#' code to a function, you can follow the approximate pattern:
#' `gt_fn <- function(x){gt(x) %>% more_gt_code}`
#'
#' Your function should only have a **single argument**, which is the **data**
#' to be supplied directly into the `gt::gt()` function. This function is
#' intended to be passed directly into `gt_two_column_layout()`, for printing
#' it to the viewer, saving it to a `.png`, or returning the raw HTML.
#'
#' @param data A `tibble` or dataframe to be passed into the supplied `gt_fn`
#' @param gt_fn A user-defined function that has one argument, this argument should pass data to the `gt::gt()` function, which will be supplied by the `data` argument. It should follow the pattern of `gt_function <- function(x) gt(x) %>% more_gt_code...`.
#' @param nrows The number of rows to split at, defaults to `NULL` and will attempt to split approximately 50/50 in the left vs right table.
#' @param noisy A logical indicating whether to return the warning about not supplying `nrows` argument.
#' @return a `list()` of two `gt` tables
#' @export
#'
#' @section Examples:
#' ```r
#' library(gt)
#' # define your own function
#' my_gt_function <- function(x) {
#'   gt(x) %>%
#'     gtExtras::gt_color_rows(columns = mpg, domain = range(mtcars$mpg)) %>%
#'     tab_options(data_row.padding = px(3))
#' }
#'
#' two_tables <- gt_double_table(mtcars, my_gt_function, nrows = 16)
#'
#' # list of two gt_tbl objects
#' # ready to pass to gtExtras::gt_two_column_layout()
#' str(two_tables, max.level = 1)
#'
#' #> List of 2
#' #> $ :List of 16
#' #> ..- attr(*, "class")= chr [1:2] "gt_tbl" "list"
#' #> $ :List of 16
#' #> ..- attr(*, "class")= chr [1:2] "gt_tbl" "list"
#' ```
#' @family Utilities
#' @section Function ID:
#' 2-13

gt_double_table <- function(data, gt_fn, nrows = NULL, noisy = TRUE) {
  if (is.null(nrows) && isTRUE(noisy)) {
    message("'nrows' is not defined, defaulting to approximately 50/50 split of data.")
  }

  if (is.null(nrows)) {
    total_rows <- nrow(data)
    half_rows <- ceiling(total_rows / 2)
    tab2_start <- half_rows + 1

    tab1 <- data %>%
      dplyr::slice(1:half_rows) %>%
      gt_fn()

    tab2 <- data %>%
      slice(tab2_start:total_rows) %>%
      gt_fn()
  } else if (!is.null(nrows)) {
    tab1 <- data %>%
      dplyr::slice(1:nrows) %>%
      gt_fn()

    tab2 <- data %>%
      dplyr::slice((nrows + 1):nrow(.)) %>%
      gt_fn()
  }

  # returns a list object, to be used in gt_two_column_layout
  list(tab1, tab2)
}

#' Create a two-column layout from a list of two gt tables
#' @description This function takes a `list()` of two gt-tables and returns
#' them as a two-column layout. The expectation is that the user either supplies
#' two tables like `list(table1, table2)`, or passes the output of `gt_double_table()`
#' into this function. The user should indicate whether they want to return the
#' HTML to R's viewer with `output = "viewer"` to "view" the final output, or to
#' save to disk as a `.png` via `output = "save".` Note that this is a relatively
#' complex wrapper around `htmltools::div()` + `webshot2::webshot()`. Additional
#' arguments can be passed to `webshot2::webshot()` if the automatic output is not
#' satisfactory. In most situations, modifying the `vwidth` argument is sufficient
#' to get the desired output, but all arguments to `webshot2::webshot()` are
#' available by their original name via the passed `...`.
#'
#' @param tables A `list()` of two tables, typically supplied by `gt_double_table()`
#' @param output A character string indicating the desired output, either `"save"` to save it to disk via `webshot`, `"viewer"` to return it to the RStudio Viewer, or `"html"` to return the raw HTML.
#' @param filename The filename of the table, must contain `.png` and only used if `output = "save"`
#' @param path An optional path of where to save the printed `.png`, used in conjunction with `filename`.
#' @param vwidth Viewport width. This is the width of the browser "window" when passed to `webshot2::webshot()`.
#' @param vheight Viewport height This is the height of the browser "window" when passed to `webshot2::webshot()`.
#' @param ... Additional arguments passed to `webshot2::webshot()`, only to be used if `output = "save"`, saving the two-column layout tables to disk as a `.png`.
#' @param zoom Argument to `webshot2::webshot()`. A number specifying the zoom factor. A zoom factor of 2 will result in twice as many pixels vertically and horizontally. Note that using 2 is not exactly the same as taking a screenshot on a HiDPI (Retina) device: it is like increasing the zoom to 200 doubling the height and width of the browser window. This differs from using a HiDPI device because some web pages load different, higher-resolution images when they know they will be displayed on a HiDPI device (but using zoom will not report that there is a HiDPI device).
#' @param expand Argument to `webshot2::webshot()`. A numeric vector specifying how many pixels to expand the clipping rectangle by. If one number, the rectangle will be expanded by that many pixels on all sides. If four numbers, they specify the top, right, bottom, and left, in that order. When taking screenshots of multiple URLs, this parameter can also be a list with same length as url with each element of the list containing a single number or four numbers to use for the corresponding URL.
#' @return Saves a `.png` to disk if `output = "save"`, returns HTML to the viewer via `htmltools::browsable()` when `output = "viewer"`, or returns raw HTML if `output = "html"`.
#' @export
#' @family Utilities
#' @section Examples:
#' Add row numbers and drop some columns
#' ``` r
#' library(gt)
#' my_cars <- mtcars %>%
#'   dplyr::mutate(row_n = dplyr::row_number(), .before = mpg) %>%
#'   dplyr::select(row_n, mpg:drat)
#' ```
#' Create two tables, just split half/half
#'
#' ```r
#' tab1 <- my_cars %>%
#'   dplyr::slice(1:16) %>%
#'   gt() %>%
#'   gtExtras::gt_color_rows(columns = row_n, domain = 1:32)
#'
#' tab2 <- my_cars %>%
#'   dplyr::slice(17:32) %>%
#'   gt() %>%
#'   gtExtras::gt_color_rows(columns = row_n, domain = 1:32)
#' ```
#'  Put the tables in a list and then pass list to the `gt_two_column_layout` function.
#' ```r
#' listed_tables <- list(tab1, tab2)
#'
#' gt_two_column_layout(listed_tables)
#' ```
#'
#' A better option - write a small function, use `gt_double_table()` to generate
#' the tables and then pass it to `gt_double_table()`
#'
#' ```r
#' my_gt_fn <- function(x) {
#'   gt(x) %>%
#'     gtExtras::gt_color_rows(columns = row_n, domain = 1:32)
#' }
#'
#' my_tables <- gt_double_table(my_cars, my_gt_fn, nrows = nrow(my_cars) / 2)
#' ```
#'
#' This will return it to the viewer
#'
#' ```r
#' gt_two_column_layout(my_tables)
#' ```
#' If you wanted to save it out instead, could use the code below
#'
#' ```r
#' gt_two_column_layout(my_tables, output = "save",
#'                      filename = "basic-two-col.png",
#'                       vwidth = 550, vheight = 620)
#' ```
#' @section Figures:
#' \if{html}{\figure{basic-two-col.png}{options: width=60\%}}
#'
gt_two_column_layout <- function(tables = NULL, output = "viewer",
                                 filename = NULL, path = NULL,
                                 vwidth = 992, vheight = 600, ...,
                                 zoom = 2, expand = 5) {
  if (length(tables) != 2) {
    stop("Two 'gt' tables must be provided like `list(table1, table2)` and be of length == 2", call. = FALSE)
  }

  if (!is.null(filename) && !grepl(".png", filename)) {
    stop("If supplying a filename, it must be a `.png`")
  }

  stopifnot("Output must be one of 'viewer', 'save', 'html'" = output %in% c("viewer", "save", "html"))

  stopifnot("Two 'gt' tables must be provided like `list(table1, table2)`" = !is.null(tables))
  stopifnot("Two 'gt' tables must be provided like `list(table1, table2)`" = is.list(tables))
  stopifnot("Both tables in the list must be a 'gt_tbl' object" = all(c(class(tables[[1]])[1], class(tables[[2]])[1]) == "gt_tbl"))

  double_tables <- htmltools::div(
    htmltools::div(tables[1], style = "display: inline-block;float:left;"),
    htmltools::div(tables[2], style = "display: inline-block;float:right;")
  )

  if (output == "viewer") {
    htmltools::browsable(double_tables)
  } else if (output == "save") {
    filename <- gtsave_filename(path = path, filename = filename)

    # Create a temporary file with the `html` extension
    tempfile_ <- tempfile(fileext = ".html")

    # Reverse slashes on Windows filesystems
    tempfile_ <-
      tempfile_ %>%
      tidy_gsub("\\\\", "/")

    htmltools::save_html(html = double_tables, file = tempfile_)

    # Saving an image requires the webshot2 package; if it's
    # not present, stop with a message
    if (!rlang::is_installed("webshot2")) {
      stop("The `webshot2` package is required for saving images of gt tables.)",
        call. = FALSE
      )
    } else {
      # Save the image in the working directory
      webshot2::webshot(
        url = paste0("file:///", tempfile_),
        file = filename,
        vwidth = vwidth,
        vheight = vheight,
        zoom = zoom,
        expand = expand,
        ...
      )
    }
  } else if (output == "html") {
    double_tables
  }
}
