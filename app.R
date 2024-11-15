library(tcltk)
library(zooper)

source_codes = c("EMP", "FRP", "FMWT", "STN", "20mm", "DOP")
size_codes = c("Micro", "Meso", "Macro")

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

mainframe <- ttkframe(base, padding = c(6, 6, 6, 6))
sources_lb = tklistbox(mainframe, listvariable = sources, selectmode = "multiple", 
                       exportselection = FALSE, height = 6)
sizes_lb = tklistbox(mainframe, listvariable = size_classes, selectmode = "multiple", 
                     exportselection = FALSE, height = 3)
months_lb = tklistbox(mainframe, listvariable = months, selectmode = "multiple", 
                      exportselection = FALSE, height = 6)

fetch_data <- function(){
  out = Zoopsynther(Data_type = tclvalue(datatype),
                    Sources = source_codes[as.numeric(tkcurselection(sources_lb)) + 1],
                    Size_class = size_codes[as.numeric(tkcurselection(sizes_lb)) + 1],
                    Months = as.numeric(tkcurselection(months_lb)) + 1, 
                    Years = as.numeric(tclvalue(min_yr)):as.numeric(tclvalue(max_yr)),
                    All_env = FALSE)
  print(head(out))
}

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

tkgrid(tkbutton(mainframe, text = "Run", command = fetch_data),
       row = 10, column = 0, columnspan = 3, sticky = "we", padx = 5, pady = 5)

tclServiceMode(TRUE)
# # Start the main event loop
# tkwait.window(base)

