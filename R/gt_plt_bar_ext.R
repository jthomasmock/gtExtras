
# gt stacked barplot function extended to taking 6 input values instead of 3 and suppresses printing numbers for values smaller than specified
gt_plt_bar_ext <- function (gt_object, 
                               column = NULL, palette = c("#ff4343", "#bfbfbf", 
                                                          "#0a1c2b", "#ff4343", "#bfbfbf", "#0a1c2b"), 
                               labels = c("Group 1", "Group 2", "Group 3", "Group 4", "Group 5", "Group 6"), 
                               position = "fill", width = 70, 
                               fmt_fn = scales::label_number(scale_cut = scales:::cut_short_scale(), trim = TRUE),
                               suppress = 0)
{
  stopifnot(`Table must be of class 'gt_tbl'` = "gt_tbl" %in% 
              class(gt_object))
  stopifnot(`There must be 2 or 3 labels` = (length(labels) %in% 
                                               c(2:6)))
  stopifnot(`There must be 2 or 3 colors in the palette` = (length(palette) %in% 
                                                              c(2:6)))
  stopifnot(`\`position\` must be one of 'stack' or 'fill'` = (position %in% 
                                                                 c("stack", "fill")))
  var_sym <- rlang::enquo(column)
  var_bare <- rlang::as_label(var_sym)
  all_vals <- gt_index(gt_object, {
    {
      column
    }
  }) %>% lapply(X = ., FUN = sum, na.rm = TRUE) %>% unlist()
  if (length(all_vals) == 0) {
    return(gt_object)
  }
  total_rng <- max(all_vals, na.rm = TRUE)
  tab_out <- text_transform(gt_object, locations = cells_body({
    {
      column
    }
  }), fn = function(x) {
    bar_fx <- function(x_val) {
      if (x_val %in% c("NA", "NULL")) {
        return("<div></div>")
      }
      col_pal <- palette
      vals <- strsplit(x_val, split = ", ") %>% unlist() %>% 
        as.double()
      n_val <- length(vals)
      stopifnot(`There must be 2 or 3 values` = (n_val %in% 
                                                   c(2, 6)))
      col_fill <- if (n_val == 2) {
        c(1, 2)
      }
      else {
        c(1:6)
      }
      df_in <- dplyr::tibble(x = vals, y = rep(1, n_val), 
                             fill = col_pal[col_fill])
      plot_out <- df_in %>% ggplot(aes(x = .data$x, y = factor(.data$y), 
                                       fill = I(.data$fill), group = .data$y)) + geom_col(position = position, 
                                                                                          color = "white", width = 1) + geom_text(aes(label = ifelse(x>suppress,fmt_fn(x), NA)), 
                                                                                                                                  hjust = 0.5, size = 3, family = "arial", position = if (position == 
                                                                                                                                                                                          "fill") {
                                                                                                                                    position_fill(vjust = 0.5)
                                                                                                                                  }
                                                                                                                                  else if (position == "stack") {
                                                                                                                                    position_stack(vjust = 0.5)
                                                                                                                                  }, color = "white") + scale_x_continuous(expand = if (position == 
                                                                                                                                                                                        "stack") {
                                                                                                                                    expansion(mult = c(0, 0.1))
                                                                                                                                  }
                                                                                                                                  else {
                                                                                                                                    c(0, 0)
                                                                                                                                  }, limits = if (position == "stack") {
                                                                                                                                    c(0, total_rng)
                                                                                                                                  }
                                                                                                                                  else {
                                                                                                                                    NULL
                                                                                                                                  }) + scale_y_discrete(expand = c(0, 0)) + coord_cartesian(clip = "off") + 
        theme_void() + theme(legend.position = "none", 
                             plot.margin = margin(0, 0, 0, 0, "pt"))
      out_name <- file.path(tempfile(pattern = "file", 
                                     tmpdir = tempdir(), fileext = ".svg"))
      ggsave(out_name, plot = plot_out, dpi = 25.4, height = 5, 
             width = width, units = "mm", device = "svg")
      img_plot <- readLines(out_name) %>% paste0(collapse = "") %>% 
        gt::html()
      on.exit(file.remove(out_name), add = TRUE)
      img_plot
    }
    tab_built <- lapply(X = x, FUN = bar_fx)
  })
  label_built <- if (length(labels) == 2) {
    lab_pal1 <- palette[1]
    lab_pal2 <- palette[2]
    lab1 <- labels[1]
    lab2 <- labels[2]
    glue::glue("<span style='color:{lab_pal1}'><b>{lab1}</b></span>", 
               "|", "<span style='color:{lab_pal2}'><b>{lab2}</b></span>") %>% 
      gt::html()
  }
  else {
    lab_pal1 <- palette[1]
    lab_pal2 <- palette[2]
    lab_pal3 <- palette[3]
    lab_pal4 <- palette[4]
    lab_pal5 <- palette[5]
    lab_pal6 <- palette[6]
    lab1 <- labels[1]
    lab2 <- labels[2]
    lab3 <- labels[3]
    lab4 <- labels[4]
    lab5 <- labels[5]
    lab6 <- labels[6]
    glue::glue("<span style='color:{lab_pal1}'><b>{lab1}</b></span>", 
               "|", "<span style='color:{lab_pal2}'><b>{lab2}</b></span>", 
               "|", "<span style='color:{lab_pal3}'><b>{lab3}</b></span>",
               "|", "<span style='color:{lab_pal4}'><b>{lab4}</b></span>",
               "|", "<span style='color:{lab_pal5}'><b>{lab5}</b></span>",
               "|", "<span style='color:{lab_pal6}'><b>{lab6}</b></span>") %>% 
      gt::html()
  }
  tab_out <- gtExtras:::dt_boxhead_edit_column_label(data = tab_out, var = var_bare, 
                                                     column_label = label_built)
  suppressWarnings(tab_out)
}

