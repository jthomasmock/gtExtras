#' Use webshot2 to save a gt table as a PNG
#' @description Takes existing HTML content, typically additional HTML including a gt table as a PNG via the `{webshot2}` package.
#' @param data HTML content to be saved temporarily to disk
#' @param filename The name of the file, should end in `.png`
#' @param path An optional path
#' @param ... Additional arguments to `webshot2::webshot()`
#' @param zoom A number specifying the zoom factor. A zoom factor of 2 will result in twice as many pixels vertically and horizontally. Note that using 2 is not exactly the same as taking a screenshot on a HiDPI (Retina) device: it is like increasing the zoom to 200 doubling the height and width of the browser window.
#' @param expand A numeric vector specifying how many pixels to expand the clipping rectangle by. If one number, the rectangle will be expanded by that many pixels on all sides. If four numbers, they specify the top, right, bottom, and left, in that order.
#' @return Prints the HTML content to the RStudio viewer and saves a `.png` file to disk
#' @export
#' @importFrom utils capture.output
#' @family Utilities
#' @section Function ID:
#' 2-14
#'
gtsave_extra <- function(data,
                         filename,
                         path = NULL,
                         ...,
                         zoom = 2,
                         expand = 5) {

  filename <- gtsave_filename(path = path, filename = filename)

  # Create a temporary file with the `html` extension
  tempfile_ <- tempfile(fileext = ".html")

  # Reverse slashes on Windows filesystems
  tempfile_ <-
    tempfile_ %>%
    tidy_gsub("\\\\", "/")

  # Save gt table as HTML using the `gt_save_html()` function
  gt_save_html(
    data = data,
    filename = tempfile_,
    path = NULL
  )

  # Saving an image requires the webshot2 package; if it's
  # not present, stop with a message
  if (!rlang::is_installed("webshot2")) {
    stop("The 'webshot2' package is required for saving images of gt tables.)",
      call. = FALSE
    )
  } else {
    # Save the image in the working directory
    web_out <- webshot2::webshot(
      url = paste0("file:///", tempfile_),
      file = filename,
      zoom = zoom,
      expand = expand,
      ...
    ) %>%
     utils::capture.output(type = "message") %>%
     invisible()

    if(!grepl("screenshot completed", tolower(web_out))) print(web_out)

  }

  if (interactive()) {
    htmltools::browsable(data)
  }
}
