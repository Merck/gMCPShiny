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

#' Adaptive color palette (discrete)
#'
#' Create a discrete palette that will use the first `n` colors from
#' the supplied color values when the palette has enough colors.
#' Otherwise, use an interpolated color palette.
#'
#' @param values A vector of color values.
#'
#' @importFrom grDevices colorRampPalette
#'
#' @noRd
pal_ramp <- function(values) {
  force(values)
  function(n) {
    if (n <= length(values)) {
      values[seq_len(n)]
    } else {
      colorRampPalette(values, alpha = TRUE)(n)
    }
  }
}

#' Adaptive color palette generator
#'
#' Adaptive color palette generator using `pal_ramp()`.
#'
#' @param raw_cols Character vector of color hex values.
#' @param alpha Transparency level, a real number in (0, 1].
#'
#' @importFrom grDevices col2rgb rgb
#'
#' @noRd
pal_adaptive <- function(raw_cols, alpha = 1) {
  if (alpha > 1L || alpha <= 0L) stop("alpha must be in (0, 1]")
  raw_cols_rgb <- col2rgb(raw_cols)
  alpha_cols <- rgb(
    raw_cols_rgb[1L, ], raw_cols_rgb[2L, ], raw_cols_rgb[3L, ],
    alpha = alpha * 255L, names = names(raw_cols),
    maxColorValue = 255L
  )

  pal_ramp(unname(alpha_cols))
}

hgraph_pal_hex <- list(
  "d3.category10" = c(
    "#1F77B4", "#FF7F0E", "#2CA02C", "#D62728", "#9467BD", "#8C564B",
    "#E377C2", "#7F7F7F", "#BCBD22", "#17BECF"
  ),
  "d3.category20" = c(
    "#1F77B4", "#FF7F0E", "#2CA02C", "#D62728", "#9467BD", "#8C564B",
    "#E377C2", "#7F7F7F", "#BCBD22", "#17BECF", "#AEC7E8", "#FFBB78",
    "#98DF8A", "#FF9896", "#C5B0D5", "#C49C94", "#F7B6D2", "#C7C7C7",
    "#DBDB8D", "#9EDAE5"
  ),
  "d3.category20b" = c(
    "#393B79", "#637939", "#8C6D31", "#843C39", "#7B4173", "#5254A3",
    "#8CA252", "#BD9E39", "#AD494A", "#A55194", "#6B6ECF", "#B5CF6B",
    "#E7BA52", "#D6616B", "#CE6DBD", "#9C9EDE", "#CEDB9C", "#E7CB94",
    "#E7969C", "#DE9ED6"
  ),
  "d3.category20c" = c(
    "#3182BD", "#E6550D", "#31A354", "#756BB1", "#636363", "#6BAED6",
    "#FD8D3C", "#74C476", "#9E9AC8", "#969696", "#9ECAE1", "#FDAE6B",
    "#A1D99B", "#BCBDDC", "#BDBDBD", "#C6DBEF", "#FDD0A2", "#C7E9C0",
    "#DADAEB", "#D9D9D9"
  ),
  "Okabe-Ito" = c(
    "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00",
    "#CC79A7", "#999999"
  ),
  "Teal" = c(
    "#00857C", "#6ECEB2", "#BFED33", "#FFF063", "#0C2340", "#5450E4",
    "#688CE8", "#69B8F7"
  )
)

#' Adaptive color palette generator for hGraph
#'
#' Adaptive color palette generator for hGraph using
#' `pal_adaptive()` and `pal_ramp()`.
#'
#' @param pal_name Color palette name.
#' @param n How many different colors for the selected color palette?
#' @param alpha Transparency level, a real number in (0, 1].
#'
#' @return A vector of color hex values.
#'
#' @export
#'
#' @examples
#' hgraph_palette("gray", n = 10)
#' hgraph_palette("Okabe-Ito", n = 15)
hgraph_palette <- function(
    pal_name = c(
      "gray",
      "Okabe-Ito",
      "d3.category10",
      "d3.category20",
      "d3.category20b",
      "d3.category20c",
      "Teal"
    ), n, alpha = 1) {
  pal_name <- match.arg(pal_name)

  if (pal_name == "gray") {
    grDevices::gray.colors(n, alpha = alpha)
  } else {
    pal_adaptive(hgraph_pal_hex[[pal_name]], alpha = alpha)(n)
  }
}
