# Text input addon

Text input with addon on the right side.

## Usage

``` r
textInputAddonRight(
  inputId,
  label,
  value = "",
  width = NULL,
  placeholder = NULL,
  addon = NULL
)
```

## Arguments

- inputId:

  The `input` slot that will be used to access the value.

- label:

  Display label for the control, or `NULL` for no label.

- value:

  Initial value.

- width:

  The width of the input, e.g. `'400px'`, or `'100%'`; see
  [`validateCssUnit()`](https://rstudio.github.io/htmltools/reference/validateCssUnit.html).

- placeholder:

  A character string giving the user a hint as to what can be entered
  into the control. Internet Explorer 8 and 9 do not support this
  option.

- addon:

  Addon text.

## Value

Text input with addon on the right side.

## References

<https://getbootstrap.com/docs/5.3/forms/input-group/>

## Examples

``` r
textInputAddonRight(
  "filename",
  label = "Name of the report:",
  value = "gMCPShiny",
  addon = ".Rmd",
  width = "100%"
)
#> <div class="form-group shiny-input-container" style="width:100%;">
#>   <label class="control-label" id="filename-label" for="filename">Name of the report:</label>
#>   <div class="input-group">
#>     <input id="filename" type="text" class="form-control" value="gMCPShiny"/>
#>     <span class="input-group-text">.Rmd</span>
#>   </div>
#> </div>
```
