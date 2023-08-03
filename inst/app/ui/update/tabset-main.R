headerCard(
  "Outputs",
  tabsetPanel(
    tabPanel(
      "Iterative Graph Updates",
      uiOutput("theSeqPlot"),
      br(),
      hr(),
      actionButton("btn_modal_save_seq_png", label = "Save as PNG", class = "btn btn-outline-primary", icon = icon("download")),
      actionButton("btn_modal_save_seq_pdf", label = "Save as PDF", class = "btn btn-outline-primary", icon = icon("download"))
    ),
    tabPanel("Initial Designs",
             uiOutput("gsDesign")
             ),
    tabPanel(
      "Tabular",
      selectInput("TestResults",
                  label = "Test Results:",
                  c("Comparison of sequential p-values to graphs",
                    "Bounds at final allocated alpha")),
      uiOutput("TestResultsHTML"),
    ),
    tabPanel(
      "Report",
      rmdOutput("ReportText"),
      actionButton("btn_gmcp_rmd_modal", label = "Download Report (R Markdown)", class = "btn btn-outline-primary", icon = icon("download")),
      actionButton("btn_gmcp_html_modal", label = "Download Report (HTML)", class = "btn btn-outline-primary", icon = icon("download"))
    )
  )
)
