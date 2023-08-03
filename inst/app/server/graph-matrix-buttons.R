# hypotheses
observeEvent(input$btn_hypothesesMatrix_addrow, {
  updateMatrixInput(session, inputId = "hypothesesMatrix", value = addMatrixRow(input$hypothesesMatrix))
})

observeEvent(input$btn_hypothesesMatrix_delrow, {
  updateMatrixInput(session, inputId = "hypothesesMatrix", value = delMatrixRow(input$hypothesesMatrix))
})

observeEvent(input$btn_hypothesesMatrix_reset, {
  updateMatrixInput(
    session,
    inputId = "hypothesesMatrix", value = as.matrix(data.frame(cbind(
      Name = paste0("H", 1:4),
      Alpha = rep(0.025 / 4, 4),
      Group = LETTERS[1:4]
    )))
  )
})

# Edge: Transition Matrix (original m*m Matrix or From-To weight)

# observeEvent(input$btn_trwtMatrix_addrow, {
#   updateMatrixInput(session, inputId = "trwtMatrix", value = addMatrixRow(input$trwtMatrix))
# })
#
# observeEvent(input$btn_trwtMatrix_delrow, {
#   updateMatrixInput(session, inputId = "trwtMatrix", value = delMatrixRow(input$trwtMatrix))
# })

observeEvent(input$btn_trwtMatrix_reset_init, {
  showModal(modalDialog(
    title = p(icon("triangle-exclamation"), "Attention"),
    p(
      paste(
        "This will sync the hypotheses names in this table (\"From\" and \"To\" columns),",
        "but will also reset the weights as a pure step-down transition,",
        "i.e., you will lose the current customized transition weights."
      )
    ),
    strong("We strongly recommend to finalize the hypotheses names update and save current hgraph, before click the confirm button."),
    p("Do you still want to proceed?"),
    easyClose = TRUE,
    footer = tagList(
      actionButton("btn_trwtMatrix_reset", label = "Confirm Sync and Reset", class = "btn-primary", icon = icon("circle-check")),
      modalButton("Cancel")
    )
  ))
})

observeEvent(input$btn_trwtMatrix_reset, {

  ## Step 1: construct a completed From and To matrix, including self-transit rows, pay attention to columns' order trick
  fromto_mat <- expand.grid(To = input$hypothesesMatrix[, "Name"], From = input$hypothesesMatrix[, "Name"])
  ## Step 2: set default weight as a pure step-down way (set weight To adjacent next hypothesis as 1, until the last hypothesis)
  fromto_mat$Weight = as.vector(t(cbind(rep(0, nrow(input$hypothesesMatrix)), diag(1, nrow(input$hypothesesMatrix), nrow(input$hypothesesMatrix)-1))))
  ## Step 3: remove the self-transit rows (this is for typical graphical approach, maybe self-transit rows can be kept for more advanced graphical approach, i.e. entangle graph?)
  trwt_mat <- fromto_mat[fromto_mat$From!=fromto_mat$To, c("From", "To", "Weight")]

  updateMatrixInput(
    session,
    inputId = "trwtMatrix",
    value = as.matrix(trwt_mat)
  )
  removeModal()
})

# Node position

# observeEvent(input$btn_hypothesesMatrix_addrow, {
#   updateMatrixInput(session, inputId = "nodeposMatrix", value = addMatrixRow(input$nodeposMatrix))
# })
#
# observeEvent(input$btn_hypothesesMatrix_delrow, {
#   updateMatrixInput(session, inputId = "nodeposMatrix", value = delMatrixRow(input$nodeposMatrix))
# })

observeEvent(input$btn_nodeposMatrix_reset_init, {
  showModal(modalDialog(
    title = p(icon("triangle-exclamation"), "Attention"),
    p(
      paste(
        "This will sync the hypotheses names in this table,",
        "but will also reset the graph layout to the default circular layout,",
        "i.e., you will lose the current customized node position."
      )
    ),
    strong("We strongly recommend to finalize the hypotheses names update and save current hgraph, before click the confirm button."),
    p("Do you still want to proceed?"),
    easyClose = TRUE,
    footer = tagList(
      actionButton("btn_nodeposMatrix_reset", label = "Confirm Sync and Reset", class = "btn-primary", icon = icon("circle-check")),
      modalButton("Cancel")
    )
  ))
})

observeEvent(input$btn_nodeposMatrix_reset, {
  radianStart <- if ((nrow(input$hypothesesMatrix)) %% 2 != 0) {
    pi * (1 / 2 + 1 / nrow(input$hypothesesMatrix))
  } else {
    pi * (1 + 2 / nrow(input$hypothesesMatrix)) / 2
  }

  updateMatrixInput(
    session,
    inputId = "nodeposMatrix",
    value = as.matrix(data.frame(cbind(
      Hypothesis = input$hypothesesMatrix[, "Name"],
      x = round(2 * cos((radianStart - (0:(nrow(input$hypothesesMatrix) - 1)) / nrow(input$hypothesesMatrix) * 2 * pi) %% (2 * pi)), 6),
      y = round(2 * sin((radianStart - (0:(nrow(input$hypothesesMatrix) - 1)) / nrow(input$hypothesesMatrix) * 2 * pi) %% (2 * pi)), 6)
    )))
  )
  removeModal()
})

# p-value Matrix for gsDesign
observe({
lapply(seq_len(nrow(input$hypothesesMatrix)), function(i){
observeEvent(input[[paste0("btn_pvalMatrix_", i, "_addrow")]], {
  updateMatrixInput(session, inputId = paste0("pvalMatrix_", i), value = addMatrixRow(input[[paste0("pvalMatrix_", i)]]))
})

observeEvent(input[[paste0("btn_pvalMatrix_", i, "_delrow")]], {
  updateMatrixInput(session, inputId = paste0("pvalMatrix_", i), value = delMatrixRow(input[[paste0("pvalMatrix_", i)]]))
})

observeEvent(input[[paste0("btn_pvalMatrix_", i, "_reset")]], {
  updateMatrixInput(
    session,
    inputId = paste0("pvalMatrix_", i),
    value = as.matrix(data.frame(cbind(
      Analysis = c("1", "2", "3"),
      ObsEvents = c(120, 240, 360),
      ObsPval = rep(1, 3)
    )))
  )
})
})
})
