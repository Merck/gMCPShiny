# Sanitizes file name

Sanitizes file name (without the extension part). Ported and modified
from
[`fs::path_sanitize()`](https://fs.r-lib.org/reference/path_sanitize.html).

## Usage

``` r
sanitize_filename(filename, replacement = "-")
```

## Arguments

- filename:

  Input file name.

- replacement:

  Replacement for illegal characters.

## Value

Sanitized file name.

## Examples

``` r
x <- " znul/zzz.z>z/\\z "
paste0(sanitize_filename(x), ".rds")
#> [1] "znul-zzz.z-z--z.rds"
```
