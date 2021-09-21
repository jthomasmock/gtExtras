#' Repeat `{fontawesome}` icons based on an integer.
#' @description
#' The `gt_fa_repeats` function takes an existing `gt_tbl` object and
#' adds specific `fontawesome` to the cells. The icons are repeated according to the
#' integer that the column contains.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column wherein the integers should be replaced with `{fontawesome}` icons.
#' @param name A character string indicating the name of the "`fontawesome` icon.
#' @param ... Additional arguments passed to `fontawesome::fa()`
#' @param palette Name of palette as a string. Must be on the form packagename::palettename.
#' @param palette Name of palette as a string. Must be `paletteer` compliant like `"packagename::palettename"` or a vector of valid color names/hex values of equal length to the unique levels of the column (ie if there are 4 names, there need to be 4x colors).
#' @param align Character string indicating alignment of the column, defaults to "left"
#' @param direction The direction of the `paletteer` palette, should be either `-1` for reversed or the default of `1` for the existing direction.
#' @return An object of class `gt_tbl`.
#' @importFrom gt %>%
#' @importFrom fontawesome fa
#' @importFrom paletteer paletteer_d
#' @export
#' @import gt
#' @examples
#'
#' library(gt)
#' fa_cars <- mtcars[1:5,1:4] %>%
#'     head() %>%
#'     gt() %>%
#'     gt_fa_repeats(cyl, name = "car")
#'
#' @section Figures:
#' \if{html}{\figure{fa-cars.png}{options: width=50\%}}
#'
#' @family Utilities
#' @section Function ID:
#' 2-8

gt_fa_repeats <- function(gt_object, column, name = NULL, ...,
                          palette = "ggthemes::colorblind", align = "left",
                          direction = 1){

  stopifnot("Table must be of class 'gt_tbl'" = "gt_tbl" %in% class(gt_object))

  text_transform(
    gt_object,
    locations = cells_body(columns = {{ column }}),
    fn = function(x){
      int_x <- as.integer(x)

      if(isTRUE(unlist(lapply(palette, grepl, pattern = "::")))){
        pal_filler <- paletteer::paletteer_d(
          palette = palette, n = length(unique(x)), type = "discrete",
          direction = direction
        ) %>% as.character()
      } else {
        pal_filler <- palette
      }

      lapply(X = int_x, FUN = function(xy){

        fct_x <- factor(xy, levels = unique(int_x), labels = pal_filler) %>%
          as.character()

        fontawesome::fa(name, ..., fill = fct_x) %>%
          rep(., xy) %>%
          gt::html()
      })
    }
  ) %>%
    cols_align(align = align, columns = {{ column }})

}

#' Add `{fontawesome}` icons inside a `{gt}` column.
#' @description
#' The `gt_fa_column` function takes an existing `gt_tbl` object and
#' adds specific `fontawesome` icons based on what the names in the column are.
#' The icons are colored according to a palette that the user supplies, either
#' a vector of valid colors/hex colors of length equal to the unique levels, or
#' a `paletteer::paletteer_d()` compliant palette like `"ggthemes::colorblind"`.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column wherein the character strings should be replaced with their corresponding `{fontawesome}` icons.
#' @param ... Additional arguments passed to `fontawesome::fa()`
#' @param palette Name of palette as a string. Must be `paletteer` compliant like `"packagename::palettename"` or a vector of valid color names/hex values of equal length to the unique levels of the column (ie if there are 4 names, there need to be 4x colors).
#' @param align Character string indicating alignment of the column, defaults to "left"
#' @param direction The direction of the `paletteer` palette, should be either `-1` for reversed or the default of `1` for the existing direction.

#' @return An object of class `gt_tbl`.
#' @importFrom gt %>%
#' @importFrom paletteer paletteer_d
#' @importFrom fontawesome fa
#' @export
#' @import gt
#' @examples
#'
#' library(gt)
#' fa_cars <- mtcars %>%
#'   head() %>%
#'   dplyr::select(cyl, mpg, am, gear) %>%
#'   dplyr::mutate(man = ifelse(am == 1, "cog", "cogs")) %>%
#'   gt() %>%
#'   gt_fa_column(man)
#'
#' @section Figures:
#' \if{html}{\figure{fa-column-cars.png}{options: width=50\%}}
#'
#' @family Utilities
#' @section Function ID:
#' 2-15

gt_fa_column <- function(gt_object, column, ..., palette = "ggthemes::colorblind",
                         align = "left", direction = 1){

  stopifnot("Table must be of class 'gt_tbl'" = "gt_tbl" %in% class(gt_object))

  text_transform(
    gt_object,
    locations = cells_body(columns = {{ column }}),
    fn = function(x){

      lapply(X = x, FUN = function(xy){

        if(isTRUE(unlist(lapply(palette, grepl, pattern = "::")))){
          pal_filler <- paletteer::paletteer_d(
            palette = palette, n = length(unique(x)), type = "discrete",
            direction = direction
          ) %>% as.character()
        } else {
          pal_filler <- palette
        }

        fct_lvl <- unique(x)
        stopifnot("The length of the unique elements must match the palette length" = length(fct_lvl) == length(pal_filler))

        fct_x <- factor(xy, levels = fct_lvl, labels = pal_filler) %>%
          as.character()

        fontawesome::fa(xy, ..., fill = fct_x) %>% gt::html()
      })
    }
  ) %>%
    cols_align(align = align, columns = {{ column }})

}
