headerCard(
  "Inputs",
  tabsetPanel(
    type = "tabs",
    tabPanel(
      "Hypotheses",
      style = "overflow-y: auto; overflow-x: hidden; max-height: 700px",
      matrixInput(
        "hypothesesMatrix",
        label = tagList(
          "Set hypotheses:",
          helpPopover(
            "Hypotheses matrix",
            "\"Name\" and \"Group\" require text input, \"Alpha\" requires numeric input.
            The text inputs support Unicode escape sequence like `\\uABCD` for
            special characters. Click the second icon for a more comprehensive character list.
            Use `\\n` to add a line break. See `?Quotes` for details."
          ),
          HTML("&nbsp;"),
          helpLink("https://en.wikipedia.org/wiki/List_of_Unicode_characters")
        ),
        value = as.matrix(data.frame(cbind(
          Name = paste0("H", 1:4),
          Alpha = rep(0.025 / 4, 4),
          Group = LETTERS[1:4]
        ))),
        class = "character",
        rows = list(names = FALSE, editableNames = FALSE, extend = FALSE),
        cols = list(names = TRUE, editableNames = FALSE, extend = FALSE)
      ),
      matrixButtonGroup("hypothesesMatrix"),
      hr(),
      actionButton(
        "btn_node_setting_modal",
        label = "More Node Settings",
        class = "btn btn-outline-primary",
        icon = icon("gear"),
        width = "100%"
      ),
      br(),
      uiOutput("setNodepos")
    ),
    tabPanel(
      "Transitions",
      style = "overflow-y: auto; overflow-x: hidden; max-height: 700px",
      matrixInput("trwtMatrix",
        label = tagList(
          "Set transition weights:",
          helpPopover(
            "Transition weights matrix",
            "\"From\" and \"To\" requires text input, shoud match hypotheses names.
            \"Weight\" supports numeric input and arithmetic expressions, should range between 0 and 1.
              Transitions between non-existing hypotheses will not affect graph output."
          )
        ),
        value = as.matrix(data.frame(cbind(
          From = paste0("H", c(1, 2, 3, 4)),
          To = paste0("H", c(2, 3, 4, 1)),
          Weight = rep(1, 4)
        ))),
        class = "character",
        rows = list(names = FALSE, editableNames = FALSE, extend = FALSE),
        cols = list(names = TRUE, editableNames = FALSE, extend = FALSE)
      ),
      actionButton(
        "btn_trwtMatrix_reset_init",
        label = "Sync and Reset",
        icon = icon("arrows-rotate"),
        width = "100%",
        class = "btn btn-block btn-outline-primary"
      ),
      hr(),
      actionButton(
        "btn_edge_setting_modal",
        label = "More Edge Settings",
        class = "btn btn-outline-primary",
        icon = icon("gear"),
        width = "100%"
      )
    ),
    tabPanel(
      "Labels",
      style = "overflow-y: auto; overflow-x: hidden; max-height: 700px",
      ## Legend UI
      selectInput(
        "legendPosition",
        label = tagList(
          "Legend position:",
          helpPopover(
            "legendPosition",
            "Select legend position, select \"none\" to turn off legend."
          )
        ),
        choices = c("none", "left", "right", "bottom", "top"),
        selected = "bottom",
        multiple = FALSE
      ),
      conditionalPanel(
        condition = "input.legendPosition != 'none'",
        textInput(
          "legend.name",
          label = tagList(
            "Legend name:",
            helpPopover(
              "legend.name",
              "Text for legend name"
            )
          ),
          value = "Group Name"
        ),
        numericInput(
          "legend.textsize",
          label = tagList(
            "Legend text size:",
            helpPopover(
              "legend.textsize",
              "Legend text size"
            )
          ),
          value = 20, min = 6, max = 50, step = 1
        )
      ),
      hr(),
      ## Title UI
      textInput(
        "plotTitle",
        label = tagList(
          "Title:",
          helpPopover(
            "plotTitle",
            "Title of the plot (optional), leave bank to turn off title"
          )
        ),
        value = ""
      ),
      conditionalPanel(
        condition = "input.plotTitle != ''",
        selectInput(
          "title.position",
          label = tagList(
            "Title position:",
            helpPopover(
              "title.position",
              "Position of the plot title"
            )
          ),
          choices = c("left" = 0, "center" = 0.5, "right" = 1),
          selected = 0.5,
          multiple = FALSE
        ),
        numericInput(
          "title.textsize",
          label = tagList(
            "Title text size:",
            helpPopover(
              "title.textsize",
              "Text size of the plot title"
            )
          ),
          value = 20, min = 6, max = 200, step = 1
        )
      ),
      hr(),
      ## Caption UI
      textInput(
        "plotCaption",
        label = tagList(
          "Caption/footnote:",
          helpPopover(
            "plotCaption",
            "Caption of the plot (optional), leave bank to turn off caption/footnote"
          )
        ),
        value = ""
      ),
      conditionalPanel(
        condition = "input.plotCaption != ''",
        selectInput(
          "caption.position",
          label = tagList(
            "Caption/footnote position:",
            helpPopover(
              "title.position",
              "Position of the plot caption/footnote"
            )
          ),
          choices = c("left" = 0, "center" = 0.5, "right" = 1),
          selected = 0.5,
          multiple = FALSE
        ),
        numericInput(
          "caption.textsize",
          label = tagList(
            "Caption/footnote text size:",
            helpPopover(
              "caption.textsize",
              "Text size of the plot caption/footnote"
            )
          ),
          value = 20, min = 6, max = 200, step = 1
        )
      )

    )
  )
)
