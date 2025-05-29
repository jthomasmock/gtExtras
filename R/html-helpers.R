#' Add a simple table with column names and matching labels
#'
#' @param label A string representing the label for the details expansion section.
#' @param content A named list or wide data.frame with 2 rows
#' @param names a string indicating the name of the two columns inside the details tag
#' @return HTML text
#' @export
gt_label_details <- function(
  label,
  content,
  names = c("Column", "Description")
) {
  stopifnot("Must be a named list" = length(names(content)) >= 1)
  stopifnot("'names' must be length 2" = length(names) == 2)

  build_content <- function(lab_item, content_item) {
    glue::glue(
      "<tr><td>{lab_item}</td><td>{content_item}</td></tr>"
    )
  }

  fill_content <- mapply(
    FUN = build_content,
    names(content),
    as.character(content),
    SIMPLIFY = FALSE
  ) %>%
    unlist() %>%
    as.character() %>%
    paste0(collapse = "")

  c(
    glue::glue("<details><summary>{label}</summary>"),
    glue::glue("<br><table><tr><th>{names[1]}</th><th>{names[2]}</th>"),
    fill_content,
    "</table></details>"
  ) %>%
    paste0(collapse = "") %>%
    as.character() %>%
    gt::html()
}

#' A helper to add basic tooltip inside a gt table
#' @description This is a lightweight helper to add tooltip, typically to be
#' used within `gt::cols_label()`.
#' @param label The label for the item with a tooltip
#' @param tooltip The text based tooltip for the item
#'
#' @return HTML text
#' @export
with_tooltip <- function(label, tooltip) {
  tags$abbr(
    style = paste0(
      "text-decoration: underline; text-decoration-style: solid;",
      "
    cursor: question; color: blue"
    ),
    title = tooltip,
    label
  ) %>%
    as.character() %>%
    gt::html()
}


#' Add a basic hyperlink in a gt table
#' @description A lightweight helper to add a hyperlink, can be used throughout
#' a `gt` table.
#' @param text The text displayed for the hyperlink
#' @param url The url for the hyperlink
#' @return HTML text
#' @export
gt_hyperlink <- function(text, url) {
  htmltools::a(href = url, text, target = "_blank") %>%
    as.character() %>%
    gt::html()
}

#' Add badge color
#'
#' @param add_color A color to add to the badge
#' @param add_label The label to add to the badge
#' @param alpha_lvl The alpha level
#'
#' @return HTML character
#'
add_badge_color <- function(add_color, add_label, alpha_lvl) {
  add_color <- paste0("background:", scales::alpha(add_color, alpha_lvl), ";")

  div_out <- htmltools::div(
    style = paste(
      "display: inline-block; padding: 2px 12px; border-radius: 15px;",
      "font-weight: 600; font-size: 12px;",
      add_color
    ),
    add_label
  )

  as.character(div_out) %>%
    gt::html()
}

#' Add a 'badge' based on values and palette
#' @param gt_object An existing `gt` table object
#' @param column The column to convert to badges, accepts `tidyeval`
#' @param palette Name of palette as a string. Must be either length of 1 or a vector of valid color names/hex values of equal length to the unique levels of the column (ie if there are 4 names, there need to be 4x colors). Note that if you would like to specify a specific color to match a specific icon, you can also use a named vector like: `c("angle-double-up" = "#009E73", "angle-double-down" = "#D55E00","sort" = "#000000")`
#' @param alpha A numeric indicating the alpha/transparency. Range from 0 to 1
#' @param rows The rows to apply the badge to, accepts `tidyeval`. Defaults to all rows.
#' @export
#' @return `gt` table
#' @section Examples:
#' ```r
#' library(gt)
#' head(mtcars) %>%
#'   dplyr::mutate(cyl = paste(cyl, "Cyl")) %>%
#'   gt() %>%
#'   gt_badge(cyl, palette = c("4 Cyl"="red","6 Cyl"="blue","8 Cyl"="green"))
#' ```
#' @section Figures:
#' \if{html}{\figure{gt_badge.png}{options: width=50\%}}
#'
#' @family Utilities
gt_badge <- function(
  gt_object,
  column,
  palette = NULL,
  alpha = 0.2,
  rows = gt::everything()
) {
  stopifnot("Table must be of class 'gt_tbl'" = "gt_tbl" %in% class(gt_object))

  text_transform(
    gt_object,
    locations = cells_body(
      columns = {{ column }},
      rows = {{ rows }}
    ),
    fn = function(x) {
      if (is.null(palette)) {
        pal_filler <- rev(c(
          "#CC79A7",
          "#D55E00",
          "#0072B2",
          "#F0E442",
          "#009E73",
          "#56B4E9",
          "#E69F00",
          "#000000"
        ))[seq_along(unique(x))]
      } else if (length(palette) == 1) {
        pal_filler <- palette %>% rep(length(unique(x)))
      } else {
        pal_filler <- palette
      }

      #

      lapply(X = x, FUN = function(xy) {
        fct_lvl <- unique(x)
        stopifnot(
          "The length of the unique elements must match the palette length" = length(
            fct_lvl
          ) ==
            length(pal_filler)
        )

        if (!is.null(names(pal_filler))) {
          fct_x <- factor(
            xy,
            levels = names(pal_filler),
            labels = pal_filler
          ) %>%
            as.character()
        } else {
          fct_x <- factor(xy, levels = fct_lvl, labels = pal_filler) %>%
            as.character()
        }

        add_badge_color(fct_x, xy, alpha_lvl = alpha)
      })
    }
  )
}
