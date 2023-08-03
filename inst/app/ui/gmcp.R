tabPanel(
  title = "Iterative Graph Updates",
  icon = icon("hourglass"),
  fluidRow(
    useShinyjs(),
    column(
      width = 10, offset = 1,
      fluidRow(
        column(
          width = 4,
          span("Update Iterative Graph", style = "font-size:1.5rem;")
        ),
      column(
        width = 8,
        tags$style("#btn_group_gmcp { float:right; }"),
        div(
          id = "btn_group_gmcp",
          actionButton("btn_gmcp_setting_modal", label = "Display Settings", class = "btn btn-outline-primary", icon = icon("cog")),
        )
      )
    ),
      hr(),
      fluidRow(
        column(
          width = 4,
          source("ui/update/tabset-sidebar.R", local = TRUE)$value
        ),
        column(
          width = 8,
          source("ui/update/tabset-main.R", local = TRUE)$value
        )
      )
    )
  )
)
