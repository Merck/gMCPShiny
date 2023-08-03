tabPanel(
  title = "About",
  icon = icon("circle-info"),
  fluidRow(
    column(
      width = 10, offset = 1,
      fluidRow(
        column(
          width = 12,
          span("About", style = "font-size:1.5rem;")
        )
      ),
      hr(),
      tags$style("#panel_about { padding: 32px 32px; }"),
      headerCard(
        "About gMCPShiny",
        id = "panel_about",
        includeMarkdown("include/about.md")
      )
    )
  )
)
