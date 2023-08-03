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

#' Card with header
#'
#' Card with header (Bootstrap 5).
#'
#' @param title Card title.
#' @param ... List of elements to include in the body of the card.
#'
#' @return Card element with header and body.
#'
#' @importFrom htmltools tags div
#'
#' @export
#'
#' @examples
#' if (interactive()) {
#'   headerCard("Card title", "Card body")
#' }
headerCard <- function(title, ...) {
  div(
    class = "card",
    div(
      class = "card-header",
      tags$h5(
        class = "card-title",
        title
      )
    ),
    div(
      class = "card-body",
      ...
    )
  )
}
