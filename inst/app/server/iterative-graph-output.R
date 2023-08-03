gethypothesesMatrix <- reactive({
  row.empty <- unique(which(input$hypothesesMatrix == '', arr.ind=TRUE)[,1])
  if (identical(row.empty, integer(0))) {input$hypothesesMatrix}else{
    input$hypothesesMatrix[- row.empty,]
  }
})

n_hypo <- reactive({
  nrow(gethypothesesMatrix())
})

fwerInput <- reactive({
  alphaHypotheses <- sapply(gethypothesesMatrix()[, "Alpha"], arithmetic_to_numeric)
  sum(alphaHypotheses)
})

output$pval_update_ui <- renderUI({
  lapply(seq_len(n_hypo()), function(i) {
    tagList(
      hr(),
      h5(paste0("Hypothesis ", gethypothesesMatrix()[, "Name"][i])),

      selectInput(
        inputId = paste0("design_type_", i),
        label = "Type of Design:", choices =  c("Fixed Design" = "fix",
                                                "Group Sequential Design" = "gs_upload"),
        selectize = FALSE
      ),

      conditionalPanel(
        condition = paste0("input.design_type_", i, " == 'gs_upload'"),
        selectInput(
          inputId = paste0("spending_interim_", i),
          label = tagList(
            "Interim analysis alpha spending strategy",
            helpPopover(
              "spending_interim",
              "Spend alpha at interim analyses based on?"
            )
          ),
          choices = c(
            "Actual information fraction" = "info",
            "Minimum of planned and actual information fraction" = "pmin"
          )
        ),
        matrixInput(paste0("pvalMatrix_", i),
                    label = tagList(
                      "observed events and p-values:",
                      helpPopover(
                        "p-values matrix",
                        "\"Analysis\" requires text input, shoud match hypotheses names.
            \"pvalueBoundary\" and \"pvalueObserved\" supports numeric input and arithmetic expressions, should range between 0 and 1."
                      )
                    ),
                    value = as.matrix(data.frame(cbind(
                      Analysis = c("1", "2", "3"),
                      ObsEvents = c(120, 240, 360),
                      ObsPval = rep(1, 3)
                    ))),
                    class = "character",
                    rows = list(names = FALSE, editableNames = FALSE, extend = FALSE),
                    cols = list(names = TRUE, editableNames = FALSE, extend = FALSE)
        ),
        matrixButtonGroup(paste0("pvalMatrix_", i)),
        fileButtonInput(inputId = paste0("btn_gsdesign_", i), label = NULL,
                        buttonLabel = "Upload Design",
                        multiple = FALSE, accept = ".rds", width = "100%")

      ),

      conditionalPanel(
        condition = paste0("input.design_type_", i, " == 'fix'"),
        numericInput(
          inputId = paste0("pval_", i),
          label = "Observed p-value:",
          min = 0, max = 1, step = .00001, value = 1
        )),
    )
  })
})
outputOptions(output, name = "pval_update_ui", suspendWhenHidden = FALSE)

output$reject_update_ui <- renderUI({
  lapply(seq_len(n_hypo()), function(i) {
    tagList(
      checkboxInput(
        inputId = paste0("reject_", i),
        label = paste0("Reject hypothesis ", gethypothesesMatrix()[, "Name"][i])
      )
    )
  })
})
outputOptions(output, name = "reject_update_ui", suspendWhenHidden = FALSE)

GetDesign <- reactive({
  sapply(seq_len(n_hypo()), function(i){
    if (input[[paste0("design_type_", i)]] %in% c("fix")){
      "fixed design"
    } else if(input[[paste0("design_type_", i)]] == "gs_upload"){
      ##Read in uploaded design
      rds <- input[[paste0("btn_gsdesign_",i)]]
      req(rds)
      readRDS(rds$datapath)$gs_object
    }
  })
})

GetPval <- reactive({
  sapply(seq_len(n_hypo()), function(i){
    if (input[[paste0("design_type_", i)]] %in% c("fix")){
      input[[paste0("pval_", i)]]
    } else if(input[[paste0("design_type_", i)]] == "gs_upload"){
      ##Read in uploaded design
      rds <- input[[paste0("btn_gsdesign_",i)]]
      req(rds)
      design <- readRDS(rds$datapath)
      ##get observed events from input
      obsEvents <- sapply(input[[paste0("pvalMatrix_", i)]][,"ObsEvents"], arithmetic_to_numeric, USE.NAMES = FALSE)
      ##spending time
      if (input[[paste0("spending_interim_", i)]] == "info"){
        spendingTime <- obsEvents/max(design$gs_object$n.I)
      } else if (input[[paste0("spending_interim_", i)]] == "pmin") {
        spendingTime <- apply(cbind(obsEvents,design$gs_object$n.I[1:length(obsEvents)]),1,min)/max(design$gs_object$n.I)
      }
      #spendingTime <- ifelse(spendingTime>1,1,spendingTime)

      gsDesign::sequentialPValue(
        gsD = design$gs_object, interval = c(.0001, .9999),
        n.I = obsEvents,
        Z = -qnorm(sapply(input[[paste0("pvalMatrix_", i)]][,"ObsPval"], arithmetic_to_numeric, USE.NAMES = FALSE)),
        usTime = spendingTime
      )
    }
  })
})

GetReject <- reactive({
  sapply(
    seq_len(n_hypo()), function(i) {
      1 - isTruthy(input[[paste0("reject_", i)]])
    }
  )
})

SeqPlotInput <- reactive({
  Trans <- data.frame(input$trwtMatrix)
  keepTransRows <- (Trans[, 1] %in% gethypothesesMatrix()[, 1]) & (Trans[, 2] %in% gethypothesesMatrix()[, 1])
  transitions <- Trans[keepTransRows, ]

  ## Ensure m and alphaHypotheses converted from different types to numeric
  m <- df2graph(namesH = gethypothesesMatrix()[, 1], df = transitions)
  alphaHypotheses <- sapply(gethypothesesMatrix()[, "Alpha"], arithmetic_to_numeric)

  SeqGraph <- gMCPLite::setWeights(object = gMCPLite::matrix2graph(m), weights = alphaHypotheses / fwerInput())
  pval <- if (input$knowpval == "yes") GetPval() else GetReject()
  gMCPLite::gMCP(graph = SeqGraph, pvalues = pval, alpha = fwerInput())
})


output$theSeqPlot <- renderUI({
  graph_tabs <- lapply(seq_len(length(SeqPlotInput()@graphs)),function(k){
    tabPanel(title = paste("Graph",k),
             plotOutput(paste("graph",k)))
  })
  do.call(tabsetPanel, graph_tabs)
})


observe(
  lapply(seq_len(length(SeqPlotInput()@graphs)),function(k){
    m <- SeqPlotInput()@graphs[[k]]@m
    rownames(m) <- NULL
    colnames(m) <- NULL
    output[[paste("graph",k)]]<-renderPlot({
      gMCPLite::hGraph(
        nHypotheses = n_hypo(),
        nameHypotheses = stringi::stri_unescape_unicode(gethypothesesMatrix()[, "Name"]),
        alphaHypotheses = SeqPlotInput()@graphs[[k]]@weights * sum(sapply(gethypothesesMatrix()[, "Alpha"], arithmetic_to_numeric)),
        m = m,
        fill = factor(stringi::stri_unescape_unicode(gethypothesesMatrix()[, "Group"]),
                      levels = unique(stringi::stri_unescape_unicode(gethypothesesMatrix()[, "Group"]))
        ),
        palette = hgraph_palette(pal_name = rv_nodes$pal_name, n = length(unique(gethypothesesMatrix()[, "Group"])), alpha = rv_nodes$pal_alpha),
        labels = unique(stringi::stri_unescape_unicode(gethypothesesMatrix()[, "Group"])),
        legend.name = input$legend.name,
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
        x = if (is.null(input$nodeposMatrix[, "x"]) | !setequal(input$nodeposMatrix[, "Hypothesis"], gethypothesesMatrix()[, "Name"])) {
          NULL
        } else {
          as.numeric(input$nodeposMatrix[, "x"])
        },
        y = if (is.null(input$nodeposMatrix[, "y"]) | !setequal(input$nodeposMatrix[, "Hypothesis"], gethypothesesMatrix()[, "Name"])) {
          NULL
        } else {
          as.numeric(input$nodeposMatrix[, "y"])
        },
        wchar = stringi::stri_unescape_unicode(rv_nodes$wchar)
      )
    })
  })
)

# Activate the last tab
observeEvent(SeqPlotInput(), {
  shinyjs::delay(100, {
    shinyjs::runjs(activate_last_tab_seqplot)
  })
}, ignoreNULL = FALSE, ignoreInit = FALSE, once = FALSE)

# Initial Design output ---------------------------------------------------------------
output$gsDesign <- renderUI({
  design_tabs <- lapply(1:n_hypo(),function(i){
    if (input$knowpval=="yes"&input[[paste0("design_type_", i)]] == "fix"){
      tabPanel(title = gethypothesesMatrix()[i,"Name"],
               h3(paste0(gethypothesesMatrix()[i,"Name"], " is fixed sample size design.")))
    }else if (input$knowpval=="yes"&input[[paste0("design_type_", i)]] != "fix"){
      tabPanel(title = gethypothesesMatrix()[i,"Name"],
               htmlOutput(paste0("tmp",i)))
    }})
  do.call(tabsetPanel,design_tabs)
  })

observe(lapply(1:n_hypo(),function(i){
  if (input$knowpval == "yes"){
    if (input[[paste0("design_type_", i)]] == "gs_upload"){
      rds <- input[[paste0("btn_gsdesign_",i)]]
      req(rds)
      design <- readRDS(rds$datapath)
      output[[paste0("tmp",i)]]<-renderTable({
        x <- gsDesign::gsBoundSummary(design$gs_object,
                                 digits   = rv_digits$digits,
                                 ddigits  = rv_digits$ddigits,
                                 tdigits  = rv_digits$tdigits)
        if ("Efficacy" %in% names(x)) x$Efficacy <- format(x$Efficacy, nsmall = rv_digits$digits)
        if ("Futility" %in% names(x)) x$Futility <- format(x$Futility, nsmall = rv_digits$digits)
        x
      },include.rownames=FALSE)
    }
  }
}
))



# Tabular output ---------------------------------------------------------------
output$TestResultsHTML <- renderUI(
  {
    ##sequntial pvalues to graphs comparison
    EOCtab <- data.frame(gethypothesesMatrix()[,c(1,3)])
    EOCtab$seqp <- GetPval()
    EOCtab$Rejected <- SeqPlotInput()@rejected
    EOCtab$adjPValues <- SeqPlotInput()@adjPValues
    FWER <- fwerInput()
    ngraphs <- length(SeqPlotInput()@graphs)
    rejected <- NULL
    for (i in 1:ngraphs){
      rejected <- rbind(
        rejected,
        data.frame(
          Name = 1:nrow(EOCtab), Stage = rep(i,nrow(EOCtab)),
          Rejected = as.logical(SeqPlotInput()@graphs[[i]]@nodeAttr$rejected)
        )
      )
    }

    lastWeights <- as.numeric(SeqPlotInput()@graphs[[ngraphs]]@weights)
    lastGraph <- rep(ngraphs, nrow(EOCtab))

    # We will update for rejected hypotheses with last positive weight for each
    if (ngraphs > 1) {
      rejected <- rejected %>%
        filter(Rejected) %>%
        group_by(Name) %>%
        summarize(graphRejecting = min(Stage) - 1, .groups = "drop") %>%
        arrange(graphRejecting)
      for (i in 1:(ngraphs - 1)) {
        lastWeights[rejected$Name[i]] <- as.numeric(SeqPlotInput()@graphs[[i]]@weights[rejected$Name[i]])
        lastGraph[rejected$Name[i]] <- i
      }
    }
    EOCtab$lastAlpha <- FWER * lastWeights
    EOCtab$lastGraph <- lastGraph
    EOCtabx <- EOCtab
    names(EOCtabx) <- c(
      "Name", "Group", "Sequential p",
      "Rejected", "Adjusted p", "Max alpha allocated", "Last Graph")
    EOCtabx[,3] <- format(round(EOCtabx[,3],rv_digits$digits), nsmall = rv_digits$digits)
    EOCtabx[,6] <- format(round(EOCtabx[,6],rv_digits$digits), nsmall = rv_digits$digits)
    EOCtabx[,5] <- format(round(EOCtabx[,5],rv_digits$digits), nsmall = rv_digits$digits)
    EOCtabOutput <- if (input$knowpval=="yes"){
      EOCtabx %>% select(c(1:3, 6, 4:5, 7))}else{
      EOCtabx %>% select(c(1:2, 6, 4:5, 7))}
    output$tmp_seqp <- renderTable({
      EOCtabOutput})
    seqp <- htmlOutput('tmp_seqp')

    #Bounds at allocated alpha
    bounds<-list()
    for (i in 1:n_hypo()) {
      ##Get input results
      if (input[[paste0("design_type_", i)]] %in% c("fix")){
        # If not group sequential for this hypothesis, print the max alpha allocated
        # and the nominal p-value
        bounds[[i]]<-if(input$knowpval=="yes"){
          tabPanel(title = gethypothesesMatrix()[i,"Name"],
                   h3(paste0(gethypothesesMatrix()[i,"Name"],": Maximum alpha allocated: ",EOCtab$lastAlpha[i],", Nominal p-value for hypothesis test: ",input[[paste0("pval_", i)]])))}else{
                     tabPanel(title = gethypothesesMatrix()[i,"Name"],
                              h3(paste0(gethypothesesMatrix()[i,"Name"],": Maximum alpha allocated: ",EOCtab$lastAlpha[i],".")))
                              }
      } else {
        ##Read in uploaded design
        rds <- input[[paste0("btn_gsdesign_",i)]]
        req(rds)
        design <- readRDS(rds$datapath)
        ##get observed events from input
        obsEvents <- sapply(input[[paste0("pvalMatrix_", i)]][,"ObsEvents"], arithmetic_to_numeric, USE.NAMES = FALSE)
        ##spending time
        if (input[[paste0("spending_interim_", i)]] == "info"){
          spendingTime <- obsEvents/max(design$gs_object$n.I)
        } else if (input[[paste0("spending_interim_", i)]] == "pmin"){
          spendingTime <- apply(cbind(obsEvents,design$gs_object$n.I[1:length(obsEvents)]),1,min)/max(design$gs_object$n.I)
        }
        #spendingTime <- ifelse(spendingTime>1,1,spendingTime)

        ##get observed events and pvals from input
        nominalP <- sapply(input[[paste0("pvalMatrix_", i)]][,"ObsPval"], arithmetic_to_numeric, USE.NAMES = FALSE)
        events <- obsEvents
        Analysis <- sapply(input[[paste0("pvalMatrix_", i)]][,"Analysis"], arithmetic_to_numeric, USE.NAMES = FALSE)
        spendingTime <- spendingTime

        d <- design$gs_object

        # Get other info for current hypothesis
        length(events)<-d$k
        length(spendingTime)<-d$k
        ###To work on special situation: if observed event is larger than the future planned events
        n.I <- ifelse(is.na(events),d$n.I,events)
        usTime <- ifelse(is.na(spendingTime),d$timing,spendingTime)
        n.Iplan <- max(d$n.I)
        # If no alpha allocated, just print text line to note this along with the 0 alpha allocated
        if (EOCtab$lastAlpha[i] == 0) {
          bounds[[i]]<-paste0("Maximum alpha allocated: 0. No testing required.")
        }
        if (EOCtab$lastAlpha[i] > 0) {
          dupdate <- gsDesign::gsDesign(
            alpha = EOCtab$lastAlpha[i],
            k = d$k,
            n.I = n.I,
            usTime = usTime,
            maxn.IPlan = n.Iplan,
            n.fix = d$n.fix,
            test.type = d$test.type,
            sfu = d$upper$sf,
            sfupar = d$upper$param
          )
          output[[paste0("tmp_update",i)]]<-renderTable({
            x <- gsDesign::gsBoundSummary(dupdate,
                                     exclude = c(
                                       "B-value", "CP", "CP H1", "Spending",
                                       "~delta at bound", "P(Cross) if delta=0",
                                       "PP", "P(Cross) if delta=1"),
                                     digits   = rv_digits$digits,
                                     ddigits  = rv_digits$ddigits,
                                     tdigits  = rv_digits$tdigits
            )
            if ("Efficacy" %in% names(x)) x$Efficacy <- format(x$Efficacy, nsmall = rv_digits$digits)
            if ("Futility" %in% names(x)) x$Futility <- format(x$Futility, nsmall = rv_digits$digits)
            x
          },include.rownames=FALSE)
          bounds[[i]] <- tabPanel(title = gethypothesesMatrix()[i,"Name"],
                                  htmlOutput(paste0("tmp_update",i)))
        }
      }
    }

    switch(input$TestResults,
           "Comparison of sequential p-values to graphs" = seqp,
           "Bounds at final allocated alpha" =do.call(tabsetPanel,bounds)
    )
  }
)

# Report output ---------------------------------------------------------------
GetReportText <- reactive({
  report <- tempfile(fileext = ".Rmd")
  brew::brew("templates/report.Rmd", output = report)
  paste0(readLines(report), collapse = "\n")
})

output$ReportText <- renderRmd({
  htmltools::htmlEscape(GetReportText())
})

observeEvent(input$btn_gmcp_rmd_modal, {
  showModal(modalDialog(
    title = "Download Report (R Markdown)",
    textInputAddonRight("filename_rmd_gmcp", label = "Name the report:", value = "gMCP", addon = ".Rmd", width = "100%"),
    easyClose = TRUE,
    footer = tagList(
      downloadButton("downloadRmd", "Download Report (R Markdown)", class = "btn btn-primary"),
      modalButton("Cancel")
    )
  ))
})



output$downloadRmd <- downloadHandler(
  filename = function() {
    x <- input$filename_rmd_gmcp
    # sanitize from input
    fn0 <- if (x == "") "gMCP" else sanitize_filename(x)
    # sanitize again
    fn <- if (fn0 == "") "gMCP" else fn0
    paste0(fn, ".Rmd")
  },
  content = function(file) {
    writeLines(GetReportText(), con = file)
  }
)

observeEvent(input$btn_gmcp_html_modal, {
  showModal(modalDialog(
    title = "Download Report (HTML)",
    textInputAddonRight("filename_html_gmcp", label = "Name the report:", value = "gMCP", addon = ".html", width = "100%"),
    easyClose = TRUE,
    footer = tagList(
      downloadButton("downloadHTML", "Download Report (HTML)", class = "btn btn-primary"),
      modalButton("Cancel")
    )
  ))
})



output$downloadHTML <- downloadHandler(
  filename = function() {
    x <- input$filename_html_gmcp
    # sanitize from input
    fn0 <- if (x == "") "gMCP" else sanitize_filename(x)
    # sanitize again
    fn <- if (fn0 == "") "gMCP" else fn0
    paste0(fn, ".html")
  },
  content = function(file) {
    rmd <- tempfile(fileext = ".Rmd")
    writeLines(GetReportText(), con = rmd)

    owd <- setwd(dirname(rmd))
    on.exit(setwd(owd))

    html <- tempfile(fileext = ".html")
    out <- rmarkdown::render(rmd, output_file = html, quiet = TRUE)
    file.rename(out, file)
  }
)
