% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gt_theme_538.R
\name{gt_theme_538}
\alias{gt_theme_538}
\title{Apply FiveThirtyEight theme to a gt table}
\usage{
gt_theme_538(gt_object, ..., quiet = FALSE)
}
\arguments{
\item{gt_object}{An existing gt table object of class \code{gt_tbl}}

\item{...}{Optional additional arguments to \code{gt::table_options()}}

\item{quiet}{A logical to silence the warning about missing ID}
}
\value{
An object of class \code{gt_tbl}.
}
\description{
Apply FiveThirtyEight theme to a gt table
}
\section{Examples}{


\if{html}{\out{<div class="sourceCode r">}}\preformatted{library(gt)
themed_tab <- head(mtcars) \%>\%
  gt() \%>\%
  gt_theme_538()
}\if{html}{\out{</div>}}
}

\section{Figures}{

\if{html}{\figure{gt_538.png}{options: width=100\%}}
}

\section{Function ID}{

1-1
}

\seealso{
Other Themes: 
\code{\link{gt_plt_bullet}()},
\code{\link{gt_plt_conf_int}()},
\code{\link{gt_plt_dot}()},
\code{\link{gt_theme_dark}()},
\code{\link{gt_theme_dot_matrix}()},
\code{\link{gt_theme_espn}()},
\code{\link{gt_theme_excel}()},
\code{\link{gt_theme_guardian}()},
\code{\link{gt_theme_nytimes}()},
\code{\link{gt_theme_pff}()}
}
\concept{Themes}
