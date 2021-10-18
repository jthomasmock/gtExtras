#' Add a simple table with column names and matching labels
#'
#' @param label A string representing the label for the details expansion section.
#' @param content A named list
#' @importFrom glue glue
#' @importFrom gt %>% html
#'
#' @return HTML text
#' @export
gt_label_details <- function(label, content){

  stopifnot("Must be a named list" = length(names(content)) >= 1)

  build_content <- function(lab_item, content_item){
    glue::glue(
      "<tr><td>{lab_item}</td><td>{content_item}</td></tr>"
    )
  }

  fill_content <- mapply(
    FUN = build_content, names(content), as.character(content),
    SIMPLIFY = FALSE) %>%
    unlist() %>%
    as.character() %>%
    paste0(collapse = "")

  c(glue::glue("<details><summary>{label}</summary>"),
    "<br><table><tr><th>Column</th><th>Description</th>",
    fill_content,
    "</table></details>") %>% paste0(collapse = "") %>%
    as.character() %>%
    gt::html()
}

#' A helper to add basic tooltip inside a gt table
#' @description This is a lightweight helper to add tooltip, tyoically to be
#' used within `gt::cols_label()`.
#' @param label The label for the item with a tooltip
#' @param tooltip The text based tooltip for the item
#'
#' @return HTML text
#' @export
#' @import htmltools
#' @importFrom gt %>% html
with_tooltip <- function(label, tooltip) {
  tags$abbr(style = paste0(
    "text-decoration: underline; text-decoration-style: solid;","
    cursor: question; color: blue"),
    title = tooltip, label) %>%
    as.character() %>%
    gt::html()
    }


#' Add a basic hyperlink in a gt table
#' @description A lightweight helper to add a hyperlink, can be used throughout
#' a `gt` table.
#' @param text The text displayed for the hyperlink
#' @param url The url for the hyperlink
#' @importFrom gt %>% html
#' @import htmltools
#' @return HTML text
#' @export
gt_hyperlink <- function(text, url){
  htmltools::a(href = url, text, target = "_blank") %>%
    as.character() %>%
    gt::html()
}
