# vendored code with attribution from gt
# https://github.com/rstudio/gt/blob/ec97f7385166946d7a964ef31b7f6508ccd56550/R/resolver.R

#' Resolve the `cells_body` object once it has access to the `data` object
#'
#' @param data A table object that is created using the `gt()` function.
#' @param object The list object created by the `cells_body()` function.
#'
#' @import rlang
#' @noRd
resolve_cells_body <- function(data,
                               object) {
  # Get the `stub_df` data frame from `data`
  stub_df <- dt_stub_df_get(data = data)
  data_tbl <- dt_data_get(data = data)

  #
  # Resolution of columns and rows as integer vectors
  # providing the positions of the matched variables
  #

  # Resolve columns as index values
  resolved_columns_idx <-
    resolve_cols_i(
      expr = !!object$columns,
      data = data
    )

  # Resolve rows as index values
  resolved_rows_idx <-
    resolve_rows_i(
      expr = !!object$rows,
      data = data
    )

  # Get all possible combinations with `expand.grid()`
  expansion <-
    expand.grid(
      resolved_columns_idx,
      resolved_rows_idx,
      stringsAsFactors = FALSE
    ) %>%
    dplyr::arrange(Var1) %>%
    dplyr::distinct()

  # Create a list object
  cells_resolved <-
    list(
      columns = expansion[[1]],
      colnames = names(expansion[[1]]),
      rows = expansion[[2]]
    )

  # Apply the `data_cells_resolved` class
  class(cells_resolved) <- "data_cells_resolved"

  cells_resolved
}

#' Resolve the `cells_stub` object once it has access to the `data` object
#'
#' @param data A table object that is created using the `gt()` function.
#' @param object The list object created by the `cells_stub()` function.
#' @noRd
resolve_cells_stub <- function(data,
                               object) {
  #
  # Resolution of rows as integer vectors
  # providing the positions of the matched variables
  #
  resolved_rows_idx <-
    resolve_rows_i(
      expr = !!object$rows,
      data = data
    )

  # Create a list object
  cells_resolved <- list(rows = resolved_rows_idx)

  # Apply the `stub_cells_resolved` class
  class(cells_resolved) <- "stub_cells_resolved"

  cells_resolved
}

#' Resolve the `cells_column_labels` object once it has access to the `data`
#' object
#'
#' @param data A table object that is created using the `gt()` function.
#' @param object The list object created by the `cells_column_labels()`
#'   function.
#' @noRd
resolve_cells_column_labels <- function(data,
                                        object) {
  #
  # Resolution of columns as integer vectors
  # providing the positions of the matched variables
  #
  resolved_columns <-
    resolve_cols_i(
      expr = !!object$columns,
      data = data
    )

  # Create a list object
  cells_resolved <- list(columns = resolved_columns)

  # Apply the `columns_cells_resolved` class
  class(cells_resolved) <- "columns_cells_resolved"

  cells_resolved
}

#' Resolve the spanner values in the `cells_column_labels` object once it
#' has access to the `data` object
#'
#' @param data A table object that is created using the `gt()` function.
#' @param object The list object created by the `cells_column_labels()`
#'   function.
#' @noRd
resolve_cells_column_spanners <- function(data,
                                          object) {
  #
  # Resolution of spanners as column spanner names
  #
  spanner_labels <-
    dt_spanners_get(data = data) %>%
    .$spanner_label %>%
    unlist() %>%
    .[!is.na(.)] %>%
    unique()

  spanner_ids <-
    dt_spanners_get(data = data) %>%
    .$spanner_id %>%
    .[!is.na(.)]

  resolved_spanners_idx <-
    resolve_vector_i(
      expr = !!object$spanners,
      vector = spanner_ids,
      item_label = "spanner"
    )

  resolved_spanners <- spanner_ids[resolved_spanners_idx]

  # Create a list object
  cells_resolved <- list(spanners = resolved_spanners)

  # Apply the `columns_cells_resolved` class
  class(cells_resolved) <- "columns_spanners_resolved"

  cells_resolved
}

#' @param expr An unquoted expression that follows **tidyselect** semantics
#' @param data A gt object or data frame or tibble
#' @return Character vector
#' @noRd
resolve_cols_c <- function(expr,
                           data,
                           strict = TRUE,
                           excl_stub = TRUE,
                           null_means = c("everything", "nothing")) {
  null_means <- match.arg(null_means)

  names(
    resolve_cols_i(
      expr = {{ expr }},
      data = data,
      strict = strict,
      excl_stub = excl_stub,
      null_means = null_means
    )
  )
}

#' @param expr An unquoted expression that follows **tidyselect** semantics
#' @param data A gt object or data frame or tibble
#' @param strict If TRUE, out-of-bounds errors are thrown if `expr` attempts to
#'   select a column that doesn't exist. If FALSE, failed selections are
#'   ignored.
#' @param excl_stub If TRUE then the table stub column, if present, will be
#'   excluded from the selection of column names.
#' @return Named integer vector
#' @noRd
resolve_cols_i <- function(expr,
                           data,
                           strict = TRUE,
                           excl_stub = TRUE,
                           null_means = c("everything", "nothing")) {
  quo <- rlang::enquo(expr)
  cols_excl <- c()
  null_means <- match.arg(null_means)

  if (is_gt(data)) {
    cols <- colnames(dt_data_get(data = data))

    # In most cases we would want to exclude the column that
    # represents the stub but that isn't always the case (e.g.,
    # when considering the stub for column sizing); the `excl_stub`
    # argument will determine whether the stub column is obtained
    # for exclusion or not (if FALSE, we get NULL which removes the
    # stub, if present, from `cols_excl`)
    stub_var <-
      if (excl_stub) {
        dt_boxhead_get_var_stub(data)
      } else {
        NULL
      }

    # The columns that represent the group rows are always
    # excluded (i.e., included in the `col_excl` vector)
    group_rows_vars <- dt_boxhead_get_vars_groups(data)

    cols_excl <- c(stub_var, group_rows_vars)

    data <- dt_data_get(data = data)
  }

  stopifnot(is.data.frame(data))

  quo <- translate_legacy_resolver_expr(quo, null_means)

  # With the quosure and the `data`, we can use `tidyselect::eval_select()`
  # to resolve the expression to columns indices/names; no `env` argument
  # is required here because the `expr` is a quosure
  selected <- tidyselect::eval_select(expr = quo, data = data, strict = strict)

  # Exclude certain columns (e.g., stub & group columns) if necessary
  selected[!names(selected) %in% cols_excl]
}

#' @param quo A quosure that might contain legacy gt column criteria
#' @noRd
translate_legacy_resolver_expr <- function(quo, null_means) {
  expr <- rlang::quo_get_expr(quo = quo)

  if (identical(expr, FALSE)) {
    warning(
      "`columns = FALSE` has been deprecated in gt 0.3.0:\n",
      "* please use `columns = c()` instead",
      call. = FALSE
    )

    rlang::quo_set_expr(quo = quo, expr = quote(NULL))
  } else if (identical(expr, TRUE)) {
    warning(
      "`columns = TRUE` has been deprecated in gt 0.3.0:\n",
      "* please use `columns = everything()` instead",
      call. = FALSE
    )

    rlang::quo_set_expr(quo = quo, expr = quote(everything()))
  } else if (is.null(expr)) {
    if (null_means == "everything") {
      warning(
        "`columns = NULL` has been deprecated in gt 0.3.0:\n",
        "* please use `columns = everything()` instead",
        call. = FALSE
      )

      rlang::quo_set_expr(quo = quo, expr = quote(everything()))
    } else {
      rlang::quo_set_expr(quo = quo, expr = quote(NULL))
    }
  } else if (rlang::quo_is_call(quo = quo, name = "vars")) {
    warning(
      "`columns = vars(...)` has been deprecated in gt 0.3.0:\n",
      "* please use `columns = c(...)` instead",
      call. = FALSE
    )

    rlang::quo_set_expr(
      quo = quo,
      expr = rlang::call2(quote(c), !!!rlang::call_args(expr))
    )
  } else {
    # No legacy expression detected
    quo
  }
}

resolve_rows_l <- function(expr, data) {
  if (is_gt(data)) {
    row_names <- dt_stub_df_get(data)$rowname
    data <- dt_data_get(data = data)
  } else {
    row_names <- row.names(data)
  }

  stopifnot(is.data.frame(data))

  quo <- rlang::enquo(expr)

  resolved <-
    tidyselect::with_vars(
      vars = row_names,
      expr = rlang::eval_tidy(expr = quo, data = data)
    )

  if (is.null(resolved)) {
    warning(
      "The use of `NULL` for rows has been deprecated in gt 0.3.0:\n",
      "* please use `TRUE` instead",
      call. = FALSE
    )

    # Modify the NULL value of `resolved` to `TRUE` (which is
    # fully supported for selecting all rows)
    resolved <- TRUE
  }

  resolved <-
    normalize_resolved(
      resolved = resolved,
      item_names = row_names,
      item_label = "row"
    )

  resolved
}

resolve_rows_i <- function(expr, data) {
  which(resolve_rows_l(expr = {{ expr }}, data = data))
}

resolve_vector_l <- function(expr,
                             vector,
                             item_label = "item") {
  quo <- rlang::enquo(expr)

  resolved <-
    tidyselect::with_vars(
      vars = vector,
      expr = rlang::eval_tidy(expr = quo, data = NULL)
    )

  resolved <-
    normalize_resolved(
      resolved = resolved,
      item_names = vector,
      item_label = item_label
    )

  resolved
}

resolve_vector_i <- function(expr, vector, item_label = "item") {
  which(resolve_vector_l(expr = {{ expr }}, vector = vector, item_label = item_label))
}

normalize_resolved <- function(resolved,
                               item_names,
                               item_label) {
  item_count <- length(item_names)
  item_sequence <- seq_along(item_names)

  if (is.null(resolved)) {
    # Maintained for backcompatability
    resolved <- rep_len(TRUE, item_count)

    # TODO: this may not apply to all types of resolution so we may
    # want to either make this warning conditional (after investigating which
    # resolving contexts still allow `NULL`)
    warning(
      "The use of `NULL` for ", item_label, "s has been deprecated in gt 0.3.0:\n",
      "* please use `everything()` instead",
      call. = FALSE
    )
  } else if (is.logical(resolved)) {
    if (length(resolved) == 1) {
      resolved <- rep_len(resolved, item_count)
    } else if (length(resolved) == item_count) {
      # Do nothing
    } else {
      resolver_stop_on_logical(item_label = item_label)
    }
  } else if (is.numeric(resolved)) {
    unknown_resolved <- setdiff(resolved, item_sequence)
    if (length(unknown_resolved) != 0) {
      resolver_stop_on_numeric(item_label = item_label, unknown_resolved = unknown_resolved)
    }
    resolved <- item_sequence %in% resolved
  } else if (is.character(resolved)) {
    unknown_resolved <- setdiff(resolved, item_names)
    if (length(unknown_resolved) != 0) {
      resolver_stop_on_character(item_label = item_label, unknown_resolved = unknown_resolved)
    }
    resolved <- item_names %in% resolved
  } else {
    resolver_stop_unknown(item_label = item_label, resolved = resolved)
  }

  resolved
}

resolver_stop_on_logical <- function(item_label) {
  stop(
    "The number of logical values must either be 1 or the number of ",
    item_label, "s",
    call. = FALSE
  )
}

resolver_stop_on_numeric <- function(item_label, unknown_resolved) {
  stop(
    "The following ", item_label, " indices do not exist in the data: ",
    paste0(unknown_resolved, collapse = ", "),
    call. = FALSE
  )
}

resolver_stop_on_character <- function(item_label, unknown_resolved) {
  stop(
    "The following ", item_label, "(s) do not exist in the data: ",
    paste0(unknown_resolved, collapse = ", "),
    call. = FALSE
  )
}

resolver_stop_unknown <- function(item_label, resolved) {
  stop(
    "Don't know how to select ", item_label, "s using an object of class ",
    class(resolved)[1],
    call. = FALSE
  )
}
