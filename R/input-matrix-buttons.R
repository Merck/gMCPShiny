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

#' Matrix buttons
#'
#' Buttons to add/delete rows and reset a matrix input.
#'
#' @param inputId ID of the matrix input.
#'
#' @return A matrix button group.
#'
#' @importFrom shiny fluidRow column actionButton icon
#'
#' @export
#'
#' @examples
#' matrixButtonGroup("matrix")
matrixButtonGroup <- function(inputId) {
  fluidRow(
    column(
      4,
      actionButton(
        paste0("btn_", inputId, "_addrow"),
        label = "",
        icon = icon("plus"),
        width = "100%",
        class = "btn btn-block btn-outline-primary"
      )
    ),
    column(
      4,
      actionButton(
        paste0("btn_", inputId, "_delrow"),
        label = "",
        icon = icon("minus"),
        width = "100%",
        class = "btn btn-block btn-outline-primary"
      )
    ),
    column(
      4,
      actionButton(
        paste0("btn_", inputId, "_reset"),
        label = "",
        icon = icon("arrow-rotate-left"),
        width = "100%",
        class = "btn btn-block btn-outline-primary"
      )
    )
  )
}

#' @rdname matrixButtonGroup
#'
#' @param x Name of the matrix input to add a row to or delete a row from.
#'
#' @export
addMatrixRow <- function(x) {
  rbind(x, rep(NA, ncol(x)))
}

#' @rdname matrixButtonGroup
#'
#' @export
delMatrixRow <- function(x) {
  if (nrow(x) == 1L) {
    return(x)
  }
  x[-nrow(x), , drop = FALSE]
}
