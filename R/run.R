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

#' Run Shiny app
#'
#' @inheritParams shiny::runApp
#'
#' @return An object that represents the app.
#'   Printing the object or passing it to [shiny::runApp()] will run the app.
#'
#' @importFrom shiny shinyAppFile
#'
#' @export
#'
#' @examples
#' if (interactive()) {
#'   gMCPShiny::run_app()
#' }
run_app <- function(port = getOption("shiny.port")) {
  shiny::shinyAppFile(
    system.file("app", "app.R", package = "gMCPShiny"),
    options = list(port = port)
  )
}
