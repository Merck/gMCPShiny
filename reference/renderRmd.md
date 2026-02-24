# Render R Markdown with syntax highlighting

Renders R Markdown with syntax highlighting using the highlight.js
library.

## Usage

``` r
renderRmd(
  expr,
  env = parent.frame(),
  quoted = FALSE,
  outputArgs = list(),
  delay = 100
)

rmdOutput(outputId)
```

## Arguments

- expr:

  An expression to evaluate.

- env:

  The parent environment for the reactive expression. By default, this
  is the calling environment, the same as when defining an ordinary
  non-reactive expression. If `expr` is a quosure and `quoted` is
  `TRUE`, then `env` is ignored.

- quoted:

  If it is `TRUE`, then the
  [`quote()`](https://rdrr.io/r/base/substitute.html)ed value of `expr`
  will be used when `expr` is evaluated. If `expr` is a quosure and you
  would like to use its expression as a value for `expr`, then you must
  set `quoted` to `TRUE`.

- outputArgs:

  List of additional arguments to pass to the output function.

- delay:

  Delay in milliseconds before syntax highlighting starts.

- outputId:

  Output variable to read the R Markdown from.

## Value

A render function similar to
[`shiny::renderText()`](https://rdrr.io/pkg/shiny/man/renderPrint.html).

## Examples

``` r
if (interactive()) {
  library("shiny")

  ui <- fluidPage(
    fluidRow(
      column(
        4,
        textAreaInput(
          "rmd_in",
          label = NULL,
          width = "100%", height = "500px",
          value = "---\ntitle: Title\noutput: pdf_document\n---\n\n# Heading"
        )
      ),
      column(
        8,
        rmdOutput("rmd_out")
      )
    )
  )

  server <- function(input, output) {
    output$rmd_out <- renderRmd({
      htmltools::htmlEscape(input$rmd_in)
    })
  }

  shinyApp(ui = ui, server = server)
}
```
