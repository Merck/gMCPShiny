# gMCPShiny <img src="man/figures/logo.png" align="right" width="120" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/Merck/gMCPShiny/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Merck/gMCPShiny/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/Merck/gMCPShiny/branch/main/graph/badge.svg)](https://app.codecov.io/gh/Merck/gMCPShiny?branch=main)
[![shinyapps.io](https://img.shields.io/badge/Shiny-shinyapps.io-blue)](https://rinpharma.shinyapps.io/gmcp/)
<!-- badges: end -->

A Shiny app for graphical multiplicity control.

## Installation

```r
# The easiest way to get gMCPShiny is to install:
install.packages("gMCPShiny")

# Alternatively, install development version from GitHub:
# install.packages("remotes")
remotes::install_github("Merck/gMCPShiny")
```

## Example

To run the app locally:

```r
gMCPShiny::run_app()
```

## Deployed instances

### Production version

- <https://rinpharma.shinyapps.io/gmcp/> (faster and more scalable access)
- <https://gmcp.shinyapps.io/prod/>

### Development version

- <https://gmcp.shinyapps.io/devel/>
