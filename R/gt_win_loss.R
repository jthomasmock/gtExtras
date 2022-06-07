
#' Add win loss point plot into rows of a `gt` table
#' @description
#' The `gt_plt_winloss` function takes an existing `gt_tbl` object and
#' adds squares of a specific color and vertical position based on wins/losses.
#' It is a wrapper around `gt::text_transform()`. The column chosen **must** be
#' a list-column as seen in the example code. The column should also only contain
#' values of 0 (loss), 0.5 (tie), and 1 (win).
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column wherein the winloss plot should replace existing data. Note that the data *must* be represented as a list of numeric values ahead of time.
#' @param max_wins An integer indicating the max possible wins, this will be used to add padding if the total wins/losses observed is less than the max. This is useful for mid-season reporting. Defaults to a red, blue, grey palette.
#' @param palette A character vector of length 3, specifying the colors for win, loss, tie in that exact order.
#' @param type A character string representing the type of plot, either a 'pill' or 'square'
#' @param width A numeric indicating the width of the plot in `mm`, this can help with larger datasets where data points are overlapping.
#' @return An object of class `gt_tbl`.
#' @export
#' @section Examples:
#' ```r
#' #' library(gt)
#'
#' set.seed(37)
#' data_in <- dplyr::tibble(
#'   grp = rep(c("A", "B", "C"), each = 10),
#'   wins = sample(c(0,1,.5), size = 30, prob = c(0.45, 0.45, 0.1), replace = TRUE)
#' ) %>%
#'   dplyr::group_by(grp) %>%
#'   dplyr::summarize(wins=list(wins), .groups = "drop")
#'
#' data_in
#'
#' win_table <- data_in %>%
#'   gt() %>%
#'   gt_plt_winloss(wins)
#' ```
#' \if{html}{\out{
#' `r man_get_image_tag(file = "gt_plt_winloss-ex.png", width = 60)`
#' }}
#'
#' @family Plotting
#' @section Function ID:
#' 3-1

gt_plt_winloss <- function(gt_object, column, max_wins = 17,
                           palette = c("#013369", "#D50A0A", "gray"),
                           type = "pill", width = max_wins/0.83) {

  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))
  stopifnot("type must be on of 'pill' or 'square'" = {type %in% c("pill", "square")})
  stopifnot("There must be 3 colors" = length(palette) == 3L)

  list_vals <- gt_index(gt_object = gt_object, {{ column }}, as_vector = TRUE)

  stopifnot("The column must be a list-column" = is.list(list_vals))
  stopifnot("All values must be 1, 0 or 0.5" = unlist(list_vals) %in% c(NA, NULL, 1, 0, 0.5))

  plot_fn_pill <- function(vals){

    if(all(is.na(vals) | is.null(vals))){
      plot_out <- ggplot() + theme_void()
    } else {
      input_data <- data.frame(
        x = 1:length(vals),
        xend = 1:length(vals),
        y = ifelse(vals == 0.5, 0.4, vals),
        yend = ifelse(vals == 0, 0.6, ifelse(vals > 0.5, 0.4, 0.6)),
        color = ifelse(vals == 0, palette[2], ifelse(vals == 1, palette[1], palette[3]))
      )

      plot_out <- ggplot(input_data) +
        geom_segment(
          aes(x = .data$x, xend = .data$xend, y = .data$y, yend = .data$yend, color = I(.data$color)),
          size = 1, lineend = "round") +
        scale_x_continuous(limits = c(0.5, max_wins + 0.5)) +
        scale_y_continuous(limits = c(-.2, 1.2)) +
        theme_void()


    }

    out_name <- file.path(
      tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".svg")
    )

    ggsave(out_name, plot = plot_out,
           dpi = 20, height = 3.81, width = width, units = "mm")

    img_plot <- out_name %>%
      readLines() %>%
      paste0(collapse = "") %>%
      gt::html()

    on.exit(file.remove(out_name), add=TRUE)

    img_plot

  }

  plot_fn_square <- function(vals){

    if(all(is.na(vals) | is.null(vals))){
      plot_out <- ggplot() + theme_void()
    } else {

    input_data <- data.frame(
      x = 1:length(vals),
      xend = 1:length(vals),
      y = ifelse(vals == 0.5, 0.4, vals),
      yend = ifelse(vals == 0, 0.6, ifelse(vals > 0.5, 0.4, 0.6)),
      color = ifelse(vals == 0, palette[2], ifelse(vals == 1, palette[1], palette[3]))
    )

    plot_out <- ggplot(input_data) +
      geom_point(
        aes(x = .data$x, y = .data$y, color = I(.data$color)),
        size = 1, shape = 15) +
      scale_x_continuous(limits = c(0.5, max_wins + 0.5)) +
      scale_y_continuous(limits = c(-.2, 1.2)) +
      theme_void()

    }

    out_name <- file.path(
      tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".svg")
    )

    ggsave(out_name, plot = plot_out,
           dpi = 20, height = 0.15, width = 0.9)

    img_plot <- out_name %>%
      readLines() %>%
      paste0(collapse = "") %>%
      gt::html()

    on.exit(file.remove(out_name), add=TRUE)

    img_plot

  }


  text_transform(
    gt_object,
    locations = cells_body(columns = {{ column }}),
    fn = function(x){
      lapply(
        list_vals,
        if(type == "pill"){plot_fn_pill} else {plot_fn_square}
      )
    }
  )

}


