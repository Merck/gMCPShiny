# Adaptive color palette generator for hGraph

Adaptive color palette generator for hGraph using `pal_adaptive()` and
`pal_ramp()`.

## Usage

``` r
hgraph_palette(
  pal_name = c("gray", "Okabe-Ito", "d3.category10", "d3.category20", "d3.category20b",
    "d3.category20c", "Teal"),
  n,
  alpha = 1
)
```

## Arguments

- pal_name:

  Color palette name.

- n:

  How many different colors for the selected color palette?

- alpha:

  Transparency level, a real number in (0, 1\].

## Value

A vector of color hex values.

## Examples

``` r
hgraph_palette("gray", n = 10)
#>  [1] "#4D4D4DFF" "#6C6C6CFF" "#838383FF" "#969696FF" "#A7A7A7FF" "#B5B5B5FF"
#>  [7] "#C3C3C3FF" "#CFCFCFFF" "#DBDBDBFF" "#E6E6E6FF"
hgraph_palette("Okabe-Ito", n = 15)
#>  [1] "#E69F00FF" "#9EA974FF" "#56B4E9FF" "#2BA9AEFF" "#009E73FF" "#77C15AFF"
#>  [7] "#F0E442FF" "#77AB7AFF" "#0072B2FF" "#6A6859FF" "#D55E00FF" "#D06B53FF"
#> [13] "#CC79A7FF" "#B288A0FF" "#999999FF"
```
