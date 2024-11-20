
grid_inputs <- function(...){
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
  
  for (i in c(0, 2)) tkselection.set(sources_lb, i)
  tkselection.set(sizes_lb, 1)
  for (i in 5:7) tkselection.set(months_lb, i)
}
