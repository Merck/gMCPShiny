#------------------------------- Node Settings ---------------------------------
# Create a reactive value object to maintain the settings globally
rv_nodes <- reactiveValues(
  "wchar" = "\\u03b1",
  "digits" = 5,
  "width" = .75,
  "height" = .5,
  "size" = 8,
  "pal_name" = "gray",
  "pal_alpha" = 0.6,
  "set_nodepos" = FALSE
)

# Display settings modal (from Hypothesis tab)
observeEvent(input$btn_node_setting_modal, {
  showModal(modalDialog(
    title = "Node Display Settings",
    h5("Node shape and text format", style = "margin-top: 0.5rem;"),
    hr(),
    fluidRow(
      column(
        width = 3,
        numericInput(
          "width",
          label = tagList(
            "Width:",
            helpPopover(
              "halfWid",
              "Half width of ellipses."
            )
          ),
          value = rv_nodes$width, min = 0, max = 1, step = .01
        )
      ),
      column(
        width = 3,
        numericInput(
          "height",
          label = tagList(
            "Height:",
            helpPopover(
              "halfHgt",
              "Half height of ellipses."
            )
          ),
          value = rv_nodes$height, min = 0, max = 1, step = .01
        )
      ),
      column(
        width = 3,
        numericInput(
          "digits",
          label = tagList(
            "Digits:",
            helpPopover(
              "digits",
              "Number of digits past the decimal for siginificance level in the hypothesis nodes."
            )
          ),
          value = rv_nodes$digits, min = 1, max = 12, step = 1, width = "100%"
        )
      ),
      column(
        width = 3,
        numericInput(
          "size",
          label = tagList(
            "Text size:",
            helpPopover(
              "size",
              "Text size in ellipses."
            )
          ),
          value = rv_nodes$size, min = 1, max = 20, step = 1
        )
      )
    ),
    h5("Node symbol and colors", style = "margin-top: 1rem;"),
    hr(),
    fluidRow(
      column(
        width = 4,
        textInput(
          "wchar",
          label = tagList(
            "Symbol:",
            helpPopover(
              "wchar",
              "Symbol character representing significance level in the hypothesis nodes.
                  Use Unicode characters for Greek letters, for example, \\u03b1 for alpha.
                  Click the second icon for a more comprehensive character list."
            ),
            HTML('&nbsp;'),
            helpLink("https://en.wikipedia.org/wiki/List_of_Unicode_characters")
          ),
          value = rv_nodes$wchar, width = "100%"
        )
      ),
      column(
        width = 4,
        selectInput(
          "pal_name",
          label = tagList(
            "Palette:",
            helpPopover(
              "palette",
              "Colors for groups."
            )
          ),
          choices = c(
            "gray",
            "Okabe-Ito",
            "d3.category10",
            "d3.category20",
            "d3.category20b",
            "d3.category20c",
            "Teal"
          ), selected = rv_nodes$pal_name
        )
      ),
      column(
        width = 4,
        numericInput(
          "pal_alpha",
          label = tagList(
            "Transparency:",
            helpPopover(
              "Color transparency",
              "Number ranging from 0 to 1, with lower values corresponding to more transparent colors."
            )
          ),
          value = rv_nodes$pal_alpha, min = 0, max = 1, step = 0.01, width = "100%"
        )
      )
    ),
    h5("Node position", style = "margin-top: 1rem;"),
    hr(),
    checkboxInput("set_nodepos", label = "Customize Node Position", value = rv_nodes$set_nodepos, width = "100%"),
    easyClose = FALSE,
    footer = tagList(
      actionButton("btn_node_settings_save", label = "Save Settings", class = "btn-primary", icon = icon("floppy-disk")),
      modalButton("Cancel")
    )
  ))
})

observeEvent(input$btn_node_settings_save, {
  rv_nodes$wchar <- input$wchar
  rv_nodes$digits <- input$digits
  rv_nodes$width <- input$width
  rv_nodes$height <- input$height
  rv_nodes$size <- input$size
  rv_nodes$pal_name <- input$pal_name
  rv_nodes$pal_alpha <- input$pal_alpha
  rv_nodes$set_nodepos <- input$set_nodepos
  removeModal()
})
#------------------------------- Dynamic UI for Node position ------------------

output$setNodepos <- renderUI({
  if (rv_nodes$set_nodepos) {
    tagList(
      br(),
      matrixInput(
        "nodeposMatrix",
        label = tagList(
          "Customize node position:",
          helpPopover(
            "Node position matrix",
            "The \"Hypotheses\" requires text input, shoud match hypotheses names.
                  The \"x\", \"y\" numeric inputs are coordinates for the
                  relative position of the hypothesis ellipses."
          )
        ),
        value = as.matrix(data.frame(cbind(
          Hypothesis = paste0("H", 1:4),
          x = c(-1, 1, 1, -1),
          y = c(1, 1, -1, -1)
        ))),
        class = "character",
        rows = list(names = FALSE, editableNames = FALSE, extend = FALSE),
        cols = list(names = TRUE, editableNames = FALSE, extend = FALSE)
      ),
      actionButton(
        "btn_nodeposMatrix_reset_init",
        label = "Sync and Reset",
        icon = icon("arrows-rotate"),
        width = "100%",
        class = "btn btn-block btn-outline-primary"
      )
  )}
})

#------------------------------- Edge Settings ---------------------------------
# Create a reactive value object to maintain the settings globally
rv_edges <- reactiveValues(
  "trhw" = .13,
  "trhh" = .1,
  "trdigits" = 4,
  "boxtextsize" = 6,
  "trprop" = .33,
  "arrowsize" = .035,
  "offset" = .15
)

# Display settings modal (from Transition tab)
observeEvent(input$btn_edge_setting_modal, {
  showModal(modalDialog(
    title = "Edge Display Settings",
    h5("Transition box shape and text format", style = "margin-top: 0.5rem;"),
    hr(),
    fluidRow(
      column(
        width = 3,
        numericInput(
          "trhw",
          label = tagList(
            "Width:",
            helpPopover(
              "trhw",
              "Transition box width."
            )
          ),
          value = rv_edges$trhw, min = 0, max = 1, step = .01
        )
      ),
      column(
        width = 3,
        numericInput(
          "trhh",
          label = tagList(
            "Height:",
            helpPopover(
              "trhh",
              "Transition box height."
            )
          ),
          value = rv_edges$trhh, min = 0, max = 1, step = .01
        )
      ),
      column(
        width = 3,
        numericInput(
          "trdigits",
          label = tagList(
            "Digits:",
            helpPopover(
              "trdigits",
              "Number of digits past the decimal for transition weights in the transition box."
            )
          ),
          value = rv_edges$trdigits, min = 1, max = 10, step = 1, width = "100%"
        )
      ),
      column(
        width = 3,
        numericInput(
          "boxtextsize",
          label = tagList(
            "Text size:",
            helpPopover(
              "boxtextsize",
              "Transition text size."
            )
          ),
          value = rv_edges$boxtextsize, min = 1, max = 20, step = 1
        )
      )
    ),
    h5("Edge layout", style = "margin-top: 1rem;"),
    hr(),
    fluidRow(
      column(
        width = 4,
        numericInput(
          "arrowsize",
          label = tagList(
            "Arrow size:",
            helpPopover(
              "arrowsize",
              "Size of arrowhead for transition arrows."
            )
          ),
          value = rv_edges$arrowsize, min = .005, max = .6, step = .005
        )
      ),
      column(
        width = 4,
        numericInput(
          "offset",
          label = tagList(
            "Offset:",
            helpPopover(
              "offset",
              "Rotational offset in radians for transition edges,
            can control space between neighbor edges."
            )
          ), value = rv_edges$offset, min = 0.01, max = 1, step = 0.01
        )
      ),
      column(
        width = 4,
        numericInput(
          "trprop",
          label = tagList(
            "Box position:",
            helpPopover(
              "trprop",
              "Transition box's position proportional to edge length
            (relative to the edge starting point), value can be set between 0 and 1."
            )
          ), value = rv_edges$trprop, min = 0, max = 1, step = 0.01, width = "100%"
        )
      )
    ),
    easyClose = FALSE,
    footer = tagList(
      actionButton("btn_edge_settings_save", label = "Save Settings", class = "btn-primary", icon = icon("floppy-disk")),
      modalButton("Cancel")
    )
  ))
})

observeEvent(input$btn_edge_settings_save, {
  rv_edges$trhw <- input$trhw
  rv_edges$trhh <- input$trhh
  rv_edges$trdigits <- input$trdigits
  rv_edges$boxtextsize <- input$boxtextsize
  rv_edges$trprop <- input$trprop
  rv_edges$arrowsize <- input$arrowsize
  rv_edges$offset <- input$offset
  removeModal()
})




#------------------------------- Digits Settings ---------------------------------
rv_digits <- reactiveValues("digits" = 4, "ddigits" = 2, "tdigits" = 1)

# Display settings modal (from gmcp tab)
observeEvent(input$btn_gmcp_setting_modal, {
  showModal(modalDialog(
    title = "Display Settings",
    h5("Numeric Formats", style = "margin-top: 0;"),
    hr(),
    numericInput("setting_digits",
                 label = tagList(
                   "digits:",
                   helpPopover(
                     "digits",
                     "Number of digits past the decimal to be printed in the body of the table"
                   )
                 ), value = rv_digits$digits, min = 1, max = 10, step = 1, width = "100%"
    ),
    numericInput("setting_ddigits",
                 label = tagList(
                   "ddigits:",
                   helpPopover(
                     "ddigits",
                     "Number of digits past the decimal to be printed for the natural parameter delta"
                   )
                 ), value = rv_digits$ddigits, min = 1, max = 10, step = 1, width = "100%"
    ),
    numericInput("setting_tdigits",
                 label = tagList(
                   "tdigits:",
                   helpPopover(
                     "tdigits",
                     "Number of digits past the decimal point to be shown for estimated timing of each analysis"
                   )
                 ), value = rv_digits$tdigits, min = 0, max = 10, step = 1, width = "100%"
    ),
    hr(),
    easyClose = TRUE,
    footer = tagList(
      actionButton("btn_gmcp_settings_save", label = "Save Settings", class = "btn-primary", icon = icon("save")),
      modalButton("Cancel")
    )
  ))
})

observeEvent(input$btn_gmcp_settings_save, {
  rv_digits$digits <- input$setting_digits
  rv_digits$ddigits <- input$setting_ddigits
  rv_digits$tdigits <- input$setting_tdigits
  removeModal()
})
