
fetch <- function(...){
  tx = if (tclvalue(datatype) == "Taxa") completeTaxaList[as.numeric(tkcurselection(taxa_lb)) + 1] else NULL
  
  zoop_data <<- Zoopsynther(Data_type = tclvalue(datatype),
                            Sources = source_codes[as.numeric(tkcurselection(sources_lb)) + 1],
                            Size_class = size_codes[as.numeric(tkcurselection(sizes_lb)) + 1],
                            Taxa = tx,
                            Months = as.numeric(tkcurselection(months_lb)) + 1, 
                            Years = as.numeric(tclvalue(min_yr)):as.numeric(tclvalue(max_yr)),
                            All_env = FALSE) |> 
    prep_samples()
}

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

fetch_and_tkrreplot <- function(...){
  fetch()
  tkrplot::tkrreplot(zoop_plot)
}

tkrplot_zoop <- function(...){
  if (is.null(zoop_data)){
    plot(ggplot())
  } else {
    tkrplot_samples(zoop_data, source_colors)
  }
}

fetch_and_plot <- function(...){
  fetch()
  plot_zoop()
}

plot_zoop <- function(...){
  plot_samples(zoop_data, source_colors)
}

tkrplot_samples <- function(data, source_colors){
  # plots in window provided by trkplot
  plot(ggplot_samples(data, source_colors))
}

plot_samples <- function(data, source_colors){
  # need to open device window before plotting
  # set the device type based on the OS
  os = Sys.info()[['sysname']]
  if (os == "Darwin"){
    quartz(width = 12)
  } else if (os == "Windows") {
    windows(width = 12)
  } else {
    X11(width = 12)
  }
  
  plot(ggplot_samples(data, source_colors))
}

ggplot_samples <- function(data, source_colors){
  ggplot(data, aes(x=Year, y = N_samples, color = Source)) +
    geom_line() +
    geom_point(size = 1) +
    facet_wrap(~ Month) +
    scale_x_continuous(breaks = function(x) unique(floor(pretty(seq(min(x), max(x)), n = 4)))) +
    ylab("Number of plankton samples") +
    theme_minimal() +
    theme(text = element_text(size = 14),
          panel.spacing.x = unit(15, "points")) +
    scale_color_manual(name = "Source", values = source_colors)
}
