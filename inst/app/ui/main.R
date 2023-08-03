navbarFluidPage(
  id = "hgraphnav",
  title = "Multiplicity Graphs for Hypothesis Testing",
  brand_image = "images/favicon.png",
  brand_image_width = "22px",
  brand_image_height = "22px",
  lang = "en",
  theme = bslib::bs_theme(
    version = 5,
    primary = "#00857c",
    "navbar-light-brand-color" = "#212529",
    "navbar-light-brand-hover-color" = "#212529",
    "navbar-light-bg" = "#fff",
    "navbar-light-color" = "#212529",
    "navbar-light-active-color" = "#00857c",
    "navbar-light-hover-color" = "#00857c",
    "popover-header-bg" = "#f8f9fa",
    "popover-border-color" = "#dee2e6"
  ),
  inverse = FALSE,
  collapsible = TRUE,
  header = tags$head(
    tags$link(rel = "shortcut icon", type = "image/png", href = "images/favicon.png"),
    tags$link(rel = "stylesheet", type = "text/css", href = "css/custom.css"),
    tags$script(src = "js/beforeunload.js")
  ),
  source("ui/hgraph.R", local = TRUE)$value,
  source("ui/gmcp.R", local = TRUE)$value,
  source("ui/about.R", local = TRUE)$value,
  footer = source("ui/footer.R", local = TRUE)$value
)
