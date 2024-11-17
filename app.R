library(tcltk)
library(zooper)
library(lubridate)
library(dplyr)
library(ggplot2)
library(plotly)

source_codes = c("EMP", "FRP", "FMWT", "STN", "20mm", "DOP")
size_codes = c("Micro", "Meso", "Macro")
zoop_data = NULL

grDevices::devAskNewPage(FALSE)
tclServiceMode(FALSE)
base <- tktoplevel()
tkwm.title(base, "ZoopSynth")

datatype = tclVar("Taxa")
min_yr = tclVar(1972)
max_yr = tclVar(2020)
months = tclVar()
tclvalue(months) = month.name
sources = tclVar()
tclvalue(sources) = c("Environmental Monitoring Program (EMP)", "Fish Restoration Program (FRP)",
                      "Fall Midwater Trawl (FMWT)", "Summer Townet Survey (STN)", "20mm Survey (20mm)",
                      "Directed Outflow Project (DOP)")
size_classes = tclVar()
tclvalue(size_classes) = size_codes

prep_data <- function(){
  # tkconfigure(fetch_label, text = "Fetching data...")
  zoop_data <<- Zoopsynther(Data_type = tclvalue(datatype),
                            Sources = source_codes[as.numeric(tkcurselection(sources_lb)) + 1],
                            Size_class = size_codes[as.numeric(tkcurselection(sizes_lb)) + 1],
                            Months = as.numeric(tkcurselection(months_lb)) + 1, 
                            Years = as.numeric(tclvalue(min_yr)):as.numeric(tclvalue(max_yr)),
                            All_env = FALSE) |> 
    mutate(Month = factor(month.abb[month(Date)], levels = month.abb)) |> 
    filter(CPUE > 0) |> 
    select(Source, Year, Month, SampleID) |> 
    distinct() |> 
    group_by(Source, Year, Month) |> 
    summarise(N_samples = n(), .groups = "drop")
}

mainframe = ttkframe(base, padding = c(10, 10, 10, 10))
sources_lb = tklistbox(mainframe, listvariable = sources, selectmode = "multiple", 
                       exportselection = FALSE, height = 6)
sizes_lb = tklistbox(mainframe, listvariable = size_classes, selectmode = "multiple", 
                     exportselection = FALSE, height = 3)
months_lb = tklistbox(mainframe, listvariable = months, selectmode = "multiple", 
                      exportselection = FALSE, height = 6)
fetch_label = ttklabel(mainframe, text = "")
# pb = ttkprogressbar(mainframe, mode = "indeterminate")

tkgrid(mainframe)
tkgrid(ttklabel(mainframe, text = "Data Type"),
       row = 0, column = 0, sticky = "w", padx = 5, pady = 5)
tkgrid(ttkradiobutton(mainframe, text = "Taxa", value = "Taxa", variable = datatype),
       row = 1, column = 0, sticky = "w", padx = 5)
tkgrid(ttkradiobutton(mainframe, text = "Community", value = "Community", variable = datatype),
       row = 1, column = 2, sticky = "w", padx = 5)

tkgrid(ttklabel(mainframe, text = "Sources"),
       row = 2, column = 0, sticky = "we", padx = 5, pady = 5)
tkgrid(sources_lb, row = 3, column = 0, columnspan = 3, sticky = "we", padx = 5)

tkgrid(ttklabel(mainframe, text = "Size Classes"),
       row = 4, column = 0, sticky = "we", padx = 5, pady = 5)
tkgrid(sizes_lb, row = 5, column = 0, columnspan = 3, sticky = "we", padx = 5)

tkgrid(ttklabel(mainframe, text = "Years"),
       row = 6, column = 0, sticky = "we", padx = 5, pady = 5)
tkgrid(ttkspinbox(mainframe, textvariable = min_yr, from = 1972, to = 2020, 
                  increment = 1, width = 5),
       row = 7, column = 0, sticky = "we", padx = 5)
tkgrid(ttklabel(mainframe, text = "-"),
       row = 7, column = 1, sticky = "we", padx = 5, pady = 5)
tkgrid(ttkspinbox(mainframe, textvariable = max_yr, from = 1972, to = 2020, 
                  increment = 1, width = 5),
       row = 7, column = 2, sticky = "we", padx = 5)

tkgrid(ttklabel(mainframe, text = "Months"),
       row = 8, column = 0, sticky = "we", padx = 5, pady = 5)
tkgrid(months_lb, row = 9, column = 0, columnspan = 3, sticky = "we", padx = 5)

tkgrid(tkbutton(mainframe, text = "Run", command = prep_data), 
       row = 10, column = 0, columnspan = 3, sticky = "we", padx = 5, pady = 5)

tkgrid(fetch_label, row = 11, column = 0, columnspan = 3, sticky = "we", padx = 5, pady = 5)

tkselection.set(sources_lb, 0)
tkselection.set(sizes_lb, 1)
for (i in 0:11) tkselection.set(months_lb, i)

tclServiceMode(TRUE)

if (!is.null(zoop_data)){
  print(head(zoop_data))
  myColors <- RColorBrewer::brewer.pal(6,"Set2")
  names(myColors) <- c("EMP", "FMWT", "STN", "20mm", "FRP", "DOP")
  
  p = ggplot(zoop_data, aes(x=Year, y = N_samples, fill = Source)) +
    geom_bar(stat = "identity") +
    facet_wrap(~ Month) +
    coord_cartesian(expand = 0) +
    scale_x_continuous(breaks = function(x) unique(floor(pretty(seq(min(x), max(x)), n = 4))), expand = c(0, 0)) +
    ylab("Number of plankton samples")+
    theme_bw()+
    theme(panel.grid = element_blank(), 
          strip.background = element_blank(), 
          text = element_text(size = 14), 
          panel.spacing.x = unit(15, "points")) +
    scale_fill_manual(name = "Source", values = myColors)
  
  ggplotly(p)
}

# # Start the main event loop
# tkwait.window(base)

