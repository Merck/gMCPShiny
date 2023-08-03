#  Copyright (c) 2023 Merck & Co., Inc., Rahway, NJ, USA and its affiliates.
#  All rights reserved.
#
#  This file is part of the gMCPShiny program.
#
#  gMCPShiny is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' Render R Markdown with syntax highlighting
#'
#' Renders R Markdown with syntax highlighting using the highlight.js library.
#'
#' @inheritParams shiny::renderText
#' @param outputArgs List of additional arguments to pass to the
#'   output function.
#' @param delay Delay in milliseconds before syntax highlighting starts.
#'
#' @return A render function similar to [shiny::renderText()].
#'
#' @importFrom shiny exprToFunction markRenderFunction
#'
#' @export
#'
#' @examples
#' if (interactive()) {
#'   library("shiny")
#'
#'   ui <- fluidPage(
#'     fluidRow(
#'       column(
#'         4,
#'         textAreaInput(
#'           "rmd_in",
#'           label = NULL,
#'           width = "100%", height = "500px",
#'           value = "---\ntitle: Title\noutput: pdf_document\n---\n\n# Heading"
#'         )
#'       ),
#'       column(
#'         8,
#'         rmdOutput("rmd_out")
#'       )
#'     )
#'   )
#'
#'   server <- function(input, output) {
#'     output$rmd_out <- renderRmd({
#'       htmltools::htmlEscape(input$rmd_in)
#'     })
#'   }
#'
#'   shinyApp(ui = ui, server = server)
#' }
renderRmd <- function(
    expr,
    env = parent.frame(),
    quoted = FALSE,
    outputArgs = list(),
    delay = 100) {
  func <- exprToFunction(expr, env, quoted)
  renderFunc <- function(shinysession, name, ...) {
    value <- func()
    for (d in delay) {
      shinysession$sendCustomMessage("highlight-rmd", list(id = name, delay = d))
    }
    return(paste(utils::capture.output(cat(value)), collapse = "\n"))
  }
  markRenderFunction(rmdOutput, renderFunc, outputArgs = outputArgs)
}

#' @rdname renderRmd
#'
#' @param outputId Output variable to read the R Markdown from.
#'
#' @importFrom htmltools tagList
#' @importFrom shiny uiOutput
#'
#' @export
rmdOutput <- function(outputId) {
  tagList(
    rmdHighlightDeps(),
    uiOutput(outputId, container = rmdContainer)
  )
}

#' @importFrom htmltools tagList singleton includeCSS includeScript
rmdHighlightDeps <- function() {
  src <- system.file("www/shared/shiny-highlight-rmarkdown", package = "gMCPShiny")
  tagList(
    singleton(list(
      includeCSS(file.path(src, "highlight-theme.css")),
      includeScript(file.path(src, "highlight.min.js")),
      includeScript(file.path(src, "r.js"))
    )),
    singleton(list(
      includeScript(file.path(src, "markdown.js")),
      includeScript(file.path(src, "yaml.min.js")),
      includeScript(file.path(src, "latex.min.js"))
    )),
    singleton(list(
      tags$script(
        "Shiny.addCustomMessageHandler(
           'highlight-rmd',
           function (message) {
               var id = message['id'];
               var delay = message['delay'];
               setTimeout(
                   function () {
                       var el = document.getElementById(id);
                       hljs.highlightElement(el);
                   },
                   delay
               );
           }
       );"
      )
    ))
  )
}

#' @importFrom htmltools tags div HTML
rmdContainer <- function(...) {
  rmd <- HTML(as.character(tags$code(class = "language-md", ...)))
  div(tags$pre(rmd, style = "background-color: #FFFFFF;"))
}
