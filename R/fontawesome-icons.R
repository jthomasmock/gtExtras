# #' Repeat `{fontawesome}` icons based on an integer.
# #' @description
# #' `r lifecycle::badge("deprecated")`
# #' This function was deprecated because `gt` now has it's own robust `gt::fmt_icon()` function.
# #'
# #' The `gt_fa_repeats` function takes an existing `gt_tbl` object and
# #' adds specific `fontawesome` to the cells. The icons are repeated according to the
# #' integer that the column contains.
# #'
# #' @param gt_object An existing gt table object of class `gt_tbl`
# #' @param column The column wherein the integers should be replaced with `{fontawesome}` icons.
# #' @param name A character string indicating the name of the "`fontawesome` icon.
# #' @param ... Additional arguments passed to `fontawesome::fa()`
# #' @param palette Name of palette as a string. Must be either length of 1 or a vector of valid color names/hex values of equal length to the unique levels of the column (ie if there are 4 names, there need to be 4x colors).
# #' @param align Character string indicating alignment of the column, defaults to "left"
# #' @param direction The direction of the `paletteer` palette, should be either `-1` for reversed or the default of `1` for the existing direction.
# #' @return An object of class `gt_tbl`.
# #' @export
# #' @section Examples:
# #' ```r
# #' library(gt)
# #' mtcars[1:5, 1:4] %>%
# #'   gt() %>%
# #'   gt_fa_repeats(cyl, name = "car")
# #' ```
# #' @section Figures:
# #' \if{html}{\figure{fa-cars.png}{options: width=50\%}}
# #'
# #' @family Utilities
# #' @section Function ID:
# #' 2-8

# gt_fa_repeats <- function(gt_object, column, name = NULL, ...,
#                           palette = NULL, align = "left",
#                           direction = 1) {
#   stopifnot("Table must be of class 'gt_tbl'" = "gt_tbl" %in% class(gt_object))

#   lifecycle::deprecate_warn("0.5.1", "gt_fa_repeats()", "gt::fmt_icon()")

#   text_transform(
#     gt_object,
#     locations = cells_body(columns = {{ column }}),
#     fn = function(x) {
#       int_conv <- suppressWarnings(as.integer(x))
#       int_x <- int_conv[!is.na(int_conv)]

#       if (is.null(palette) && length(unique(int_x)) >= 8) {
#         stop("Please add your own palette that is equal to the number of unique counts", call. = FALSE)
#       }

#       if (is.null(palette)) {
#         pal_filler <- rev(c(
#           "#CC79A7", "#D55E00", "#0072B2",
#           "#F0E442", "#009E73", "#56B4E9",
#           "#E69F00", "#000000"
#         ))[seq_along(unique(int_x))]
#       } else if (length(palette) == 1) {
#         pal_filler <- palette %>% rep(length(unique(int_x)))
#       } else {
#         pal_filler <- palette
#       }

#       lapply(X = int_conv, FUN = function(xy) {
#         # handle missing values
#         if (is_blank(xy) || is.na(xy)) {
#           return(gt::html("&nbsp;"))
#         }

#         fct_x <- factor(xy, levels = unique(int_x), labels = pal_filler) %>%
#           as.character()

#         fct_lvl <- suppressWarnings(unique(x[!is.na(as.integer(x))]))

#         stopifnot("The length of the unique elements must match the palette length" = length(fct_lvl) == length(pal_filler))

#         fa_repeats <- fontawesome::fa(name, ..., fill = fct_x, height = "20px", a11y = "sem") %>%
#           as.character() %>%
#           rep(., xy) %>%
#           gt::html()

#         label <- paste(xy, name)

#         htmltools::div(
#           title = label, "aria-label" = label, role = "img",
#           list(fa_repeats)
#         )
#       })
#     }
#   ) %>%
#     cols_align(align = align, columns = {{ column }})
# }

# #' Add `{fontawesome}` icons inside a `{gt}` column.
# #' @description
# #' `r lifecycle::badge("deprecated")`
# #' This function was deprecated because `gt` now has it's own robust `gt::fmt_icon()` function.
# #'
# #' The `gt_fa_column` function takes an existing `gt_tbl` object and
# #' adds specific `fontawesome` icons based on what the names in the column are.
# #' The icons are colored according to a palette that the user supplies, either
# #' a vector of valid colors/hex colors of length equal to the unique levels.
# #'
# #' @param gt_object An existing gt table object of class `gt_tbl`
# #' @param column The column wherein the character strings should be replaced with their corresponding `{fontawesome}` icons.
# #' @param ... Additional arguments passed to `fontawesome::fa()`
# #' @param palette Name of palette as a string. Must be either length of 1 or a vector of valid color names/hex values of equal length to the unique levels of the column (ie if there are 4 names, there need to be 4x colors). Note that if you would like to specify a specific color to match a specific icon, you can also use a named vector like: `c("angle-double-up" = "#009E73", "angle-double-down" = "#D55E00","sort" = "#000000")`
# #' @param align Character string indicating alignment of the column, defaults to "left"
# #' @param direction The direction of the `paletteer` palette, should be either `-1` for reversed or the default of `1` for the existing direction.
# #' @param height A character string indicating the height of the icon, defaults to "20px"
# #' @return An object of class `gt_tbl`.
# #' @export
# #' @section Examples:
# #' ```r
# #' library(gt)
# #' fa_cars <- mtcars %>%
# #'   head() %>%
# #'   dplyr::select(cyl, mpg, am, gear) %>%
# #'   dplyr::mutate(man = ifelse(am == 1, "gear", "gears")) %>%
# #'   gt() %>%
# #'   gt_fa_column(man)
# #' ```
# #' @section Figures:
# #' \if{html}{\figure{fa-column-cars.png}{options: width=50\%}}
# #'
# #' @family Utilities
# #' @section Function ID:
# #' 2-15

# gt_fa_column <- function(gt_object, column, ..., palette = NULL,
#                          align = "left", direction = 1, height = "20px") {
#   stopifnot("Table must be of class 'gt_tbl'" = "gt_tbl" %in% class(gt_object))
#   lifecycle::deprecate_warn("0.5.1", "gt_fa_column()", "gt::fmt_icon()")

#   text_transform(
#     gt_object,
#     locations = cells_body(columns = {{ column }}),
#     fn = function(x) {

#       if (is.null(palette)) {
#         # if no palette use categorical colorblind palette
#         pal_filler <- c(
#           "#000000", "#E69F00", "#56B4E9", "#009E73",
#           "#F0E442", "#0072B2", "#D55E00", "#CC79A7"
#         )[seq_along(unique(x[!(x %in% c("", "NA", NA))]))]
#         # if single color, then repeat to match length
#       } else if (length(palette) == 1) {
#         pal_filler <- palette %>% rep(length(unique(x)))
#       } else if (all(unique(x) %in% names(palette))) {
#         pal_no_missing <- x[!x %in% c("", "NA", NA, "NULL", NULL)]
#         # palette is superset of values,
#         # so reduce palette to just what's needed
#         pal_filler <- palette[unique(pal_no_missing)]
#       } else {
#         # palette is the palette
#         pal_filler <- palette
#       }

#       # pass arguments into anonymous function
#       lapply(X = x, FUN = function(xy) {
#         if (xy %in% c("", "NA", NA, NULL, "NULL")) {
#           return(gt::html("&nbsp;"))
#         }

#         # drop missing levels
#         x <- x[!(x %in% c("", "NA", NA, NULL, "NULL"))]

#         fct_lvl <- unique(x)
#         # TODO revisit if a useful check, since I'm dropping missing vals
#         # stopifnot(
#         #   "The length of the unique elements must match the palette length" =
#         #     length(fct_lvl) == length(as.vector(na.omit(pal_filler)))
#         #   )

#         if (!is.null(names(pal_filler))) {
#           fct_x <- factor(xy, levels = names(pal_filler), labels = pal_filler) %>%
#             as.character()
#         } else {
#           fct_x <- factor(xy, levels = fct_lvl, labels = pal_filler) %>%
#             as.character()
#         }

#         # conditional to return blanks if the passed element
#         # is missing, NA, NULL, or blank
#         if (!nzchar(xy) || is_blank(xy)) {
#           gt::html("&nbsp;")
#         } else {
#           my_fa <- list(
#             fontawesome::fa(xy, ...,
#               fill = fct_x,
#               height = height, a11y = "sem"
#             ) %>% gt::html()
#           )
#           htmltools::div(
#             title = xy, "aria-label" = xy, role = "img",
#             my_fa, style = "padding:0px"
#           )
#         }
#       })
#     }
#   ) %>%
#     cols_align(align = align, columns = {{ column }})
# }

#' Add rating "stars" to a gt column
#'
#' @param gt_object An existing gt table object of class `gt_tbl`
#' @param column The column wherein the numeric values should be replaced with their corresponding `{fontawesome}` icons.
#' @param max_rating The max number of icons to add, these will be added in grey to indicate "missing"
#' @param ... Additional arguments passed to `fontawesome::fa()`
#' @param color The color of the icon, accepts named colors (`"orange"`) or hex strings.
#' @param icon The icon name, passed to `fontawesome::fa()`
#'
#' @return An object of class `gt_tbl`.
#' @export
#'
#' @section Examples:
#' ```r
#' library(gt)
#' set.seed(37)
#' rating_table <- mtcars %>%
#'   dplyr::select(mpg:wt) %>%
#'   dplyr::slice(1:5) %>%
#'   dplyr::mutate(rating = sample(1:5, size = 5, TRUE)) %>%
#'   gt() %>%
#'   gt_fa_rating(rating, icon = "r-project")
#' ```
#' @section Figures:
#' \if{html}{\figure{fa-stars.png}{options: width=60\%}}
#'
#' @family Utilities
#' @section Function ID:
#' 2-16

gt_fa_rating <- function(
  gt_object,
  column,
  max_rating = 5,
  ...,
  color = "orange",
  icon = "star"
) {
  stopifnot("Table must be of class 'gt_tbl'" = "gt_tbl" %in% class(gt_object))

  text_transform(
    gt_object,
    locations = cells_body(columns = {{ column }}),
    fn = function(x) {
      # convert the raw text to numeric
      num_x <- suppressWarnings(as.numeric(x))

      lapply(X = num_x, FUN = function(rating) {
        # handle missing values & return a blank space if missing
        if (is_blank(rating) || rating %in% c(NA, "NA", "")) {
          return(gt::html("&nbsp;"))
        }
        # adapted from: glin.github.io/reactable/articles/cookbook/cookbook.html#rating-stars
        rounded_rating <- floor(rating + 0.5) # always round up
        stars <- lapply(seq_len(max_rating), function(i) {
          if (i <= rounded_rating) {
            fontawesome::fa(icon, fill = color, height = "20px", a11y = "sem")
          } else {
            fontawesome::fa(icon, fill = "grey", height = "20px", a11y = "sem")
          }
        })
        label <- sprintf("%s out of %s", rating, max_rating)
        div_out <- htmltools::div(
          title = label,
          "aria-label" = label,
          role = "img",
          stars,
          style = "padding:0px"
        )

        # need to convert from text to html
        as.character(div_out) %>%
          gt::html()
      })
    }
  ) %>%
    cols_align(align = "left", columns = {{ column }})
}

#' Add rank change indicators to a gt table
#' @description Takes an existing `gt` table and converts a column of integers
#' into various types of up/down arrows. Note that you need to specify a palette
#' of three colors, in the order of up, neutral, down. Defaults to green, grey,
#' purple. There are 6 supported `fa_type`, representing various arrows.
#' Note that you can use `font_color = 'match'` to match the palette across
#' arrows and text. `show_text = FALSE` will remove the text from the column,
#' resulting only in colored arrows.
#' @param gt_object An existing `gt` table object
#' @param column The single column that you would like to convert to rank change indicators.
#' @param palette A character vector of length 3. Colors can be represented as hex values or named colors. Colors should be in the order of up-arrow, no-change, down-arrow, defaults to green, grey, purple.
#' @param fa_type The name of the Fontawesome icon, limited to 5 types of various arrows, one of `c("angles", "arrow", "turn", "chevron", "caret")`
#' @param font_color A string, indicating the color of the font, can also be returned as `'match'` to match the font color to the arrow palette.
#' @param show_text A logical indicating whether to show/hide the values in the column.
#' @return a `gt` table
#' @export
#'
#' @section Examples:
#' ```r
#' rank_table <- dplyr::tibble(x = c(1:3, -1, -2, -5, 0)) %>%
#'   gt::gt() %>%
#'   gt_fa_rank_change(x, font_color = "match")
#' ```
#' @section Figures:
#' \if{html}{\figure{fa_rank_change.png}{options: width=5\%}}
#'
#' @family Utilities
gt_fa_rank_change <- function(
  gt_object,
  column,
  palette = c("#1b7837", "lightgrey", "#762a83"),
  fa_type = c("angles", "arrow", "turn", "chevron", "caret"),
  font_color = "black",
  show_text = TRUE
) {
  vals <- gt_index(gt_object, {{ column }})

  stopifnot("Column must be integers" = is.integer(as.integer(vals)))
  stopifnot(
    "Palette must be length 3, in order of increase, no change, decrease" = length(
      palette
    ) ==
      3
  )
  stopifnot(
    'fa_type must be one of "angles", "arrow", "turn", "chevron", "caret"' = fa_type %in%
      c("angles", "arrow", "turn", "chevron", "caret")
  )

  # internal function
  # could possibly pull out to standalone function
  fa_rank_chg <- function(fa_name, color, font_color, text) {
    if (font_color == "match") {
      font_color <- color
    }

    if (is_blank(text) || is_blank(fa_name)) {
      return(gt::html("<bold style='color:#d3d3d3;'>--</bold>"))
    } else if (!nzchar(text) & !is_blank(text)) {
      fa_height <- "20px"
    } else if (nzchar(text) & !is_blank(text)) {
      fa_height <- "12px"
    }

    # fill the Fontawesome call
    my_fa <- list(
      fontawesome::fa(
        name = fa_name,
        fill = color,
        height = fa_height,
        a11y = "sem"
      ) %>%
        gt::html()
    )

    # hardcode some HTML/CSS styling
    htmltools::div(
      "aria-label" = text,
      role = "img",
      htmltools::div(my_fa, style = "float: left;margin-right:1px;"),
      htmltools::div(text, style = "float:right;"),
      style = glue::glue(
        "padding:0px;display:inline;color:{font_color};font-weight:bold;font-size:12px;"
      )
    ) %>%
      as.character() %>%
      gt::html()
  }

  gt_object %>%
    text_transform(
      locations = cells_body({{ column }}),
      fn = function(x) {
        vals <- gt_index(gt_object, {{ column }})

        color_vals <- dplyr::case_when(
          vals > 0 ~ palette[1],
          vals == 0 ~ palette[2],
          vals < 0 ~ palette[3],
          TRUE ~ palette[2]
        )

        if (fa_type[1] == "level") {
          fa_vals <- dplyr::case_when(
            vals > 0 ~ "level-up-alt",
            vals < 0 ~ "level-down-alt",
            vals == 0 ~ "equals",
            TRUE ~ "question"
          )
        } else {
          fa_vals <- dplyr::case_when(
            vals > 0 ~ paste0(fa_type[1], "-up"),
            vals == 0 ~ "equals",
            vals < 0 ~ paste0(fa_type[1], "-down")
          )
        }

        if (isFALSE(show_text)) {
          vals <- ""
        }

        mapply(
          fa_rank_chg,
          fa_vals,
          color_vals,
          font_color,
          vals,
          SIMPLIFY = FALSE
        )
      }
    )
}
