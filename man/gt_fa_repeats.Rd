% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fontawesome-icons.R
\name{gt_fa_repeats}
\alias{gt_fa_repeats}
\title{Repeat \code{{fontawesome}} icons based on an integer.}
\usage{
gt_fa_repeats(
  gt_object,
  column,
  name = NULL,
  ...,
  palette = NULL,
  align = "left",
  direction = 1
)
}
\arguments{
\item{gt_object}{An existing gt table object of class \code{gt_tbl}}

\item{column}{The column wherein the integers should be replaced with \code{{fontawesome}} icons.}

\item{name}{A character string indicating the name of the "\code{fontawesome} icon.}

\item{...}{Additional arguments passed to \code{fontawesome::fa()}}

\item{palette}{Name of palette as a string. Must be either length of 1 or a vector of valid color names/hex values of equal length to the unique levels of the column (ie if there are 4 names, there need to be 4x colors).}

\item{align}{Character string indicating alignment of the column, defaults to "left"}

\item{direction}{The direction of the \code{paletteer} palette, should be either \code{-1} for reversed or the default of \code{1} for the existing direction.}
}
\value{
An object of class \code{gt_tbl}.
}
\description{
The \code{gt_fa_repeats} function takes an existing \code{gt_tbl} object and
adds specific \code{fontawesome} to the cells. The icons are repeated according to the
integer that the column contains.
}
\section{Examples}{


\if{html}{\out{<div class="sourceCode r">}}\preformatted{library(gt)
mtcars[1:5, 1:4] \%>\%
  gt() \%>\%
  gt_fa_repeats(cyl, name = "car")
}\if{html}{\out{</div>}}
}

\section{Figures}{

\if{html}{\figure{fa-cars.png}{options: width=50\%}}
}

\section{Function ID}{

2-8
}

\seealso{
Other Utilities: 
\code{\link{add_text_img}()},
\code{\link{fa_icon_repeat}()},
\code{\link{fmt_pad_num}()},
\code{\link{fmt_pct_extra}()},
\code{\link{fmt_symbol_first}()},
\code{\link{generate_df}()},
\code{\link{gt_add_divider}()},
\code{\link{gt_badge}()},
\code{\link{gt_double_table}()},
\code{\link{gt_duplicate_column}()},
\code{\link{gt_fa_column}()},
\code{\link{gt_fa_rank_change}()},
\code{\link{gt_fa_rating}()},
\code{\link{gt_highlight_cols}()},
\code{\link{gt_highlight_rows}()},
\code{\link{gt_img_border}()},
\code{\link{gt_img_circle}()},
\code{\link{gt_img_multi_rows}()},
\code{\link{gt_img_rows}()},
\code{\link{gt_index}()},
\code{\link{gt_merge_stack_color}()},
\code{\link{gt_merge_stack}()},
\code{\link{gt_two_column_layout}()},
\code{\link{gtsave_extra}()},
\code{\link{img_header}()},
\code{\link{pad_fn}()},
\code{\link{tab_style_by_grp}()}
}
\concept{Utilities}
