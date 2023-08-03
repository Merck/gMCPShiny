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

#' Text input addon
#'
#' Text input with addon on the right side.
#'
#' @inheritParams shiny::textInput
#' @param addon Addon text.
#'
#' @return Text input with addon on the right side.
#'
#' @references
#' <https://getbootstrap.com/docs/5.3/forms/input-group/>
#'
#' @importFrom htmltools tags span
#' @importFrom shiny validateCssUnit restoreInput
#'
#' @export
#'
#' @examples
#' textInputAddonRight(
#'   "filename",
#'   label = "Name of the report:",
#'   value = "gMCPShiny",
#'   addon = ".Rmd",
#'   width = "100%"
#' )
textInputAddonRight <- function(inputId, label, value = "", width = NULL, placeholder = NULL, addon = NULL) {
  value <- restoreInput(id = inputId, default = value)
  div(
    class = "form-group shiny-input-container",
    style = htmltools::css(width = validateCssUnit(width)),
    shinyInputLabel_(inputId, label),
    div(
      class = "input-group",
      tags$input(
        id = inputId,
        type = "text",
        class = "form-control",
        value = value,
        placeholder = placeholder
      ),
      span(addon, class = "input-group-text")
    )
  )
}

# Copy of shiny:::shinyInputLabel()
shinyInputLabel_ <- function(inputId, label = NULL) {
  tags$label(
    label,
    class = "control-label",
    class = if (is.null(label)) "shiny-label-null",
    # `id` attribute is required for `aria-labelledby` used by screen readers:
    id = paste0(inputId, "-label"),
    `for` = inputId
  )
}
