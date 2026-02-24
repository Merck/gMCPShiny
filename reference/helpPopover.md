# Help popovers

Help popovers with question mark icon (Bootstrap 5).

## Usage

``` r
helpPopover(title, content)
```

## Arguments

- title:

  Title of the popover.

- content:

  Content of the popover.

## Value

Popover element.

## Examples

``` r
helpPopover(
  "digits",
  "Number of digits past the decimal."
)
#> <script>
#>     // Bootstrap popovers
#>     $(function () {
#>       var $pop = $("body");
#>       $pop.popover({
#>         trigger: "hover focus",
#>         selector: '[data-bs-toggle="popover"]',
#>       });
#>     });</script>
#> <a data-bs-toggle="popover" title="digits" data-bs-trigger="hover focus" data-bs-content="Number of digits past the decimal." data-bs-placement="right" class="help-popover">
#>   <i class="far fa-circle-question" role="presentation" aria-label="circle-question icon"></i>
#> </a>
```
