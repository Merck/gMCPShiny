# Run Shiny app

Run Shiny app

## Usage

``` r
run_app(port = getOption("shiny.port"))
```

## Arguments

- port:

  The TCP port that the application should listen on. If the `port` is
  not specified, and the `shiny.port` option is set (with
  `options(shiny.port = XX)`), then that port will be used. Otherwise,
  use a random port between 3000:8000, excluding ports that are blocked
  by Google Chrome for being considered unsafe: 3659, 4045, 5060, 5061,
  6000, 6566, 6665:6669 and 6697. Up to twenty random ports will be
  tried.

## Value

An object that represents the app. Printing the object or passing it to
[`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html) will run
the app.

## Examples

``` r
if (interactive()) {
  gMCPShiny::run_app()
}
```
