# gt internal functions vendored with attribution from:

### ----
### https://github.com/rstudio/gt/blob/fcabb414c55b70c9e445fbedfb24d52fe394ba61/R/dt_boxhead.R

.dt_boxhead_key <- "_boxhead"

dt_boxhead_get <- function(data) {
  dt__get(data, .dt_boxhead_key)
}

dt_boxhead_set <- function(data, boxh) {
  dt__set(data, .dt_boxhead_key, boxh)
}

dt_boxhead_init <- function(data) {
  vars <- colnames(dt_data_get(data = data))

  empty_list <- lapply(seq_along(vars), function(x) NULL)

  boxh_df <-
    dplyr::tibble(
      # Matches to the name of the `data` column
      var = vars,
      # The mode of the column in the rendered table
      # - `default` appears as a column with values below
      # - `stub` appears as part of a table stub, set to the left
      #   and styled differently
      # - `row_group` uses values as categoricals and groups rows
      #   under row group headings
      # - `hidden` hides this column from the final table render
      #   but retains values to use in expressions
      # - `hidden_at_px` similar to hidden but takes a list of
      #   screen widths (in px) whereby the column would be hidden
      type = "default",
      # # The shared spanner label between columns, where column names
      # # act as the keys
      # spanner_label = empty_list,
      # # The label for row groups, which is maintained as a list of
      # # labels by render context (e.g., HTML, LaTeX, etc.)
      # row_group_label = lapply(seq_along(names(data)), function(x) NULL),
      # The presentation label, which is a list of labels by
      # render context (e.g., HTML, LaTeX, etc.)
      column_label = as.list(vars),
      # The alignment of the column ("left", "right", "center")
      column_align = "center",
      # The width of the column in `px`
      column_width = empty_list,
      # The widths at which the column disappears from view (this is
      # HTML specific)
      hidden_px = empty_list
    )

  boxh_df %>% dt_boxhead_set(boxh = ., data = data)
}

dt_boxhead_edit <- function(data, var, ...) {

  dt_boxhead <- dt_boxhead_get(data = data)

  var_name <- var

  val_list <- list(...)

  if (length(val_list) != 1) {
    cli::cli_abort("`dt_boxhead_edit()` expects a single value at `...`.")
  }

  check_names_dt_boxhead_expr(expr = val_list)

  check_vars_dt_boxhead(var = var, dt_boxhead = dt_boxhead)

  if (is.list(dt_boxhead[[names(val_list)]])) {
    dt_boxhead[[which(dt_boxhead$var == var_name), names(val_list)]] <- unname(val_list)
  } else {
    dt_boxhead[[which(dt_boxhead$var == var_name), names(val_list)]] <- unlist(val_list)
  }

  dt_boxhead_set(data = data, boxh = dt_boxhead)
}

dt_boxhead_add_var <- function(data,
                               var,
                               type,
                               column_label = list(var),
                               column_align = "left",
                               column_width = list(NULL),
                               hidden_px = list(NULL),
                               add_where = "top") {
  dt_boxhead <- data %>% dt_boxhead_get()

  dt_boxhead_row <-
    dplyr::tibble(
      var = var,
      type = type,
      column_label = column_label,
      column_align = column_align,
      column_width = column_width,
      hidden_px = hidden_px
    )

  if (add_where == "top") {
    dt_boxhead <- dplyr::bind_rows(dt_boxhead_row, dt_boxhead)
  } else if (add_where == "bottom") {
    dt_boxhead <- dplyr::bind_rows(dt_boxhead, dt_boxhead_row)
  } else {
    stop("The `add_where` value must be either `top` or `bottom`.")
  }

  dt_boxhead %>% dt_boxhead_set(data = data)
}

dt_boxhead_set_hidden <- function(data, vars) {
  dt_boxhead <- dt_boxhead_get(data = data)

  dt_boxhead[which(dt_boxhead$var %in% vars), "type"] <- "hidden"
  dt_boxhead %>% dt_boxhead_set(data = data)
}

dt_boxhead_set_not_hidden <- function(data, vars) {
  dt_boxhead <- dt_boxhead_get(data = data)

  dt_boxhead[which(dt_boxhead$var %in% vars), "type"] <- "default"
  dt_boxhead %>% dt_boxhead_set(data = data)
}

dt_boxhead_set_stub <- function(data, var) {
  dt_boxhead <- dt_boxhead_get(data = data)

  dt_boxhead[which(dt_boxhead$var == var), "type"] <- "stub"
  dt_boxhead[which(dt_boxhead$var == var), "column_align"] <- "left"
  dt_boxhead %>% dt_boxhead_set(data = data)
}

dt_boxhead_set_row_group <- function(data, vars) {
  dt_boxhead <- dt_boxhead_get(data = data)

  dt_boxhead[which(dt_boxhead$var %in% vars), "type"] <- "row_group"
  dt_boxhead[which(dt_boxhead$var %in% vars), "column_align"] <- "left"
  dt_boxhead %>% dt_boxhead_set(data = data)
}

dt_boxhead_edit_column_label <- function(data, var, column_label) {
  dt_boxhead_edit(
    data = data,
    var = var,
    column_label = column_label
  )
}

dt_boxhead_get_vars <- function(data) {
  dplyr::pull(dt_boxhead_get(data = data), var)
}

dt_boxhead_get_vars_default <- function(data) {
  dplyr::pull(subset(dt_boxhead_get(data = data), type == "default"), var)
}

dt_boxhead_get_var_stub <- function(data) {
  res <- dt_boxhead_get_var_by_type(data = data, type = "stub")
  # FIXME: don't return NA_character_ here, just return res or NULL
  if (length(res) == 0) {
    NA_character_
  } else {
    res
  }
}

dt_boxhead_get_vars_groups <- function(data) {
  res <- dt_boxhead_get_var_by_type(data = data, type = "row_group")
  # FIXME: don't return NA_character_ here, just return res or NULL
  if (length(res) == 0) {
    NA_character_
  } else {
    res
  }
}

dt_boxhead_get_var_by_type <- function(data, type) {
  dplyr::filter(dt_boxhead_get(data = data), type == !!type) %>%
    magrittr::extract2("var")
}

dt_boxhead_get_vars_labels_default <- function(data) {
  unlist(
    subset(dt_boxhead_get(data = data), type == "default") %>%
      magrittr::extract2("column_label")
  )
}

dt_boxhead_get_vars_align_default <- function(data) {
  unlist(
    subset(dt_boxhead_get(data = data), type == "default") %>%
      magrittr::extract2("column_align")
  )
}

dt_boxhead_get_alignment_by_var <- function(data, var) {
  data %>%
    dt_boxhead_get() %>%
    dplyr::filter(var == !!var) %>%
    magrittr::extract2("column_align")
}

check_names_dt_boxhead_expr <- function(expr) {
  if (!all(names(expr) %in% c(
    "type", "column_label", "column_align", "column_width", "hidden_px"
  ))) {
    stop("Expressions must use names available in `dt_boxhead`.",
      call. = FALSE
    )
  }
}

check_vars_dt_boxhead <- function(var, dt_boxhead) {
  if (!(var %in% dt_boxhead$var)) {
    stop("The `var` value must be value in `dt_boxhead$var`.",
      call. = FALSE
    )
  }
}

dt_boxhead_build <- function(data, context) {
  boxh <- dt_boxhead_get(data = data)

  boxh$column_label <-
    lapply(boxh$column_label, function(label) process_text(label, context))

  data <- dt_boxhead_set(data = data, boxh = boxh)

  data
}

dt_boxhead_set_var_order <- function(data, vars) {
  boxh <- dt_boxhead_get(data = data)

  if (length(vars) != nrow(boxh) ||
    length(unique(vars)) != nrow(boxh) ||
    !all(vars %in% boxh$var)
  ) {
    stop("The length of `vars` must be the same the number of rows in `_boxh.")
  }

  order_vars <- vapply(vars, function(x) {
    which(boxh$var == x)
  }, numeric(1))

  boxh <- boxh[order_vars, ]

  data <- dt_boxhead_set(data = data, boxh = boxh)

  data
}


### ----
### https://github.com/rstudio/gt/blob/81694d4c2c9c6cebaea005f04feddda5763fccec/R/export.R

gt_save_html <- function(data,
                         filename,
                         path = NULL,
                         ...,
                         inline_css = FALSE) {
  filename <- gtsave_filename(path = path, filename = filename)

  if (inline_css) {
    data %>%
      as_raw_html(inline_css = inline_css) %>%
      htmltools::HTML() %>%
      htmltools::save_html(filename, ...)
  } else {
    data %>%
      htmltools::as.tags() %>%
      htmltools::save_html(filename, ...)
  }
}

gtsave_filename <- function(path, filename) {
  if (is.null(path)) path <- "."

  # The use of `fs::path_abs()` works around
  # the saving code in `htmltools::save_html()`
  # See htmltools Issue #165 for more details

  fs::path_abs(
    path = filename,
    start = path
  ) %>%
    fs::path_expand() %>%
    as.character()
}

## ----
###

is_html <- function(x) {
  inherits(x, "html") && isTRUE(attr(x, "html"))
}

## ----
### https://github.com/rstudio/gt/blob/ec97f7385166946d7a964ef31b7f6508ccd56550/R/resolver.R

resolve_cols_c <- function(expr,
                           data,
                           strict = TRUE,
                           excl_stub = TRUE,
                           null_means = c("everything", "nothing")) {
  null_means <- match.arg(null_means)

  names(
    resolve_cols_i(
      expr = {{ expr }},
      data = data,
      strict = strict,
      excl_stub = excl_stub,
      null_means = null_means
    )
  )
}

## ----
### https://github.com/rstudio/gt/blob/3241b1e6ed53670fbce0361b999b929b4df8df83/R/utils.R

utf8_aware_sub <- NULL

.onLoad <- function(libname, pkgname, ...) {
  op <- options()
  toset <- !(names(gt_default_options) %in% names(op))

  if (any(toset)) options(gt_default_options[toset])

  utf8_aware_sub <<- identical("UTF-8", Encoding(sub(".", "\u00B1", ".", fixed = TRUE)))

  invisible()
}

markdown_to_latex <- function(text) {
  # Vectorize `commonmark::markdown_latex` and modify output
  # behavior to passthrough NAs
  lapply(text, function(x) {
    if (is.na(x)) {
      return(NA_character_)
    }

    if (isTRUE(getOption("gt.html_tag_check", TRUE))) {
      if (grepl("<[a-zA-Z\\/][^>]*>", x)) {
        warning("HTML tags found, and they will be removed.\n",
          " * set `options(gt.html_tag_check = FALSE)` to disable this check",
          call. = FALSE
        )
      }
    }

    commonmark::markdown_latex(x) %>% tidy_gsub("\\n$", "")
  }) %>%
    unlist() %>%
    unname()
}

markdown_to_rtf <- function(text) {
  text <-
    text %>%
    as.character() %>%
    vapply(
      FUN.VALUE = character(1),
      USE.NAMES = FALSE,
      FUN = commonmark::markdown_xml
    ) %>%
    vapply(
      FUN.VALUE = character(1),
      USE.NAMES = FALSE,
      FUN = function(cmark) {
        # cat(cmark)
        x <- xml2::read_xml(cmark)
        if (!identical(xml2::xml_name(x), "document")) {
          stop("Unexpected result from markdown parsing: `document` element not found")
        }

        children <- xml2::xml_children(x)
        if (length(children) == 1 &&
          xml2::xml_type(children[[1]]) == "element" &&
          xml2::xml_name(children[[1]]) == "paragraph") {
          children <- xml2::xml_children(children[[1]])
        }

        apply_rules <- function(x) {
          if (inherits(x, "xml_nodeset")) {
            len <- length(x)
            results <- character(len) # preallocate vector
            for (i in seq_len(len)) {
              results[[i]] <- apply_rules(x[[i]])
            }
            # TODO: is collapse = "" correct?
            rtf_raw(paste0("", results, collapse = ""))
          } else {
            output <- if (xml2::xml_type(x) == "element") {
              rule <- cmark_rules[[xml2::xml_name(x)]]
              if (is.null(rule)) {
                rlang::warn(
                  paste0("Unknown commonmark element encountered: ", xml2::xml_name(x)),
                  .frequency = "once",
                  .frequency_id = "gt_commonmark_unknown_element"
                )
                apply_rules(xml2::xml_contents(x))
              } else if (is.character(rule)) {
                rtf_wrap(rule, x, apply_rules)
              } else if (is.function(rule)) {
                rule(x, apply_rules)
              }
            }
            if (!is_rtf(output)) {
              warning("Rule for ", xml2::xml_name(x), " did not return RTF")
            }
            # TODO: is collapse = "" correct?
            rtf_raw(paste0("", output, collapse = ""))
          }
        }

        apply_rules(children)
      }
    )

  text
}

markdown_to_text <- function(text) {
  # Vectorize `commonmark::markdown_text` and modify output
  # behavior to passthrough NAs
  lapply(text, function(x) {
    if (is.na(x)) {
      return(NA_character_)
    }

    if (isTRUE(getOption("gt.html_tag_check", TRUE))) {
      if (grepl("<[a-zA-Z\\/][^>]*>", x)) {
        warning("HTML tags found, and they will be removed.\n",
          " * set `options(gt.html_tag_check = FALSE)` to disable this check",
          call. = FALSE
        )
      }
    }

    commonmark::markdown_text(x) %>% tidy_gsub("\\n$", "")
  }) %>%
    unlist() %>%
    unname()
}

# https://github.com/rstudio/gt/blob/ec97f7385166946d7a964ef31b7f6508ccd56550/R/zzz.R

gt_default_options <- list(
  gt.row_group.sep = " - ",
  gt.rtf_page_width = 9468L,
  gt.html_tag_check = TRUE
)

tidy_gsub <- function(x, pattern, replacement, fixed = FALSE) {
  if (!utf8_aware_sub) {
    # See variable definition for utf8_aware_sub for more info
    x <- enc2utf8(as.character(x))
    replacement <- enc2utf8(as.character(replacement))

    res <- gsub(pattern, replacement, x, fixed = fixed)
    Encoding(res) <- "UTF-8"
    res
  } else {
    gsub(pattern, replacement, x, fixed = fixed)
  }
}

#' Process text based on rendering context any applied classes
#'
#' If the incoming text has the class `from_markdown` (applied by the `md()`
#' helper function), then the text will be sanitized and transformed to HTML
#' from Markdown. If the incoming text has the class `html` (applied by `html()`
#' helper function), then the text will be seen as HTML and it won't undergo
#' sanitization.
#' @noRd
process_text <- function(text,
                         context = "html") {
  # If text is marked `AsIs` (by using `I()`) then just
  # return the text unchanged
  if (inherits(text, "AsIs")) {
    return(text)
  }

  if (is.list(text)) {
    if (context %in% names(text)) {
      return(process_text(text = text[[context]], context = context))
    }
  }

  if (context == "html") {
    # Text processing for HTML output

    if (inherits(text, "from_markdown")) {
      text <-
        as.character(text) %>%
        vapply(commonmark::markdown_html, character(1)) %>%
        stringr::str_replace_all(c("^<p>" = "", "</p>\n$" = ""))

      return(text)
    } else if (is_html(text) || inherits(text, "shiny.tag") || inherits(text, "shiny.tag.list")) {
      text <- as.character(text)

      return(text)
    } else {
      text <- htmltools::htmlEscape(as.character(text))

      return(text)
    }
  } else if (context == "latex") {
    # Text processing for LaTeX output

    if (inherits(text, "from_markdown")) {
      text <- markdown_to_latex(text = text)

      return(text)
    } else if (is_html(text)) {
      text <- as.character(text)

      return(text)
    } else {
      text <- escape_latex(text = text)

      return(text)
    }
  } else if (context == "rtf") {
    # Text processing for RTF output

    if (inherits(text, "from_markdown")) {
      return(markdown_to_rtf(text))
    } else if (inherits(text, "rtf_text")) {
      text <- as.character(text)

      return(text)
    } else {
      text <- rtf_escape(text)

      return(text)
    }
  } else {
    # Text processing in the default case

    if (inherits(text, "from_markdown")) {
      text <- markdown_to_text(text = text)

      return(text)
    } else if (is_html(text)) {
      text <- as.character(text)

      return(text)
    } else {
      text <- htmltools::htmlEscape(as.character(text))

      return(text)
    }
  }
}

### ----

# https://github.com/rstudio/gt/blob/ec97f7385166946d7a964ef31b7f6508ccd56550/R/utils_render_rtf.R

# Mark the given text as being RTF, meaning, it should not be escaped if passed
# to rtf_text
rtf_raw <- function(...) {
  text <- paste0(..., collapse = "")
  class(text) <- "rtf_text"
  text
}

rtf_escape <- function(x) {
  if (length(x) < 1) {
    return(x)
  }

  x <- gsub("\\", "\\'5c", x, fixed = TRUE)
  x <- gsub("{", "\\'7b", x, fixed = TRUE)
  x <- gsub("}", "\\'7d", x, fixed = TRUE)
  x <- vapply(x, FUN.VALUE = character(1), FUN = rtf_escape_unicode, USE.NAMES = FALSE)
  class(x) <- "rtf_text"
  x
}


### ----

## https://github.com/rstudio/gt/blob/ec97f7385166946d7a964ef31b7f6508ccd56550/R/dt_spanners.R



.dt_spanners_key <- "_spanners"

dt_spanners_get <- function(data) {
  dt__get(data, .dt_spanners_key)
}

# https://github.com/rstudio/gt/blob/fcabb414c55b70c9e445fbedfb24d52fe394ba61/R/dt_stub_df.R

.dt_stub_df_key <- "_stub_df"

dt_stub_df_get <- function(data) {
  dt__get(data, .dt_stub_df_key)
}

# https://github.com/rstudio/gt/blob/a6736d30ae72e68e5b66ae122c0424e441b3fba8/R/helpers.R

is_rtf <- function(x) {
  inherits(x, "rtf_text")
}

# vendored from: https://github.com/rstudio/gt/blob/7a6186dee0be6ed71cdf34d3815e2b32c2905e8f/R/data_color.R#L342-L365
#' Are color values in rgba() format?
#'
#' The input for this is a character vector that should contain color strings.
#' While users won't directly supply colors in rgba() format, the `html_color()`
#' function can produce these types of color values and this utility function is
#' used in `rgba_to_hex()` to help convert colors *back* to hexadecimal
#' (ultimately for the `ideal_fgnd_color()` function). The output of
#' `is_rgba_col()` is a vector of logical values (the same length as the input
#' `colors` vector).
#'
#' @param colors A vector of color values.
#'
#' @noRd
is_rgba_col <- function(colors) {
  grepl("^rgba\\(\\s*(?:[0-9]+?\\s*,\\s*){3}[0-9\\.]+?\\s*\\)$", colors)
}

#' Are color values in hexadecimal format?
#'
#' This regex checks for valid hexadecimal colors in either the `#RRGGBB` and
#' `#RRGGBBAA` forms (not including shortened form `#RGB` here,
#' `is_short_hex()` handles this case).
#'
#' @param colors A vector of color values.
#'
#' @noRd
is_hex_col <- function(colors) {
  grepl("^#[0-9a-fA-F]{6}([0-9a-fA-F]{2})?$", colors)
}

#' Are color values in the shorthand hexadecimal format?
#'
#' This regex checks for valid hexadecimal colors in the `#RGB` or `#RGBA`
#' shorthand forms.
#'
#' @param colors A vector of color values.
#'
#' @noRd
is_short_hex <- function(colors) {
  grepl("^#[0-9a-fA-F]{3}([0-9a-fA-F])?$", colors)
}

#' Expand shorthand hexadecimal colors to the normal form
#'
#' This function takes a vector of colors in the `#RGB` or `#RGBA`
#' shorthand forms and transforms them to their respective normal forms
#' (`#RRGGBB` and `#RRGGBBAA`). This should only be used with a vector of
#' `#RGB`- and `#RGBA`-formatted color values; `is_short_hex()` should be used
#' beforehand to ensure that input `colors` vector conforms to this expectation.
#'
#' @param colors A vector of color values.
#'
#' @noRd
expand_short_hex <- function(colors) {
  gsub("^#(.)(.)(.)(.?)$", "#\\1\\1\\2\\2\\3\\3\\4\\4", toupper(colors))
}

#' For a background color, which foreground color provides better contrast?
#'
#' The input for this function is a single color value in 'rgba()' format. The
#' output is a single color value in #RRGGBB hexadecimal format
#'
#' @noRd
ideal_fgnd_color <- function(bgnd_color,
                             light = "#FFFFFF",
                             dark = "#000000") {
  # Normalize color to hexadecimal color if it is in the 'rgba()' string format
  bgnd_color <- rgba_to_hex(colors = bgnd_color)

  # Normalize color to a #RRGGBB (stripping the alpha channel)
  bgnd_color <- html_color(colors = bgnd_color, alpha = 1)

  # Determine the ideal color for the chosen background color
  yiq_contrasted_threshold <- 128
  colors <- grDevices::col2rgb(bgnd_color)
  score <- colSums(colors * c(299, 587, 144)) / 1000
  ifelse(score >= yiq_contrasted_threshold, dark, light)
}

#' Convert colors in mixed formats (incl. rgba() strings) format to hexadecimal
#'
#' This function will accept colors in mixed formats and convert any in the
#' 'rgba()' string format (e.g., "`rgba(255,170,0,0.5)`") to a hexadecimal
#' format that preserves the alpha information (#RRGGBBAA). This function is
#' required for the `ideal_fgnd_color()` function.
#'
#' @noRd
rgba_to_hex <- function(colors) {
  colors_vec <- rep(NA_character_, length(colors))

  colors_rgba <- is_rgba_col(colors = colors)

  colors_vec[!colors_rgba] <- colors[!colors_rgba]

  color_matrix <-
    colors[colors_rgba] %>%
    gsub(pattern = "(rgba\\(|\\))", replacement = "", x = .) %>%
    strsplit(",") %>%
    unlist() %>%
    as.numeric() %>%
    matrix(
      .,
      ncol = 4,
      dimnames = list(c(), c("r", "g", "b", "alpha")),
      byrow = TRUE
    )

  alpha <- color_matrix[, "alpha"] %>% unname()

  # Convert color matrix to hexadecimal colors in the #RRGGBBAA format
  colors_to_hex <-
    grDevices::rgb(
      red = color_matrix[, "r"] / 255,
      green = color_matrix[, "g"] / 255,
      blue = color_matrix[, "b"] / 255,
      alpha = alpha
    )

  colors_vec[colors_rgba] <- colors_to_hex

  colors_vec
}

#' With a vector of input colors return normalized color strings
#'
#' Input colors can be color names (e.g., `"green"`, `"steelblue"`, etc.) or
#' colors in hexadecimal format with or without an alpha component (either
#' #RRGGBB or #RRGGBBAA). Output is the same length vector as the
#' input but it will contain a mixture of either #RRGGBB colors (if the input
#' alpha value for a color is 1) or 'rgba()' string format colors (if the input
#' alpha value for a color is not 1).
#'
#' @noRd
html_color <- function(colors, alpha = NULL) {
  # Stop function if there are any NA values in `colors`
  if (any(is.na(colors))) {
    stop("No values supplied in `colors` should be `NA`.", call. = FALSE)
  }

  is_rgba <- is_rgba_col(colors = colors)
  is_short_hex <- is_short_hex(colors = colors)

  # Expand any shorthand hexadecimal color values to the `RRGGBB` form
  colors[is_short_hex] <- expand_short_hex(colors = colors[is_short_hex])

  is_hex <- is_hex_col(colors = colors)

  # If not classified as RGBA or hexadecimal, assume other values are named
  # colors to be handled separately
  is_named <- !is_rgba & !is_hex

  colors[is_named] <- tolower(colors[is_named])

  named_colors <- colors[is_named]

  if (length(named_colors) > 0) {
    # Ensure that all color names are in the set of X11/R color
    # names or CSS color names
    check_named_colors(named_colors)

    # Translate the `transparent` color to #FFFFFF00 (white, transparent)
    named_colors[named_colors == "transparent"] <- "#FFFFFF00"

    # Translate any CSS exclusive colors to hexadecimal values;
    # there are nine CSS 3.0 named colors that don't belong to the
    # set of X11/R color names (not included numbered variants and
    # the numbered grays, those will be handled by `grDevices::col2rgb()`)
    is_css_excl_named <- colors %in% names(css_exclusive_colors())

    if (any(is_css_excl_named)) {
      # The `css_exclusive_colors()` function returns a named vector
      # of the CSS colors not in the X11/R set; the names are the hexadecimal
      # color values
      colors[is_css_excl_named] <-
        unname(css_exclusive_colors()[colors[is_css_excl_named]])
    }
  }

  # Normalize all non-'rgba()' color values and combine
  # with any preexisting 'rgba()' color values
  colors[!is_rgba] <-
    normalize_colors(
      colors = colors[!is_rgba],
      alpha = alpha
    )

  colors
}

# Utility function for creating 'rgba()' color values
# from an RGBA color matrix (already subsetted to those
# rows where alpha < 1)
col_matrix_to_rgba <- function(color_matrix) {
  paste0(
    "rgba(",
    color_matrix[, "red"], ",",
    color_matrix[, "green"], ",",
    color_matrix[, "blue"], ",",
    round(color_matrix[, "alpha"], 2),
    ")"
  )
}

# Utility function for generating hexadecimal or 'rgba()' colors (for IE11
# compatibility with colors having some transparency) from hexadecimal color
# values and X11/R color names
normalize_colors <- function(colors, alpha) {
  # Create a color matrix with an `alpha` column
  color_matrix <- t(grDevices::col2rgb(col = colors, alpha = TRUE))
  color_matrix[, "alpha"] <- color_matrix[, "alpha"] / 255

  # If `alpha` has a value, replace all pre-existing
  # alpha values in the color matrix with `alpha`
  if (!is.null(alpha)) {
    color_matrix[, "alpha"] <- alpha
  }

  # Generate a vector for the finalized HTML color values
  colors_html <- rep(NA_character_, nrow(color_matrix))

  # Determine which of the input colors have an alpha of `1`
  colors_alpha_1 <- color_matrix[, "alpha"] == 1

  # Generate #RRGGBB color values for `colors_html`
  colors_html[colors_alpha_1] <-
    grDevices::rgb(
      red = color_matrix[colors_alpha_1, "red", drop = FALSE] / 255,
      green = color_matrix[colors_alpha_1, "green", drop = FALSE] / 255,
      blue = color_matrix[colors_alpha_1, "blue", drop = FALSE] / 255
    )

  # Generate rgba() color values for `colors_html`
  colors_html[!colors_alpha_1] <-
    color_matrix[!colors_alpha_1, , drop = FALSE] %>%
    col_matrix_to_rgba()

  colors_html
}

css_exclusive_colors <- function() {
  color_tbl_subset <- css_colors[!css_colors$is_x11_color, ]

  color_values <- color_tbl_subset[["hexadecimal"]]

  color_values <-
    stats::setNames(
      color_values,
      tolower(color_tbl_subset[["color_name"]])
    )

  color_values
}

valid_color_names <- function() {
  c(tolower(grDevices::colors()), names(css_exclusive_colors()), "transparent")
}

check_named_colors <- function(named_colors) {
  named_colors <- tolower(named_colors)

  if (!all(named_colors %in% valid_color_names())) {
    invalid_colors <- setdiff(unique(named_colors), valid_color_names())

    one_several_invalid <-
      ifelse(
        length(invalid_colors) > 1,
        "Several invalid color names were ",
        "An invalid color name was "
      )

    stop(
      "Only R/X11 color names and CSS 3.0 color names can be used.",
      call. = FALSE
    )
  }
}
