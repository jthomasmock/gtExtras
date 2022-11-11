#' Convert to percent and show less than 1% as <1% in grey
#'
#' @param gt_object An existing gt table
#' @param columns The columns to affect
#' @param ... Additional argument passed to `scales::label_percent()`
#' @param scale A number to multiply values by, defaults to 1
#'
#' @return a gt table
#' @export
#'
#' @examples
#' library(gt)
#' pct_tab <- dplyr::tibble(x = c(.001, .05, .008, .1, .2, .5, .9)) %>%
#'   gt::gt() %>%
#'   fmt_pct_extra(x, scale = 100, accuracy = .1)
#' @family Utilities

fmt_pct_extra <- function(gt_object, columns, ..., scale = 1) {
  gt_object %>%
    text_transform(
      locations = cells_body(columns = {{ columns }}),
      fn = function(x) {
        x <- as.double(x)

        x <- scales::label_percent(..., scale = scale)(x)

        sapply(x, function(xy) {
          xz <- gsub(x = xy, "%", "") %>% as.double()
          if (xz >= 1) {
            xy
          } else {
            gt::html("<span style='color:grey;'><1%</span>")
          }
        })
      }
    ) %>%
    cols_align("right", columns = {{ columns }})
}
