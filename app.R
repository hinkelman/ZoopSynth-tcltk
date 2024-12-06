# loads packages and global variables
source("globals.R")
# need to source functions.R before tcl_vars.R
source("functions.R")
# keeps from drawing UI until it is complete
tclServiceMode(FALSE)
# create tcl variables and objects
source("tcl_vars.R")

# includes the main input grid
source("ui.R")
grid_inputs()
# add run button with correct command
tkgrid(tkbutton(mainframe, text = "Run", command = fetch_and_plot), 
       row = 12, column = 0, columnspan = 3, sticky = "we", padx = 5, pady = 5)

# show UI
tclServiceMode(TRUE)
# Start the main event loop
tkwait.window(base)
