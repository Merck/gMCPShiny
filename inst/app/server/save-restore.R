# Save design modal (from Design tab)
observeEvent(input$btn_design_save_modal, {
  showModal(modalDialog(
    title = "Save Graph Design",
    textInputAddonRight("filename_rds_design", label = "Name the hgraph design:", value = "hgraph", addon = ".rds", width = "100%"),
    easyClose = TRUE,
    footer = tagList(
      downloadButton("btn_design_save", label = "Save Graph Design", class = "btn-primary", icon = icon("download")),
      modalButton("Cancel")
    )
  ))
})

# Save hgraph design object, all input parameters, and reactive values
output$btn_design_save <- downloadHandler(
  filename = function() {
    x <- input$filename_rds_design
    # sanitize from input
    fn0 <- if (x == "") "design" else sanitize_filename(x)
    # sanitize again
    fn <- if (fn0 == "") "design" else fn0
    paste0(fn, ".rds")
  },
  content = function(con) {

    # Get inputs
    hgraph_inputs <- lapply(isolate(reactiveValuesToList(input)), unclass)
    # Remove all irrelevant input values
    hgraph_inputs[which(grepl(
      "btn_|hgraphnav",
      names(hgraph_inputs)
    ))] <- NULL

    # Get reactive values
    node_settings <- list("rv_nodes" = isolate(reactiveValuesToList(rv_nodes)))
    edge_settings <- list("rv_edges" = isolate(reactiveValuesToList(rv_edges)))


    # Save to file
    lst <- list("hgraph_inputs" = hgraph_inputs, "node_settings" = node_settings, "edge_settings" = edge_settings)
    saveRDS(lst, file = con)
  }
)

# Restore hgraph parameters
observeEvent(input$btn_design_restore, {
  rds <- input$btn_design_restore
  req(rds)
  lst <- readRDS(rds$datapath)
  hgraph_inputs <- lst$hgraph_inputs

  # Restore regular inputs and matrix inputs separately
  is_matrix_input <- unname(sapply(
    lapply(lst$hgraph_inputs, class),
    FUN = function(x) "matrix" %in% x
  ))

  lapply(
    names(hgraph_inputs)[is_matrix_input],
    function(x) updateMatrixInput(session, inputId = x, value = hgraph_inputs[[x]])
  )

  lapply(
    names(hgraph_inputs)[!is_matrix_input],
    function(x) session$sendInputMessage(x, list(value = hgraph_inputs[[x]]))
  )


  # Restore global reactive values
  node_settings <- lst$node_settings

  rv_nodes$wchar <- node_settings$rv_nodes$wchar
  rv_nodes$digits <- node_settings$rv_nodes$digits
  rv_nodes$width <- node_settings$rv_nodes$width
  rv_nodes$height <- node_settings$rv_nodes$height
  rv_nodes$size <- node_settings$rv_nodes$size
  rv_nodes$pal_name <- node_settings$rv_nodes$pal_name
  rv_nodes$pal_alpha <- node_settings$rv_nodes$pal_alpha
  rv_nodes$set_nodepos <- node_settings$rv_nodes$set_nodepos

  edge_settings <- lst$edge_settings

  rv_edges$trhw <- edge_settings$rv_edges$trhw
  rv_edges$trhh <- edge_settings$rv_edges$trhh
  rv_edges$trdigits <- edge_settings$rv_edges$trdigits
  rv_edges$boxtextsize <- edge_settings$rv_edges$boxtextsize
  rv_edges$trprop <- edge_settings$rv_edges$trprop
  rv_edges$arrowsize <- edge_settings$rv_edges$arrowsize
  rv_edges$offset <- edge_settings$rv_edges$offset

  # Restore Node Position parameters with a progress delay
  # Otherwise the execution timing of `renderUI()` will
  # make it impossible to restore these values
  # shinyjs::delay(500, {
  #     updateMatrixInput(session, inputId = "nodeposMatrix", value = hgraph_inputs[["nodeposMatrix"]])
  # })
})
