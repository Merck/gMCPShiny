tabPanel(
  title = "Initial Graph Setup",
  icon = icon("compass-drafting"),
  useShinyjs(),
  fluidRow(
    column(
      width = 10, offset = 1,
      fluidRow(
        column(
          width = 4,
          span("Create Multiplicity Graph", style = "font-size:1.5rem;")
        ),
        column(
          width = 8,
          tags$style("#btn_group_design { float:right; }"),
          div(
            id = "btn_group_design",
            actionButton("btn_design_save_modal", label = "Save hgraph", class = "btn btn-outline-primary", icon = icon("download")),
            fileButtonInput("btn_design_restore", label = NULL, buttonLabel = "Restore hgraph", multiple = FALSE, accept = ".rds", width = "50%"),
            actionButton("btn_hgraph_example_modal", label = "Load Example", class = "btn btn-outline-primary", icon = icon("chart-bar"))
          )
        )
      ),
      hr(),
      fluidRow(
        column(
          width = 4,
          source("ui/initial/tabset-sidebar.R", local = TRUE)$value
        ),
        column(
          width = 8,
          source("ui/initial/tabset-main.R", local = TRUE)$value
        )
      )
    )
  )
)
