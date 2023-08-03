tags$footer(
  class = "my-5",
  fluidRow(
    column(
      width = 10, offset = 1,
      hr(),
      # Use YYYY.0M.MICRO as defined by https://calver.org/
      p(paste("gMCPShiny", as.vector(read.dcf("DESCRIPTION", fields = "Version"))), class = "text-muted"),
      p(paste("gMCPLite", packageVersion("gMCPLite")), class = "text-muted")
    )
  )
)
