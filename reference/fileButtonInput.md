# File input button

File input but with only the button.

## Usage

``` r
fileButtonInput(
  inputId,
  label,
  multiple = FALSE,
  accept = NULL,
  width = NULL,
  buttonLabel = "Browse...",
  placeholder = "No file selected"
)
```

## Arguments

- inputId:

  The `input` slot that will be used to access the value.

- label:

  Display label for the control, or `NULL` for no label.

- multiple:

  Whether the user should be allowed to select and upload multiple files
  at once. **Does not work on older browsers, including Internet
  Explorer 9 and earlier.**

- accept:

  A character vector of "unique file type specifiers" which gives the
  browser a hint as to the type of file the server expects. Many
  browsers use this prevent the user from selecting an invalid file.

  A unique file type specifier can be:

  - A case insensitive extension like `.csv` or `.rds`.

  - A valid MIME type, like `text/plain` or `application/pdf`

  - One of `audio/*`, `video/*`, or `image/*` meaning any audio, video,
    or image type, respectively.

- width:

  The width of the input, e.g. `'400px'`, or `'100%'`; see
  [`validateCssUnit()`](https://rstudio.github.io/htmltools/reference/validateCssUnit.html).

- buttonLabel:

  The label used on the button. Can be text or an HTML tag object.

- placeholder:

  The text to show before a file has been uploaded.

## Value

Button for file input.

## Examples

``` r
fileButtonInput(
  "restore",
  label = NULL,
  buttonLabel = "Restore",
  multiple = FALSE,
  accept = ".rds",
  width = "50%"
)
#> <div style="display: inline-block; width: 10rem; margin-bottom: -2rem; margin-right: -3px;">
#>   <div class="form-group shiny-input-container" style="width: 50%;">
#>     <label class="control-label shiny-label-null" for="restore" id="restore-label"></label>
#>     <div class="input-group" style="width: 10rem;">
#>       <label class="input-group-prepend">
#>         <span class="btn btn-outline-primary">
#>           <i class="fa fa-upload"></i>
#>           Restore
#>           <input id="restore" name="restore" type="file" style="display: none;" accept=".rds"/>
#>         </span>
#>       </label>
#>     </div>
#>   </div>
#> </div>
```
