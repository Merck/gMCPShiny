headerCard(
  "Inputs",
  tabsetPanel(
    type = "tabs",
    tabPanel(
      style = "overflow-y: auto; overflow-x: hidden; max-height: 700px",
      "Testing",
      selectInput(
        inputId = "knowpval",
        label = tagList(
          "Graph update strategy:",
          helpPopover(
            "knowpval",
            "Select graph update strategy based on whether observed p-values are used."
          )
        ),
        choices = c(
          "Reject hypotheses directly and pass \u03b1" = "no",
          "Reject hypotheses based on observed p-values" = "yes"
        )
      ),
      conditionalPanel(
        condition = "input.knowpval == 'no'",
        uiOutput("reject_update_ui")
      ),
      conditionalPanel(
        condition = "input.knowpval == 'yes'",
        uiOutput("pval_update_ui")
      )
    )
  )
)
