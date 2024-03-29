% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gt_hulk_color.R
\name{gt_hulk_col_numeric}
\alias{gt_hulk_col_numeric}
\title{Apply 'hulk' palette to specific columns in a gt table.}
\usage{
gt_hulk_col_numeric(
  gt_object,
  columns = NULL,
  domain = NULL,
  ...,
  trim = FALSE
)
}
\arguments{
\item{gt_object}{An existing gt table object of class \code{gt_tbl}}

\item{columns}{The columns wherein changes to cell data colors should occur.}

\item{domain}{The possible values that can be mapped.

For \code{col_numeric} and \code{col_bin}, this can be a simple numeric
range (e.g. \code{c(0, 100)}); \code{col_quantile} needs representative
numeric data; and \code{col_factor} needs categorical data.

If \code{NULL}, then whenever the resulting colour function is called, the
\code{x} value will represent the domain. This implies that if the function
is invoked multiple times, the encoding between values and colours may not
be consistent; if consistency is needed, you must provide a non-\code{NULL}
domain.}

\item{...}{Additional arguments passed to \code{scales::col_numeric()}}

\item{trim}{trim the palette to give less intense maximal colors}
}
\value{
An object of class \code{gt_tbl}.
}
\description{
The hulk name comes from the idea of a diverging purple and green theme
that is colorblind safe and visually appealing.
It is a useful alternative to the red/green palette where purple typically
can indicate low or "bad" value, and green can indicate a high or "good" value.
}
\section{Examples}{


\if{html}{\out{<div class="sourceCode r">}}\preformatted{ library(gt)
 # basic use
 hulk_basic <- mtcars \%>\%
   head() \%>\%
   gt::gt() \%>\%
   gt_hulk_col_numeric(mpg)

 hulk_trim <- mtcars \%>\%
   head() \%>\%
   gt::gt() \%>\%
   # trim gives small range of colors
   gt_hulk_col_numeric(mpg:disp, trim = TRUE)

 # option to reverse the color palette
 hulk_rev <- mtcars \%>\%
   head() \%>\%
   gt::gt() \%>\%
   # trim gives small range of colors
   gt_hulk_col_numeric(mpg:disp, reverse = TRUE)
}\if{html}{\out{</div>}}
}

\section{Figures}{

\if{html}{\figure{hulk_basic.png}{options: width=100\%}}

\if{html}{\figure{hulk_trim.png}{options: width=100\%}}

\if{html}{\figure{hulk_reverse.png}{options: width=100\%}}
}

\section{Function ID}{

4-1
}

\seealso{
Other Colors: 
\code{\link{gt_color_box}()},
\code{\link{gt_color_rows}()}
}
\concept{Colors}
