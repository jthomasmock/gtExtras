#' Get last row id/index even by group
#'
#' @param gt_object An existing gt table object of class `gt_tbl`

last_row_id <- function(gt_object){

  # browser()

  # find the grouping var
  subset_log <- gt_object[["_boxhead"]][["type"]]=="row_group"

  grps <- gt_object[["_boxhead"]][["var"]][subset_log]
  grp_len <- length(grps)

  if(grp_len == 0){
    return(nrow(gt_object[["_data"]]))
  }

  if(grp_len > 2){
    stop("Can only be used with a table with 2 or fewer groups", call. = FALSE)
  }

  if(grp_len == 1){
    grp_col <- gt_object[["_boxhead"]][["var"]][subset_log] %>% rlang::sym()

    last_grp <- gt_object[["_data"]][[grp_col]] %>% unique() %>% last()

    row_ids <- gt_object[["_data"]] %>%
      mutate(`_vrow_id` = row_number()) %>%
      filter(!!grp_col == last_grp) %>%
      pull(.data$`_vrow_id`) %>%
      last()

    return(row_ids)
  }

  # can handle 2 groups
  if(grp_len == 2){

    grp_cols <- gt_object[["_boxhead"]][["var"]][subset_log] %>% rlang::syms()

    row_ids <- gt_object[["_data"]] %>%
      mutate(`_vrow_id` = row_number()) %>%
      rowwise() %>%
      mutate(z_r_group_rows = paste(grps, collapse = " - ")) %>%
      ungroup()  %>%
      mutate(z_r_group_rows = factor(z_r_group_rows, levels = gt_object[["_row_groups"]])) %>%
      arrange(z_r_group_rows) %>%
      pull(.data$`_vrow_id`) %>%
      last()

    return(row_ids)
  }

}
