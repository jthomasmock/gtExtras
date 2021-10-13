
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
#' @param colors A character vector of length 3, specifying the colors for loss, win, tie in that exact order.
#' @param type A character string representing the type of plot, either a 'pill' or 'square'
#' @return An object of class `gt_tbl`.
#' @importFrom gt %>%
#' @import gt rlang
#' @export
#' @examples
#' library(gt)
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
#' @section Figures:
#' \if{html}{\figure{gt_plt_winloss-ex.png}{options: width=60\%}}
#'
#' @family Plotting
#' @section Function ID:
#' 3-1

gt_plt_winloss <- function(gt_object, column, max_wins = 17,
                           colors = c("#D50A0A", "#013369", "gray"),
                           type = "pill") {

  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))
  stopifnot("type must be on of 'pill' or 'square'" = {type %in% c("pill", "square")})
  stopifnot("There must be 3 colors" = length(colors) == 3L)

  test_vals <- gt_object[["_data"]] %>%
    dplyr::select({{ column }}) %>%
    dplyr::pull()

  stopifnot("The column must be a list-column" = is.list(test_vals))
  stopifnot("All values must be 1, 0 or 0.5" = unlist(test_vals) %in% c(1, 0, 0.5))

  plot_fn_pill <- function(x){

    if(x %in% c("NA", "NULL")){
      return("<div></div>")
    }

    vals <- strsplit(x, split = ", ") %>%
      unlist() %>%
      as.double()

    input_data <- data.frame(
        x = 1:length(vals),
        xend = 1:length(vals),
        y = ifelse(vals == 0.5, 0.4, vals),
        yend = ifelse(vals == 0, 0.6, ifelse(vals > 0.5, 0.4, 0.6)),
        color = ifelse(vals == 0, colors[3], ifelse(vals == 1, colors[1], colors[2]))
      )
    
    

    plot_out <- ggplot(input_data) +
      geom_segment(
        aes(x = x, xend = xend, y = y, yend = yend, color = I(color)),
        size = 1, lineend = "round") +
      scale_x_continuous(limits = c(0.5, max_wins + 0.5)) +
      scale_y_continuous(limits = c(-.2, 1.2)) +
      theme_void()

    out_name <- file.path(
      tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".svg")
    )

    ggsave(out_name, plot = plot_out,
           dpi = 20, height = 0.15, width = 0.9)

    img_plot <- out_name %>%
      readLines() %>%
      paste0(collapse = "") %>%
      gt::html()

    on.exit(file.remove(out_name))

    img_plot

  }

  plot_fn_square <- function(x){

    vals <- strsplit(x, split = ", ") %>%
      unlist() %>%
      as.double()

    input_data <- data.frame(
      x = 1:length(vals),
      xend = 1:length(vals),
      y = ifelse(vals == 0.5, 0.4, vals),
      yend = ifelse(vals == 0, 0.6, ifelse(vals > 0.5, 0.4, 0.6)),
      color = ifelse(vals == 0, "#D50A0A", ifelse(vals == 1, "#013369", "grey"))
    )

    plot_out <- ggplot(input_data) +
      geom_point(
        aes(x = x, y = y, color = I(color)),
        size = 1, shape = 15) +
      scale_x_continuous(limits = c(0.5, max_wins + 0.5)) +
      scale_y_continuous(limits = c(-.2, 1.2)) +
      theme_void()

    out_name <- file.path(
      tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".svg")
    )

    ggsave(out_name, plot = plot_out,
           dpi = 20, height = 0.15, width = 0.9)

    img_plot <- out_name %>%
      readLines() %>%
      paste0(collapse = "") %>%
      gt::html()

    on.exit(file.remove(out_name))

    img_plot

  }


  text_transform(
    gt_object,
    locations = cells_body(columns = {{ column }}),
    fn = function(x){
      lapply(
        x,
        if(type == "pill"){plot_fn_pill} else {plot_fn_square}
      )
    }
  )

}


