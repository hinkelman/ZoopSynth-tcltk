
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

# need to loop through selections when not consecutive
for (i in c(0, 2)) tkselection.set(sources_lb, i)
# only select one size class initially
tkselection.set(sizes_lb, 1)
# if consecutive, can specify first and last index to select multiple
tkselection.set(months_lb, 5, 7)
# indexing is 0-based so this selects Jun-Aug
