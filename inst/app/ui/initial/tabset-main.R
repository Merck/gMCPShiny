headerCard(
  "Outputs",
  tabsetPanel(
    tabPanel(
      "Graph",
      plotOutput("thePlot"),
      br(),
      hr(),
      actionButton("btn_modal_save_png", label = "Save as PNG", class = "btn btn-outline-primary", icon = icon("download")),
      actionButton("btn_modal_save_pdf", label = "Save as PDF", class = "btn btn-outline-primary", icon = icon("download"))
    ),
    tabPanel(
      "Code",
      rcodeOutput("changingCode"),
      downloadButton("downloadCode", label = "Save R Code", class = "btn btn-outline-primary")
    )
  )
)
