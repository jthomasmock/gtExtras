# Vendored gt code with attribution
# https://github.com/rstudio/gt/blob/7929072221b059901a1649fe7f83d725521fb02a/R/dt_data.R

.dt_data_key <- "_data"

dt_data_get <- function(data) {
  dt__get(data, .dt_data_key)
}

dt_data_set <- function(data, data_tbl) {
  dt__set(data, .dt_data_key, data_tbl %>% dplyr::as_tibble())
}

# rownames_to_column is a string; if not NA, it means the row.names(data_tbl)
# should be turned into a column with the name !!rownames_to_column
dt_data_init <- function(data, data_tbl, rownames_to_column = NA) {
  if (!is.na(rownames_to_column)) {
    data_rownames <- rownames(data_tbl)

    if (rownames_to_column %in% colnames(data_tbl)) {
      stop("Reserved column name `", rownames_to_column, "` was detected in ",
        "the data; please rename this column",
        call. = FALSE
      )
    }

    data_tbl <-
      data_tbl %>%
      dplyr::mutate(!!sym(rownames_to_column) := data_rownames) %>%
      dplyr::select(!!sym(rownames_to_column), dplyr::everything())
  }

  dt_data_set(data = data, data_tbl = data_tbl)
}
