#' Create a circular border around a
#'
#' @param value The source image
#' @param height The height in pixels of the circle
#' @param border_color A string indicating the color of the border
#' @param border_weight The weight of the border in pixels
#'
#' @return HTML

img_circle <- function(value, height, border_color, border_weight) {
  image <- htmltools::div(
    style = glue::glue(
      "background-image: url({value});background-size:cover;",
      "background-position:center;",
      "border: {border_weight}px solid {border_color};",
      "border-radius: 50%;height:{height}px;width:100%;"
    )
  )

  image
}

#' Create circular border around an image
#'
#' @param gt_object An existing gt object
#' @param column The column to apply the transformation to
#' @param height A number indicating the height of the image in pixels.
#' @param border_color The color of the circular border, can either be a single value ie (`white` or `#FF0000`) or a vector where the lenght of the vector is equal to the number of rows.
#' @param border_weight A number indicating the weight of the border in pixels.
#' @return a gt object
#' @export
#'
#' @section Examples:
#' library(gt)
#' gt_img_tab <- dplyr::tibble(
#'   x = 1:4,
#'   names = c("Rich Iannone",  "Katie Masiello", "Tom Mock","Hadley Wickham"),
#'   img = c(
#'      "https://pbs.twimg.com/profile_images/961326215792533504/Ih6EsvtF_400x400.jpg",
#'      "https://pbs.twimg.com/profile_images/1471188460220260354/rHhoIXkZ_400x400.jpg",
#'      "https://pbs.twimg.com/profile_images/1467219661121064965/Lfondr9M_400x400.jpg",
#'      "https://pbs.twimg.com/profile_images/905186381995147264/7zKAG5sY_400x400.jpg"
#'   )
#' ) %>%
#'   gt() %>%
#'   gt_img_circle(img)
#' @section Figures:
#' \if{html}{\figure{gt_img_circle.png}{options: width=80\%}}
#'
#' @family Utilities
#' @section Function ID:
#' 2-15
gt_img_circle <- function(gt_object, column, height = 25,
                            border_color = "black", border_weight = 1.5){

  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = "gt_tbl" %in% class(gt_object))

  gt_object %>%
    text_transform(
      locations = cells_body({{column}}),
      fn = function(value){
        mapply(img_circle, value, height, border_color,
               border_weight, SIMPLIFY = FALSE)
      }
    )
}
