options(scipen = 999) # Enforce disabling scientific notation


# Create plot ------------------------------------------------------------------

plotInput <- reactive({
  Trans <- data.frame(input$trwtMatrix)
  keepTransRows <- (Trans[, 1] %in% input$hypothesesMatrix[, 1]) & (Trans[, 2] %in% input$hypothesesMatrix[, 1])
  transitions <- Trans[keepTransRows, ]

  ## Ensure m and alphaHypotheses converted from different types to numeric
  m <- df2graph(namesH = input$hypothesesMatrix[, 1], df = transitions)
  alphaHypotheses <- sapply(input$hypothesesMatrix[, "Alpha"], arithmetic_to_numeric)

  gMCPLite::hGraph(
    nHypotheses = nrow(input$hypothesesMatrix),
    nameHypotheses = stringi::stri_unescape_unicode(input$hypothesesMatrix[, "Name"]),
    alphaHypotheses = alphaHypotheses,
    m = m,
    fill = factor(stringi::stri_unescape_unicode(input$hypothesesMatrix[, "Group"]),
      levels = unique(stringi::stri_unescape_unicode(input$hypothesesMatrix[, "Group"]))
    ),
    palette = hgraph_palette(pal_name = rv_nodes$pal_name, n = length(unique(input$hypothesesMatrix[, "Group"])), alpha = rv_nodes$pal_alpha),
    labels = unique(stringi::stri_unescape_unicode(input$hypothesesMatrix[, "Group"])),
    legend.name = stringi::stri_unescape_unicode(input$legend.name),
    legend.position = input$legendPosition,
    halfWid = rv_nodes$width,
    halfHgt = rv_nodes$height,
    trhw = rv_edges$trhw,
    trhh = rv_edges$trhh,
    trprop = rv_edges$trprop,
    digits = rv_nodes$digits,
    trdigits = rv_edges$trdigits,
    size = rv_nodes$size,
    boxtextsize = rv_edges$boxtextsize,
    legend.textsize = input$legend.textsize,
    arrowsize = rv_edges$arrowsize,
    offset = rv_edges$offset,
    x = if (is.null(input$nodeposMatrix[, "x"]) | !setequal(input$nodeposMatrix[, "Hypothesis"], input$hypothesesMatrix[, "Name"])) {
      NULL
    } else {
      as.numeric(input$nodeposMatrix[, "x"])
    },
    y = if (is.null(input$nodeposMatrix[, "y"]) | !setequal(input$nodeposMatrix[, "Hypothesis"], input$hypothesesMatrix[, "Name"])) {
      NULL
    } else {
      as.numeric(input$nodeposMatrix[, "y"])
    },
    wchar = stringi::stri_unescape_unicode(rv_nodes$wchar)
  ) +
    ggplot2::labs(
      title = stringi::stri_unescape_unicode(input$plotTitle),
      caption = stringi::stri_unescape_unicode(input$plotCaption)
    ) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(size = input$title.textsize, hjust = input$title.position),
      plot.caption = ggplot2::element_text(size = input$caption.textsize, hjust = input$caption.position)
    )
})

output$thePlot <- renderPlot({
  print(plotInput())
})
outputOptions(output, "thePlot", suspendWhenHidden = FALSE) # thePlot runs even when not visible

# Output for graph code that changes based on user inputs
getChangingCode <- reactive({
  report <- tempfile(fileext = ".R")
  brew::brew("templates/call-hgraph.R", output = report)
  paste0(readLines(report), collapse = "\n")
})

output$changingCode <- renderRcode({
  htmltools::htmlEscape(getChangingCode())
})

# Download graph code
output$downloadCode <- downloadHandler(
  filename = "hgraph.R",
  content = function(file) {
    write(getChangingCode(), file)
  }
)
