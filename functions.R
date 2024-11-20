
prep_samples <- function(data){
  tmp = data |>
    mutate(MonthNum = month(Date)) |> 
    filter(CPUE > 0) |> 
    select(Source, Year, MonthNum, SampleID) |> 
    distinct() |> 
    group_by(Source, Year, MonthNum) |> 
    summarise(N_samples = n(), .groups = "drop")
  
  tmp |> 
    mutate(Month = factor(month.name[MonthNum], 
                          levels = month.name[sort(unique(tmp$MonthNum))])) |> 
    select(-MonthNum) |> 
    tidyr::complete(Source, Year, Month, fill = list(N_samples = NA_integer_))
}

plot_samples <- function(data, source_colors){
  p = ggplot(data, aes(x=Year, y = N_samples, color = Source)) +
    geom_line() +
    geom_point(size = 1) +
    facet_wrap(~ Month) +
    scale_x_continuous(breaks = function(x) unique(floor(pretty(seq(min(x), max(x)), n = 4)))) +
    ylab("Number of plankton samples") +
    theme_minimal() +
    theme(text = element_text(size = 14),
          panel.spacing.x = unit(15, "points")) +
    scale_color_manual(name = "Source", values = source_colors)
  plot(p)
}
