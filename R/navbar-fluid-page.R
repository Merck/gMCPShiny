#  Copyright (c) 2023 Merck & Co., Inc., Rahway, NJ, USA and its affiliates.
#  All rights reserved.
#
#  This file is part of the gMCPShiny program.
#
#  gMCPShiny is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#' Create a page with a top level navigation bar within a fluid container
#'
#' Slightly modified from [shiny::navbarPage()] to support:
#' - Navbar inside a fluid container instead of full width.
#' - Brand image before title.
#'
#' @inheritParams shiny::navbarPage
#' @param brand_image Path to the brand image.
#' @param brand_image_width Width of the brand image in pixels.
#' @param brand_image_height Height of the brand image in pixels.
#'
#' @return A page with a top level navigation bar within a fluid container.
#'
#' @export
#'
#' @examples
#' library(shiny)
#'
#' navbarFluidPage(
#'   "App Title",
#'   tabPanel("Plot"),
#'   tabPanel("Summary"),
#'   tabPanel("Table")
#' )

# shiny and bslib versions:
# https://github.com/rstudio/shiny/tree/9389160af06b2f26d3746fa06c6ac0df8e76c8dd
# https://github.com/rstudio/bslib/tree/888fbe064491692deb56fd90dc23455052e31073

navbarFluidPage <- function(
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
    brand_image_height) {
  remove_first_class <- function(x) {
    class(x) <- class(x)[-1]
    x
  }

  remove_first_class(page_navbar(
    ...,
    title = title, id = id, selected = selected,
    position = match.arg(position),
    header = header, footer = footer,
    inverse = inverse, collapsible = collapsible,
    fluid = fluid,
    theme = theme,
    window_title = windowTitle,
    lang = lang,
    brand_image = brand_image,
    brand_image_width = brand_image_width,
    brand_image_height = brand_image_height
  ))
}

find_characters <- function(x) {
  if (is.character(x)) {
    return(x)
  }
  if (inherits(x, "shiny.tag")) {
    return(lapply(x$children, find_characters))
  }
  if (is.list(x)) {
    return(lapply(x, find_characters))
  }
  NULL
}

#' @importFrom bslib bs_theme
page_navbar <- function(
    ..., title = NULL, id = NULL, selected = NULL,
    position = c("static-top", "fixed-top", "fixed-bottom"),
    header = NULL, footer = NULL,
    bg = NULL, inverse = "auto",
    collapsible = TRUE, fluid = TRUE,
    theme = bs_theme(),
    window_title = NA,
    lang = NULL,
    brand_image,
    brand_image_width,
    brand_image_height) {
  # https://github.com/rstudio/shiny/issues/2310
  if (!is.null(title) && isTRUE(is.na(window_title))) {
    window_title <- unlist(find_characters(title))
    if (is.null(window_title)) {
      warning("Unable to infer a `window_title` default from `title`. Consider providing a character string to `window_title`.")
    } else {
      window_title <- paste(window_title, collapse = " ")
    }
  }

  page(
    title = window_title,
    theme = theme,
    lang = lang,
    navs_bar(
      ...,
      title = title, id = id, selected = selected,
      position = match.arg(position), header = header,
      footer = footer, bg = bg, inverse = inverse,
      collapsible = collapsible, fluid = fluid,
      brand_image = brand_image,
      brand_image_width = brand_image_width,
      brand_image_height = brand_image_height
    )
  )
}

#' @importFrom htmltools css tagAppendAttributes
#' @importFrom bslib bs_get_contrast
navs_bar <- function(
    ..., title = NULL, id = NULL, selected = NULL,
    # TODO: add sticky-top as well?
    position = c("static-top", "fixed-top", "fixed-bottom"),
    header = NULL, footer = NULL,
    bg = NULL, inverse = "auto",
    collapsible = TRUE, fluid = TRUE,
    brand_image,
    brand_image_width,
    brand_image_height) {
  if (identical(inverse, "auto")) {
    inverse <- TRUE
    if (!is.null(bg)) {
      bg <- htmltools::parseCssColors(bg)
      bg_contrast <- bs_get_contrast(bs_theme("navbar-bg" = bg), "navbar-bg")
      inverse <- col2rgb(bg_contrast)[1, ] > 127.5
    }
  }

  navbar <- navbarPage_(
    title = title, ..., id = id, selected = selected,
    position = match.arg(position),
    header = header, footer = footer, collapsible = collapsible,
    inverse = inverse, fluid = fluid,
    brand_image = brand_image,
    brand_image_width = brand_image_width,
    brand_image_height = brand_image_height
  )

  if (!is.null(bg)) {
    # navbarPage_() returns a tagList() of the nav and content
    navbar[[1]] <- tagAppendAttributes(
      navbar[[1]],
      style = css(background_color = paste(bg, "!important"))
    )
  }

  as_fragment(navbar, page = page)
}

#' @importFrom bslib page_fluid
as_fragment <- function(x, page = page_fluid) {
  stopifnot(is.function(page) && "theme" %in% names(formals(page)))
  attr(x, "bslib_page") <- page
  class(x) <- c("bslib_fragment", class(x))
  x
}

page <- function(..., title = NULL, theme = bs_theme(), lang = NULL) {
  as_page(
    shiny::bootstrapPage(..., title = title, theme = theme, lang = lang)
  )
}

as_page <- function(x) {
  class(x) <- c("bslib_page", class(x))
  x
}

dropNulls <- function(x) {
  x[!vapply(x, is.null, FUN.VALUE = logical(1))]
}

isNavbarMenu <- function(x) {
  inherits(x, "shiny.navbarmenu")
}

"%||%" <- function(x, y) {
  if (is.null(x)) y else x
}

#' @importFrom htmltools tagGetAttribute
isTabPanel <- function(x) {
  if (!inherits(x, "shiny.tag")) {
    return(FALSE)
  }
  class <- tagGetAttribute(x, "class") %||% ""
  "tab-pane" %in% strsplit(class, "\\s+")[[1]]
}

# Helpers to build tabsetPanels (& Co.) and their elements
markTabAsSelected <- function(x) {
  attr(x, "selected") <- TRUE
  x
}

findAndMarkSelectedTab <- function(tabs, selected, foundSelected) {
  tabs <- lapply(tabs, function(x) {
    if (foundSelected || is.character(x)) {
      # Strings are not selectable items
    } else if (isNavbarMenu(x)) {
      # Recur for navbarMenus
      res <- findAndMarkSelectedTab(x$tabs, selected, foundSelected)
      x$tabs <- res$tabs
      foundSelected <<- res$foundSelected
    } else if (isTabPanel(x)) {
      # Base case: regular tab item. If the `selected` argument is
      # provided, check for a match in the existing tabs; else,
      # mark first available item as selected
      if (is.null(selected)) {
        foundSelected <<- TRUE
        x <- markTabAsSelected(x)
      } else {
        tabValue <- x$attribs$`data-value` %||% x$attribs$title
        if (identical(selected, tabValue)) {
          foundSelected <<- TRUE
          x <- markTabAsSelected(x)
        }
      }
    }
    return(x)
  })
  return(list(tabs = tabs, foundSelected = foundSelected))
}

# Copy of shiny:::anyNamed()
anyNamed <- function(x) {
  if (length(x) == 0) {
    return(FALSE)
  }
  nms <- names(x)
  if (is.null(nms)) {
    return(FALSE)
  }
  any(nzchar(nms))
}

#' @importFrom utils getFromNamespace
p_randomInt <- function(...) {
  getFromNamespace("p_randomInt", "shiny")(...)
}

isTabSelected <- function(x) {
  isTRUE(attr(x, "selected", exact = TRUE))
}

liTag <- function(id, title, value, icon) {
  tags$li(
    tags$a(
      href = paste0("#", id),
      `data-toggle` = "tab",
      # data-bs-* is for BS5+
      `data-bs-toggle` = "tab",
      `data-value` = value,
      icon, title
    )
  )
}

is_bs_theme <- function(x) {
  inherits(x, "bs_theme")
}

theme_version <- function(theme) {
  if (!is_bs_theme(theme)) {
    return(NULL)
  }

  version <- grep("^bs_version_", class(theme), value = TRUE)
  sub("^bs_version_", "", version)
}

# Copy of shiny::getCurrentThemeVersion()
# (copied to avoid >1.6.0 dependency)
getCurrentThemeVersion <- function() {
  theme <- shiny::getCurrentTheme()
  if (is_bs_theme(theme)) theme_version(theme) else "3"
}

buildNavItem <- function(divTag, tabsetId, index) {
  id <- paste("tab", tabsetId, index, sep = "-")
  # Get title attribute directory (not via tagGetAttribute()) so that contents
  # don't get passed to as.character().
  # https://github.com/rstudio/shiny/issues/3352
  title <- divTag$attribs[["title"]]
  value <- divTag$attribs[["data-value"]]
  active <- isTabSelected(divTag)
  divTag <- tagAppendAttributes(divTag, class = if (active) "active")
  divTag$attribs$id <- id
  divTag$attribs$title <- NULL
  list(
    divTag = divTag,
    liTag = htmltools::tagAddRenderHook(
      liTag(id, title, value, attr(divTag, "_shiny_icon")),
      function(x) {
        if (isTRUE(getCurrentThemeVersion() >= 4)) {
          htmltools::tagQuery(x)$
            addClass("nav-item")$
            find("a")$
            addClass(c("nav-link", if (active) "active"))$
            allTags()
        } else {
          tagAppendAttributes(x, class = if (active) "active")
        }
      }
    )
  )
}

# Builds tabPanel/navbarMenu items (this function used to be
# declared inside the buildTabset() function and it's been
# refactored for clarity and reusability). Called internally
# by buildTabset.
buildTabItem <- function(
    index, tabsetId, foundSelected, tabs = NULL,
    divTag = NULL, textFilter = NULL) {
  divTag <- divTag %||% tabs[[index]]

  # Handles navlistPanel() headers and dropdown dividers
  if (is.character(divTag) && !is.null(textFilter)) {
    return(list(liTag = textFilter(divTag), divTag = NULL))
  }

  if (isNavbarMenu(divTag)) {
    # tabPanelMenu item: build the child tabset
    ulClass <- "dropdown-menu"
    if (identical(divTag$align, "right")) {
      ulClass <- paste(ulClass, "dropdown-menu-right dropdown-menu-end")
    }
    tabset <- buildTabset(
      !!!divTag$tabs,
      ulClass = ulClass,
      textFilter = navbarMenuTextFilter_,
      foundSelected = foundSelected
    )
    return(buildDropdown_(divTag, tabset))
  }

  if (isTabPanel(divTag)) {
    return(buildNavItem(divTag, tabsetId, index))
  }

  if (is_nav_item_(divTag) || is_nav_spacer_(divTag)) {
    return(
      list(liTag = divTag, divTag = NULL)
    )
  }

  # The behavior is undefined at this point, so construct a condition message
  msg <- paste0(
    "Navigation containers expect a collection of `bslib::nav()`/`shiny::tabPanel()`s ",
    "and/or `bslib::nav_menu()`/`shiny::navbarMenu()`s. ",
    "Consider using `header` or `footer` if you wish to place content above ",
    "(or below) every panel's contents."
  )

  # Luckily this case has never worked, so it's safe to throw here
  # https://github.com/rstudio/shiny/issues/3313
  if (!inherits(divTag, "shiny.tag")) {
    stop(msg, call. = FALSE)
  }

  # Unfortunately, this 'off-label' use case creates an 'empty' nav and includes
  # the divTag content on every tab. There shouldn't be any reason to be relying on
  # this behavior since we now have pre/post arguments, so throw a warning, but still
  # support the use case since we don't make breaking changes
  warning(msg, call. = FALSE)

  return(buildNavItem(divTag, tabsetId, index))
}

# Copy of bslib:::navbarMenuTextFilter()
navbarMenuTextFilter_ <- function(text) {
  if (grepl("^\\-+$", text)) {
    tags$li(class = "divider")
  } else {
    tags$li(class = "dropdown-header", text)
  }
}

# Copy of bslib:::buildDropdown()
buildDropdown_ <- function(divTag, tabset) {
  navList <- htmltools::tagAddRenderHook(tabset$navList, function(x) {
    if (isTRUE(getCurrentThemeVersion() >= 4)) {
      htmltools::tagQuery(x)$find(".nav-item")$removeClass("nav-item")$find(".nav-link")$removeClass("nav-link")$addClass("dropdown-item")$allTags()
    } else {
      x
    }
  })
  active <- containsSelectedTab_(divTag$tabs)
  dropdown <- tags$li(
    class = "dropdown", tags$a(
      href = "#",
      class = "dropdown-toggle", `data-toggle` = "dropdown",
      `data-bs-toggle` = "dropdown", `data-value` = divTag$menuName,
      divTag$icon, divTag$title, tags$b(class = "caret")
    ),
    navList, .renderHook = function(x) {
      if (isTRUE(getCurrentThemeVersion() >= 4)) {
        htmltools::tagQuery(x)$addClass("nav-item")$find(".dropdown-toggle")$addClass("nav-link")$addClass(if (active) {
          "active"
        })$allTags()
      } else {
        tagAppendAttributes(x, class = if (active) {
          "active"
        })
      }
    }
  )
  list(divTag = tabset$content$children, liTag = dropdown)
}

# Copy of bslib:::containsSelectedTab()
containsSelectedTab_ <- function(tabs) any(vapply(tabs, isTabSelected, logical(1)))

# This function is called internally by navbarPage, tabsetPanel, and navlistPanel
buildTabset <- function(..., ulClass, textFilter = NULL, id = NULL,
                        selected = NULL, foundSelected = FALSE) {
  tabs <- dropNulls(rlang::list2(...))
  res <- findAndMarkSelectedTab(tabs, selected, foundSelected)
  tabs <- res$tabs
  foundSelected <- res$foundSelected

  # add input class if we have an id
  if (!is.null(id)) ulClass <- paste(ulClass, "shiny-tab-input")

  if (anyNamed(tabs)) {
    nms <- names(tabs)
    nms <- nms[nzchar(nms)]
    stop(
      "Tabs should all be unnamed arguments, but some are named: ",
      paste(nms, collapse = ", ")
    )
  }

  tabsetId <- p_randomInt(1000, 10000)
  tabs <- lapply(seq_len(length(tabs)), buildTabItem,
    tabsetId = tabsetId, foundSelected = foundSelected,
    tabs = tabs, textFilter = textFilter
  )

  tabNavList <- tags$ul(
    class = ulClass, id = id,
    `data-tabsetid` = tabsetId, !!!lapply(tabs, "[[", "liTag")
  )

  tabContent <- tags$div(
    class = "tab-content",
    `data-tabsetid` = tabsetId, !!!lapply(tabs, "[[", "divTag")
  )

  list(navList = tabNavList, content = tabContent)
}

# Copy of bslib:::is_nav_item()
is_nav_item_ <- function(x) tag_has_class_(x, "bslib-nav-item")

# Copy of bslib:::is_nav_spacer()
is_nav_spacer_ <- function(x) tag_has_class_(x, "bslib-nav-spacer")

# Copy of bslib:::tag_has_class()
tag_has_class_ <- function(x, class) {
  if (!inherits(x, "shiny.tag")) {
    return(FALSE)
  }
  htmltools::tagQuery(x)$hasClass(class)
}

# -----------------------------------------------------------------------
# 'Internal' tabset logic that was pulled directly from shiny/R/bootstrap.R
#  (with minor modifications)
# -----------------------------------------------------------------------
#' @importFrom htmltools tagList tagAppendChild
navbarPage_ <- function(
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
    windowTitle = title,
    lang = NULL,
    brand_image,
    brand_image_width,
    brand_image_height) {
  # alias title so we can avoid conflicts w/ title in withTags
  pageTitle <- title

  # navbar class based on options
  navbarClass <- "navbar navbar-default"
  position <- match.arg(position)
  if (!is.null(position)) {
    navbarClass <- paste0(navbarClass, " navbar-", position)
  }
  if (inverse) {
    navbarClass <- paste(navbarClass, "navbar-inverse")
  }

  if (!is.null(id)) {
    selected <- shiny::restoreInput(id = id, default = selected)
  }

  # build the tabset
  tabset <- buildTabset(..., ulClass = "nav navbar-nav", id = id, selected = selected)

  containerClass <- paste0("container", if (fluid) "-fluid")

  # built the container div dynamically to support optional collapsibility
  if (collapsible) {
    navId <- paste0("navbar-collapse-", p_randomInt(1000, 10000))
    containerDiv <- div(
      class = containerClass,
      div(
        class = "navbar-header",
        tags$button(
          type = "button",
          class = "navbar-toggle collapsed",
          `data-toggle` = "collapse",
          `data-target` = paste0("#", navId),
          # data-bs-* is for BS5+
          `data-bs-toggle` = "collapse",
          `data-bs-target` = paste0("#", navId),
          span(class = "sr-only", "Toggle navigation"),
          span(class = "icon-bar"),
          span(class = "icon-bar"),
          span(class = "icon-bar")
        ),
        span(
          class = "navbar-brand",
          tags$img(
            src = brand_image,
            width = brand_image_width, height = brand_image_height,
            class = "d-inline-block align-text-middle me-2"
          ),
          pageTitle
        )
      ),
      div(
        class = "navbar-collapse collapse",
        id = navId, tabset$navList
      )
    )
  } else {
    containerDiv <- div(
      class = containerClass,
      div(
        class = "navbar-header",
        span(class = "navbar-brand", pageTitle)
      ),
      tabset$navList
    )
  }

  # Bootstrap 3 explicitly supported "dropup menus" via .navbar-fixed-bottom,
  # but BS4+ requires .dropup on menus with .navbar.fixed-bottom
  if (position == "fixed-bottom") {
    containerDiv <- htmltools::tagQuery(containerDiv)$
      find(".dropdown-menu")$
      parent()$
      addClass("dropup")$
      allTags()
  }

  # build the main tab content div
  contentDiv <- div(class = containerClass)
  if (!is.null(header)) {
    contentDiv <- tagAppendChild(contentDiv, div(class = "row", header))
  }
  contentDiv <- tagAppendChild(contentDiv, tabset$content)
  if (!is.null(footer)) {
    contentDiv <- tagAppendChild(contentDiv, div(class = "row", footer))
  }

  # *Don't* wrap in bootstrapPage() (shiny::navbarPage()) does that part
  tagList(
    # fluid, narrow navbar
    tags$div(
      class = "container-fluid nav-custom-padding",
      tags$div(
        class = "col-sm-10 offset-md-1 col-sm-offset-1",
        tags$nav(class = navbarClass, role = "navigation", containerDiv)
      )
    ),
    contentDiv
  )
}
