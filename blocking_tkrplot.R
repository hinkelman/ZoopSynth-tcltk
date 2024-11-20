### This version provides no information on long-running processes that block the GUI ###

library(tcltk)
library(tkrplot)
library(zooper)
library(lubridate)
library(dplyr)
library(ggplot2)

source("functions.R")

source_names = c("Environmental Monitoring Program (EMP)", "Fall Midwater Trawl (FMWT)", "Summer Townet Survey (STN)", 
                 "20mm Survey (20mm)", "Fish Restoration Program (FRP)", "Directed Outflow Project (DOP)")
source_codes = c("EMP", "FMWT", "STN", "20mm", "FRP", "DOP")
source_colors <- setNames(RColorBrewer::brewer.pal(6, "Set2"), source_codes)
size_codes = c("Micro", "Meso", "Macro")
zoop_data = NULL

tclServiceMode(FALSE)
base <- tktoplevel()
tkwm.title(base, "ZoopSynth")

datatype = tclVar("Community")
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
taxa = tclVar()
tclvalue(taxa) = completeTaxaList

fetch_and_plot <- function(...){
  tx = if (tclvalue(datatype) == "Taxa") completeTaxaList[as.numeric(tkcurselection(taxa_lb)) + 1] else NULL
  
  zoop_data <<- Zoopsynther(Data_type = tclvalue(datatype),
                            Sources = source_codes[as.numeric(tkcurselection(sources_lb)) + 1],
                            Size_class = size_codes[as.numeric(tkcurselection(sizes_lb)) + 1],
                            Taxa = tx,
                            Months = as.numeric(tkcurselection(months_lb)) + 1, 
                            Years = as.numeric(tclvalue(min_yr)):as.numeric(tclvalue(max_yr)),
                            All_env = FALSE) |> 
    prep_samples()
  
  tkrreplot(zoop_plot)
}

plot_zoop <- function(...){
  if (is.null(zoop_data)) return() # too early...
  plot_samples(zoop_data, source_colors)
}

mainframe = ttkframe(base, padding = c(10, 10, 10, 10))
sources_lb = tklistbox(mainframe, listvariable = sources, selectmode = "multiple", 
                       exportselection = FALSE, height = 6)
sizes_lb = tklistbox(mainframe, listvariable = size_classes, selectmode = "multiple", 
                     exportselection = FALSE, height = 3)
months_lb = tklistbox(mainframe, listvariable = months, selectmode = "multiple", 
                      exportselection = FALSE, height = 6)
taxa_lb = tklistbox(mainframe, listvariable = taxa, selectmode = "multiple", 
                      exportselection = FALSE, height = 6, state = "disabled")
zoop_plot = tkrplot(mainframe, plot_zoop, vscale = 1.2, hscale = 2)

tkgrid(mainframe)
tkgrid(ttklabel(mainframe, text = "Data Type"),
       row = 0, column = 0, sticky = "w", padx = 5, pady = 5)
tkgrid(ttkradiobutton(mainframe, text = "Taxa", value = "Taxa", variable = datatype,
                      command = function(...) tkconfigure(taxa_lb, state = "normal")),
       row = 1, column = 0, sticky = "w", padx = 5)
tkgrid(ttkradiobutton(mainframe, text = "Community", value = "Community", variable = datatype,
                      command = function(...) tkconfigure(taxa_lb, state = "disabled")),
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

tkgrid(ttklabel(mainframe, text = "Taxa"),
       row = 10, column = 0, sticky = "we", padx = 5, pady = 5)
tkgrid(taxa_lb, row = 11, column = 0, columnspan = 3, sticky = "we", padx = 5)

tkgrid(tkbutton(mainframe, text = "Run", command = fetch_and_plot), 
       row = 12, column = 0, columnspan = 3, sticky = "we", padx = 5, pady = 5)

tkgrid(zoop_plot, row = 0, column = 3, rowspan = 13, sticky = "nwes",
       padx = 5, pady = 5)

for (i in c(0, 2)) tkselection.set(sources_lb, i)
tkselection.set(sizes_lb, 1)
for (i in 5:7) tkselection.set(months_lb, i)

tclServiceMode(TRUE)
