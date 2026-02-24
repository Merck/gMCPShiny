# Convert transitions data frame into an hgraph matrix

Convert transitions data frame into an hgraph matrix, given all the
hypothesis names, with transition weights evaluated.

## Usage

``` r
df2graph(namesH, df)
```

## Arguments

- namesH:

  Hypothesis names.

- df:

  Input data frame of transitions.

## Value

An hgraph matrix.

## Examples

``` r
df2graph(
  namesH = paste0("H", 1:6),
  df = data.frame(
    From = paste0("H", 1:4),
    To = paste0("H", c(2:4, 1)),
    Weight = rep(1, 4)
  )
)
#>      [,1] [,2] [,3] [,4] [,5] [,6]
#> [1,]    0    1    0    0    0    0
#> [2,]    0    0    1    0    0    0
#> [3,]    0    0    0    1    0    0
#> [4,]    1    0    0    0    0    0
#> [5,]    0    0    0    0    0    0
#> [6,]    0    0    0    0    0    0
```
