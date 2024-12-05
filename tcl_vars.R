
datatype = tclVar("Community")

sources = tclVar()
tclvalue(sources) = source_names

size_classes = tclVar()
tclvalue(size_classes) = size_codes

min_yr = tclVar(1972)
max_yr = tclVar(2020)

months = tclVar()
tclvalue(months) = month.name

taxa = tclVar()
tclvalue(taxa) = completeTaxaList

base <- tktoplevel()
tkwm.title(base, "ZoopSynth")
mainframe = ttkframe(base, padding = c(10, 10, 10, 10))

sources_lb = tklistbox(mainframe, listvariable = sources, selectmode = "multiple", 
                       exportselection = FALSE, height = 6)

sizes_lb = tklistbox(mainframe, listvariable = size_classes, selectmode = "multiple", 
                     exportselection = FALSE, height = 3)

months_lb = tklistbox(mainframe, listvariable = months, selectmode = "multiple", 
                      exportselection = FALSE, height = 6)

taxa_lb = tklistbox(mainframe, listvariable = taxa, selectmode = "multiple", 
                    exportselection = FALSE, height = 6, state = "disabled")

for (i in c(0, 2)) tkselection.set(sources_lb, i)
tkselection.set(sizes_lb, 1)
for (i in 5:7) tkselection.set(months_lb, i)
