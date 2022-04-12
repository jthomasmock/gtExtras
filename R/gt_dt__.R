# vendored code with attribution from gt
# https://github.com/rstudio/gt/blob/7929072221b059901a1649fe7f83d725521fb02a/R/dt__.R

dt__get <- function(data, key) {

  data[[key, exact = TRUE]]
}

dt__set <- function(data, key, value) {

  data[[key]] <- value

  data
}
