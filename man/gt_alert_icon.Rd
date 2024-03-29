% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gt_alert_icon.R
\name{gt_alert_icon}
\alias{gt_alert_icon}
\title{Insert an alert icon to a specific column}
\usage{
gt_alert_icon(
  gt_object,
  column,
  palette = c("#a962b6", "#f1f1f1", "#378e38"),
  domain = NULL,
  height = "10px",
  direction = 1,
  align = "center",
  v_pad = -5
)
}
\arguments{
\item{gt_object}{An existing gt table object of class \code{gt_tbl}}

\item{column}{The column wherein the numeric values should be replaced with circular alert icons.}

\item{palette}{The colours or colour function that values will be mapped to. Can be a character vector (eg \code{c("white", "red")} or hex colors) or a named palette from the \code{{paletteer}} package in the \code{package::palette_name} structure.}

\item{domain}{The possible values that can be mapped. This should be a simple numeric range (e.g. \code{c(0, 100)})}

\item{height}{A character string indicating the height in pixels, like "10px"}

\item{direction}{The direction of the \code{paletteer} palette, should be either \code{-1} for reversed or the default of \code{1} for the existing direction.}

\item{align}{Character string indicating alignment of the column, defaults to "left"}

\item{v_pad}{A numeric value indicating the vertical padding, defaults to -5 to aid in centering within the vertical space.}
}
\value{
a gt table
}
\description{
Insert an alert icon to a specific column
}
\section{Examples}{


\if{html}{\out{<div class="sourceCode r">}}\preformatted{head(mtcars) \%>\%
  dplyr::mutate(warn = ifelse(mpg >= 21, 1, 0), .before = mpg) \%>\%
  gt::gt() \%>\%
  gt_alert_icon(warn)
}\if{html}{\out{</div>}}

\if{html}{\figure{man/figures/gt_alert_icon-binary.png}{options: width=100\%}}
}

