# Help link

Help link with an icon and opens in a new window or tab.

## Usage

``` r
helpLink(href)
```

## Arguments

- href:

  URL to open.

## Value

Link element.

## Examples

``` r
helpLink("https://en.wikipedia.org/wiki/List_of_Unicode_characters")
#> <a href="https://en.wikipedia.org/wiki/List_of_Unicode_characters" target="_blank" class="help-popover">
#>   <i class="fas fa-arrow-up-right-from-square" role="presentation" aria-label="arrow-up-right-from-square icon"></i>
#> </a>
```
