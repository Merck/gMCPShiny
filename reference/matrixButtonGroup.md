# Matrix buttons

Buttons to add/delete rows and reset a matrix input.

## Usage

``` r
matrixButtonGroup(inputId)

addMatrixRow(x)

delMatrixRow(x)
```

## Arguments

- inputId:

  ID of the matrix input.

- x:

  Name of the matrix input to add a row to or delete a row from.

## Value

A matrix button group.

## Examples

``` r
matrixButtonGroup("matrix")
#> <div class="row">
#>   <div class="col-sm-4">
#>     <button class="btn btn-default action-button btn btn-block btn-outline-primary" id="btn_matrix_addrow" style="width:100%;" type="button"><span class="action-icon"><i class="fas fa-plus" role="presentation" aria-label="plus icon"></i></span><span class="action-label"></span></button>
#>   </div>
#>   <div class="col-sm-4">
#>     <button class="btn btn-default action-button btn btn-block btn-outline-primary" id="btn_matrix_delrow" style="width:100%;" type="button"><span class="action-icon"><i class="fas fa-minus" role="presentation" aria-label="minus icon"></i></span><span class="action-label"></span></button>
#>   </div>
#>   <div class="col-sm-4">
#>     <button class="btn btn-default action-button btn btn-block btn-outline-primary" id="btn_matrix_reset" style="width:100%;" type="button"><span class="action-icon"><i class="fas fa-arrow-rotate-left" role="presentation" aria-label="arrow-rotate-left icon"></i></span><span class="action-label"></span></button>
#>   </div>
#> </div>
```
