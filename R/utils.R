#' Count number of decimals
#'
#' @param x A value to count decimals from
#'
#' @return an integer
#' @export
#'
n_decimals <- function(x) {
  # adapted from: https://stackoverflow.com/questions/5173692/how-to-return-number-of-decimal-places-in-r
  if (abs(x - round(x)) > .Machine$double.eps^0.5) {
    # x <- format(x, drop0trailing = TRUE)
    # nchar(strsplit(x, ".", fixed = TRUE)[[1]][[2]])
    nchar(strsplit(sub('0+$', '', as.character(x)), ".", fixed = TRUE)[[1]][[2]])
  } else {
    return(0)
  }
}

# Calculate binwidth for histograms based on good defaults

bw_calc <- function(x){
  bw <- 2 * IQR(x, na.rm = TRUE) / length(x)^(1/3)
  bw
}

# save the SVG of a plot out

save_svg <- function(plot, ..., dpi = 25.4){

  out_name <- file.path(
    tempfile(pattern = "file", tmpdir = tempdir(), fileext = ".svg")
  )

  ggsave(
    out_name,
    plot = plot,
    ...,
    bg = "transparent",
    # below are some general defaults, but don't want to
    # force them if used more generally
    dpi = dpi,
    # height = fig_dim[1],
    # width = fig_dim[2],
    # units = "mm"

  )

  img_plot <- out_name %>%
    readLines() %>%
    # potentially required as PANDOC turns 4 spaces into pre code block
    # https://github.com/jthomasmock/gtExtras/issues/56
    # https://stackoverflow.com/questions/40730902/r-markdown-asis-breaks-valid-html-code
    tidy_gsub(pattern = "\\s+", replacement = " ") %>%
    paste0(collapse = "") %>%
    gt::html()

  on.exit(file.remove(out_name), add=TRUE)

  img_plot

}

# check if gt
#' @noRd
is_gt <- function(gt_object){
  any("gt_tbl" %in% class(gt_object))
}
# check if stop gt
#' @noRd
is_gt_stop <- function(gt_object){
  stopifnot("'gt_object' must be a 'gt_tbl', have you accidentally passed raw data?" = any("gt_tbl" %in% class(gt_object)))
}

# vendored from gt
# https://github.com/rstudio/gt/blob/04c34936a9d09e96b339dea8da07e414730ec17d/R/utils.R#L1654-L1661
man_get_image_tag <- function(file, width = 100, dir = "images") {

  repo_url <- "https://raw.githubusercontent.com/jthomasmock/gtExtras/master"

  image_url <- file.path(repo_url, dir, file)

  paste0("<img src=\"", image_url, "\" style=\"width:", width, "\\%;\">")
}

# https://stackoverflow.com/questions/19655579/a-function-that-returns-true-on-na-null-nan-in-r
is_blank <- function(x){
  if (missing(x) || is.null(x) || length(x) == 0 || is.na(x)) {
  return(TRUE)
  } else {
    return(FALSE)
  }
}
