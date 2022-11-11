#' Add images as the column label for a table
#'
#' @param label A string indicating the label of the column.
#' @param img_url A string for the image url.
#' @param height A number indicating the height of the image in pixels.
#' @param font_size The font size of the label in pixels.
#' @param palette A vector of two colors, indictating the bottom border color and the text color.
#' @return HTML string
#' @export
#' @section Examples:
#' ```r
#' library(gt)
#' dplyr::tibble(
#'   x = 1:5, y = 6:10
#' ) %>%
#'   gt() %>%
#'   cols_label(
#'     x = img_header(
#'       "Luka Doncic",
#'       "https://secure.espn.com/combiner/i?img=/i/headshots/nba/players/full/3945274.png",
#'       height = 60,
#'       font_size = 14
#'     )
#'   )
#' ```
#' @section Figures:
#' \if{html}{\figure{img_header.png}{options: width=80\%}}
#'
#' @family Utilities

img_header <- function(label, img_url, height = 60, font_size = 12,
                       palette = c("black", "black")) {
  html_content <- htmltools::div(
    style = "text-align: center;",
    htmltools::img(
      src = img_url, height = gt::html(gt::px(as.integer(height))),
      style = glue::glue(
        "border-bottom: 2px solid {palette[1]};"
      )
    ),
    htmltools::div(
      style = glue::glue(
        "font-size:{font_size}px;color: {palette[2]};",
        "text-align: center;width:100%;font-weight:bold;"
      ),
      label
    )
  )

  html_content <- as.character(html_content) %>%
    gt::html()
  html_content
}
