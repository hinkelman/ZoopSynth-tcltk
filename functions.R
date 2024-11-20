
prep_samples <- function(data){
  tmp = data |>
    mutate(MonthNum = month(Date)) |> 
    filter(CPUE > 0) |> 
    select(Source, Year, MonthNum, SampleID) |> 
    distinct() |> 
    group_by(Source, Year, MonthNum) |> 
    summarise(N_samples = n(), .groups = "drop")
  
  tmp |> 
    mutate(Month = factor(month.abb[MonthNum], 
                          levels = month.abb[sort(unique(tmp$MonthNum))])) |> 
    select(-MonthNum) |> 
    tidyr::complete(Source, Year, Month, fill = list(N_samples = NA_integer_))
}

plot_samples <- function(data, source_colors){
  p = ggplot(data, aes(x=Year, y = N_samples, color = Source)) +
    geom_line() +
    geom_point() +
    facet_wrap(~ Month) +
    coord_cartesian(expand = 0) +
    scale_x_continuous(breaks = function(x) unique(floor(pretty(seq(min(x), max(x)), n = 4))), expand = c(0, 0)) +
    ylab("Number of plankton samples") +
    theme_bw() +
    theme(panel.grid = element_blank(), 
          strip.background = element_blank(), 
          text = element_text(size = 14), 
          panel.spacing.x = unit(15, "points")) +
    scale_color_manual(name = "Source", values = source_colors)
  plot(p)
}
