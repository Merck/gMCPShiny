# Convert arithmetic (character) format to numeric

Convert arithmetic (character) format to numeric

## Usage

``` r
arithmetic_to_numeric(x)
```

## Arguments

- x:

  Character string containing arithmetic operators.

## Value

The numeric value from evaluating the arithmetic expression.

## Examples

``` r
# Return numeric values
arithmetic_to_numeric("1/3")
#> [1] 0.3333333
arithmetic_to_numeric("sqrt(2)")
#> [1] 1.414214
arithmetic_to_numeric("log(2)")
#> [1] 0.6931472
arithmetic_to_numeric("exp((-3^2)/2)/sqrt(2*pi)")
#> [1] 0.004431848

# Return NA if containing non-arithmetic string
arithmetic_to_numeric("1/3a")
#> [1] NA
```
