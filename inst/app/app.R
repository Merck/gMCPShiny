# Packages ---------------------------------------------------------------------

library(shiny)
library(shinyjs)
library(markdown)
library(shinyMatrix)
library(ragg)
library(gsDesign)
library(gMCPLite)
library(gMCPShiny)
library(dplyr)

# Modules and global settings --------------------------------------------------

# Use `ragg::agg_png()` for plot outputs to make them cross-platform consistent.
# Importantly, this makes ellipse edges look smooth with proper anti-aliasing.
# Note this is experimental in shiny and may be superseded in the future.
# See <https://github.com/rstudio/shiny/blob/main/R/imageutils.R>
options(shiny.useragg = TRUE)

# Use JS to activate the last tab after creation
activate_last_tab_seqplot <- paste0(readLines("www/js/lasttab.js"), collapse = "\n")

# UI ---------------------------------------------------------------------------

ui <- function(request) {
  source("ui/main.R", local = TRUE)$value
}

# Server -----------------------------------------------------------------------

server <- function(input, output, session) {
  source("server/main.R", local = TRUE)$value
}

shinyApp(ui, server)
