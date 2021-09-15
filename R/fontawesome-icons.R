#' Add `{fontawesome}` icons inside a `{gt}` table.
#' @description
#' The `gt_img_rows` function takes an existing `gt_tbl` object and
#' add specific `fontawesome` to the cells.
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column wherein the integers should be replaced with `{fontawesome}` icons.
#' @param palette Name of palette as a string. Must be on the form packagename::palettename.
#' @param align Character string indicating alignment of the column, defaults to "left"
#' @param name The name of the Font Awesome icon. This could be as a short name (e.g., "npm", "drum", etc.), or, a full name (e.g., "fab fa-npm", "fas fa-drum", etc.). The names should correspond to current Version 5 Font Awesome names. A list of short and full names can be accessed through the fa_metadata() function with fa_metadata()$icon_names and fa_metadata()$icon_names_full. If supplying a Version 4 icon name, it will be internally translated to the Version 5 icon name and a Version 5 icon will be returned. A data frame containing the short names that changed from version 4 (v4_name) to version 5 (v5_name) can be obtained by using fa_metadata()$v4_v5_name_tbl.
#' @param ... Additional arguments passed to `fontawesome::fa()`
#' @return An object of class `gt_tbl`.
#' @importFrom gt %>%
#' @importFrom fontawesome fa
#' @export
#' @import gt
#' @examples
#'
#' library(gt)
#' fa_cars <- mtcars[1:5,1:4] %>%
#'     head() %>%
#'     gt() %>%
#'     gt_add_fa_icons(cyl, name = "car")
#'
#' @section Figures:
#' \if{html}{\figure{fa-cars.png}{options: width=50\%}}
#'
#' @family Utilities
#' @section Function ID:
#' 2-8

gt_add_fa_icons <- function(gt_object, column, name = NULL, ..., palette = "ggthemes::colorblind", align = "left"){

  text_transform(
    gt_object,
    locations = cells_body(columns = {{ column }}),
    fn = function(x){
      int_x <- as.integer(x)

      pal_filler <- paletteer::paletteer_d(
        palette = palette, n = length(unique(int_x)), type = "discrete"
        )

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
