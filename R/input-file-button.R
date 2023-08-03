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

#' File input button
#'
#' File input but with only the button.
#'
#' @inheritParams shiny::fileInput
#'
#' @return Button for file input.
#'
#' @importFrom htmltools tags span
#' @importFrom shiny validateCssUnit restoreInput
#'
#' @export
#'
#' @examples
#' fileButtonInput(
#'   "restore",
#'   label = NULL,
#'   buttonLabel = "Restore",
#'   multiple = FALSE,
#'   accept = ".rds",
#'   width = "50%"
#' )
fileButtonInput <- function(
    inputId,
    label,
    multiple = FALSE,
    accept = NULL,
    width = NULL,
    buttonLabel = "Browse...",
    placeholder = "No file selected") {
  restoredValue <- restoreInput(id = inputId, default = NULL)
  if (!is.null(restoredValue) && !is.data.frame(restoredValue)) {
    warning("Restored value for ", inputId, " has incorrect format.")
    restoredValue <- NULL
  }
  if (!is.null(restoredValue)) {
    restoredValue <- toJSON_(restoredValue, strict_atomic = FALSE)
  }
  inputTag <- tags$input(
    id = inputId, name = inputId, type = "file",
    style = "display: none;", `data-restore` = restoredValue
  )
  if (multiple) {
    inputTag$attribs$multiple <- "multiple"
  }
  if (length(accept) > 0) {
    inputTag$attribs$accept <- paste(accept, collapse = ",")
  }
  div(
    style = "display: inline-block; width: 10rem; margin-bottom: -2rem; margin-right: -3px;", # not super elegant but works
    div(
      class = "form-group shiny-input-container", style = if (!is.null(width)) {
        paste0("width: ", validateCssUnit(width), ";")
      },
      shinyInputLabel_(inputId, label),
      div(
        class = "input-group",
        style = "width: 10rem;",
        tags$label(
          class = "input-group-prepend",
          span(
            class = "btn btn-outline-primary",
            tags$i(class = "fa fa-upload"),
            buttonLabel,
            inputTag
          )
        )
      )
    )
  )
}

# Copy of shiny:::toJSON()
toJSON_ <- function(
    x, ..., dataframe = "columns", null = "null", na = "null",
    auto_unbox = TRUE, digits = getOption("shiny.json.digits", 16),
    use_signif = TRUE, force = TRUE, POSIXt = "ISO8601", UTC = TRUE,
    rownames = FALSE, keep_vec_names = TRUE, strict_atomic = TRUE) {
  if (strict_atomic) {
    x <- I(x)
  }

  # I(x) is so that length-1 atomic vectors get put in [].
  jsonlite::toJSON(x,
    dataframe = dataframe, null = null, na = na,
    auto_unbox = auto_unbox, digits = digits, use_signif = use_signif,
    force = force, POSIXt = POSIXt, UTC = UTC, rownames = rownames,
    keep_vec_names = keep_vec_names, json_verbatim = TRUE, ...
  )
}
