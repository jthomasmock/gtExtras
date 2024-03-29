% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gt_theme_excel.R
\name{gt_theme_excel}
\alias{gt_theme_excel}
\title{Apply Excel-style theme to an existing gt table}
\usage{
gt_theme_excel(gt_object, ..., color = "lightgrey")
}
\arguments{
\item{gt_object}{An existing gt table object of class \code{gt_tbl}}

\item{...}{Additional arguments passed to \code{gt::tab_options()}}

\item{color}{A string indicating the color of the row striping, defaults to a light gray Accepts either named colors or hex colors.}
}
\value{
An object of class \code{gt_tbl}.
}
\description{
Apply Excel-style theme to an existing gt table
}
\section{Figures}{

\if{html}{\figure{gt_excel.png}{options: width=75\%}}
}

\section{Function ID}{

1-7
}

\examples{
library(gt)
themed_tab <- head(mtcars) \%>\%
  gt() \%>\%
  gt_theme_excel() \%>\%
  tab_header(title = "Styled like your old pal, Excel")
}
\seealso{
Other Themes: 
\code{\link{gt_plt_bullet}()},
\code{\link{gt_plt_conf_int}()},
\code{\link{gt_plt_dot}()},
\code{\link{gt_theme_538}()},
\code{\link{gt_theme_dark}()},
\code{\link{gt_theme_dot_matrix}()},
\code{\link{gt_theme_espn}()},
\code{\link{gt_theme_guardian}()},
\code{\link{gt_theme_nytimes}()},
\code{\link{gt_theme_pff}()}
}
\concept{Themes}
