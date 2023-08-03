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

#' Convert transitions data frame into an hgraph matrix
#'
#' Convert transitions data frame into an hgraph matrix,
#' given all the hypothesis names, with transition weights evaluated.
#'
#' @param namesH Hypothesis names.
#' @param df Input data frame of transitions.
#'
#' @return An hgraph matrix.
#'
#' @export
#'
#' @examples
#' df2graph(
#'   namesH = paste0("H", 1:6),
#'   df = data.frame(
#'     From = paste0("H", 1:4),
#'     To = paste0("H", c(2:4, 1)),
#'     Weight = rep(1, 4)
#'   )
#' )
df2graph <- function(namesH, df) {
  # Check to make sure the column names are present
  if (!any(names(df) %in% c("From", "To", "Weight"))) {
    print("Must have three columns in the input data frame: 'From', 'To', and 'Weight'.")
  }
  dim <- length(namesH)
  m <- matrix(rep(0, dim^2), nrow = dim)

  for (i in 1:nrow(df)) {
    row.index <- which(namesH %in% df$From[i])
    col.index <- which(namesH %in% df$To[i])
    m[row.index, col.index] <- arithmetic_to_numeric(df$Weight[i])
  }
  m
}
