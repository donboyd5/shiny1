# https://github.com/kjhealy/socviz/blob/master/R/utility_functions.r

##' color_pal(c("#66C2A5", "#FC8D62", "#8DA0CB"))
color_pal <- function(col, border = "gray70", ...) {
  n <- length(col)
  graphics::plot(0, 0, type="n", xlim = c(0, 1), ylim = c(0, 1),
                 axes = FALSE, xlab = "", ylab = "", ...)
  graphics::rect(0:(n-1)/n, 0, 1:n/n, 1, col = col, border = border)
}


##' mtcars %>% freq_tab(vs, gear, carb)
##'
##' @export
freq_tab <- function (df, ...)
{
  grouping <- rlang::quos(...)
  n <- NULL
  
  if(dplyr::is_grouped_df(df)) {
    out_tbl <- df %>% dplyr::count(!!!grouping)
  } else {
    out_tbl <- df %>% dplyr::group_by(!!!grouping) %>% dplyr::count()
  }
  
  n_groups <- length(dplyr::group_vars(out_tbl))
  
  if(n_groups == 1) {
    out_tbl %>% dplyr::ungroup() %>%
      dplyr::mutate(freq = n/sum(n))
  } else {
    outer_group <- dplyr::groups(out_tbl)[[1]]
    out_tbl %>% dplyr::group_by(!!outer_group) %>%
      dplyr::mutate(prop = prop.table(n))
  }
}
