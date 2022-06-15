library(usethis)

source("data-raw/x06-css-colors.R")

# Create internal datasets (`sysdata.rda`)
usethis::use_data(
  css_colors,
  internal = TRUE, overwrite = TRUE
)
