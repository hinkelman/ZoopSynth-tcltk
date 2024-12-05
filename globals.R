library(tcltk)
library(zooper)
library(lubridate)
library(dplyr)
library(ggplot2)

source_names = c("Environmental Monitoring Program (EMP)", "Fall Midwater Trawl (FMWT)", 
                 "Summer Townet Survey (STN)", "20mm Survey (20mm)", 
                 "Fish Restoration Program (FRP)", "Directed Outflow Project (DOP)")
source_codes = c("EMP", "FMWT", "STN", "20mm", "FRP", "DOP")
source_colors <- setNames(RColorBrewer::brewer.pal(6, "Set2"), source_codes)
size_codes = c("Micro", "Meso", "Macro")
zoop_data = NULL
