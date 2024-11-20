
prep_samples <- function(data){
  data |> 
    mutate(Month = factor(month.abb[month(Date)], levels = month.abb)) |> 
    filter(CPUE > 0) |> 
    select(Source, Year, Month, SampleID) |> 
    distinct() |> 
    group_by(Source, Year, Month) |> 
    summarise(N_samples = n(), .groups = "drop")
}

plot_samples <- function(data, source_colors){
  p = ggplot(data, aes(x=Year, y = N_samples, fill = Source)) +
    geom_bar(stat = "identity") +
    facet_wrap(~ Month) +
    coord_cartesian(expand = 0) +
    scale_x_continuous(breaks = function(x) unique(floor(pretty(seq(min(x), max(x)), n = 4))), expand = c(0, 0)) +
    ylab("Number of plankton samples") +
    theme_bw() +
    theme(panel.grid = element_blank(), 
          strip.background = element_blank(), 
          text = element_text(size = 14), 
          panel.spacing.x = unit(15, "points")) +
    scale_fill_manual(name = "Source", values = source_colors)
  plot(p)
}
