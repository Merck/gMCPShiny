# Create a page with a top level navigation bar within a fluid container

Slightly modified from
[`shiny::navbarPage()`](https://rdrr.io/pkg/shiny/man/navbarPage.html)
to support:

- Navbar inside a fluid container instead of full width.

- Brand image before title.

## Usage

``` r
navbarFluidPage(
  title,
  ...,
  id = NULL,
  selected = NULL,
  position = c("static-top", "fixed-top", "fixed-bottom"),
  header = NULL,
  footer = NULL,
  inverse = FALSE,
  collapsible = FALSE,
  fluid = TRUE,
  theme = NULL,
  windowTitle = NA,
  lang = NULL,
  brand_image,
  brand_image_width,
  brand_image_height
)
```

## Arguments

- title:

  The title to display in the navbar

- ...:

  [`tabPanel()`](https://rdrr.io/pkg/shiny/man/tabPanel.html) elements
  to include in the page. The `navbarMenu` function also accepts
  strings, which will be used as menu section headers. If the string is
  a set of dashes like `"----"` a horizontal separator will be displayed
  in the menu.

- id:

  If provided, you can use `input$`*`id`* in your server logic to
  determine which of the current tabs is active. The value will
  correspond to the `value` argument that is passed to
  [`tabPanel()`](https://rdrr.io/pkg/shiny/man/tabPanel.html).

- selected:

  The `value` (or, if none was supplied, the `title`) of the tab that
  should be selected by default. If `NULL`, the first tab will be
  selected.

- position:

  Determines whether the navbar should be displayed at the top of the
  page with normal scrolling behavior (`"static-top"`), pinned at the
  top (`"fixed-top"`), or pinned at the bottom (`"fixed-bottom"`). Note
  that using `"fixed-top"` or `"fixed-bottom"` will cause the navbar to
  overlay your body content, unless you add padding, e.g.:
  `tags$style(type="text/css", "body {padding-top: 70px;}")`

- header:

  Tag or list of tags to display as a common header above all tabPanels.

- footer:

  Tag or list of tags to display as a common footer below all tabPanels

- inverse:

  `TRUE` to use a dark background and light text for the navigation bar

- collapsible:

  `TRUE` to automatically collapse the navigation elements into an
  expandable menu on mobile devices or narrow window widths.

- fluid:

  `TRUE` to use a fluid layout. `FALSE` to use a fixed layout.

- theme:

  One of the following:

  - `NULL` (the default), which implies a "stock" build of Bootstrap 3.

  - A
    [`bslib::bs_theme()`](https://rstudio.github.io/bslib/reference/bs_theme.html)
    object. This can be used to replace a stock build of Bootstrap 3
    with a customized version of Bootstrap 3 or higher.

  - A character string pointing to an alternative Bootstrap stylesheet
    (normally a css file within the www directory, e.g.
    `www/bootstrap.css`).

- windowTitle:

  the browser window title (as a character string). The default value,
  `NA`, means to use any character strings that appear in `title` (if
  none are found, the host URL of the page is displayed by default).

- lang:

  ISO 639-1 language code for the HTML page, such as "en" or "ko". This
  will be used as the lang in the `<html>` tag, as in
  `<html lang="en">`. The default (NULL) results in an empty string.

- brand_image:

  Path to the brand image.

- brand_image_width:

  Width of the brand image in pixels.

- brand_image_height:

  Height of the brand image in pixels.

## Value

A page with a top level navigation bar within a fluid container.

## Examples

``` r
library(shiny)

navbarFluidPage(
  "App Title",
  tabPanel("Plot"),
  tabPanel("Summary"),
  tabPanel("Table")
)
#> <div class="container-fluid nav-custom-padding">
#>   <div class="col-sm-10 offset-md-1 col-sm-offset-1">
#>     <nav class="navbar navbar-default navbar-static-top" role="navigation">
#>       <div class="container-fluid">
#>         <div class="navbar-header">
#>           <span class="navbar-brand">App Title</span>
#>         </div>
#>         <ul class="nav navbar-nav" data-tabsetid="2161">
#>           <li class="active">
#>             <a href="#tab-2161-1" data-toggle="tab" data-bs-toggle="tab" data-value="Plot">Plot</a>
#>           </li>
#>           <li>
#>             <a href="#tab-2161-2" data-toggle="tab" data-bs-toggle="tab" data-value="Summary">Summary</a>
#>           </li>
#>           <li>
#>             <a href="#tab-2161-3" data-toggle="tab" data-bs-toggle="tab" data-value="Table">Table</a>
#>           </li>
#>         </ul>
#>       </div>
#>     </nav>
#>   </div>
#> </div>
#> <div class="container-fluid">
#>   <div class="tab-content" data-tabsetid="2161">
#>     <div class="tab-pane active" data-value="Plot" id="tab-2161-1"></div>
#>     <div class="tab-pane" data-value="Summary" id="tab-2161-2"></div>
#>     <div class="tab-pane" data-value="Table" id="tab-2161-3"></div>
#>   </div>
#> </div>
```
