
base <- tktoplevel()
tkwm.title(base, "ZoopSynth")
datatype = tclVar("Community")
min_yr = tclVar(1972)
max_yr = tclVar(2020)
months = tclVar()
tclvalue(months) = month.name
sources = tclVar()
tclvalue(sources) = source_names
size_classes = tclVar()
tclvalue(size_classes) = size_codes
taxa = tclVar()
tclvalue(taxa) = completeTaxaList

mainframe = ttkframe(base, padding = c(10, 10, 10, 10))
sources_lb = tklistbox(mainframe, listvariable = sources, selectmode = "multiple", 
                       exportselection = FALSE, height = 6)
sizes_lb = tklistbox(mainframe, listvariable = size_classes, selectmode = "multiple", 
                     exportselection = FALSE, height = 3)
months_lb = tklistbox(mainframe, listvariable = months, selectmode = "multiple", 
                      exportselection = FALSE, height = 6)
taxa_lb = tklistbox(mainframe, listvariable = taxa, selectmode = "multiple", 
                    exportselection = FALSE, height = 6, state = "disabled")
