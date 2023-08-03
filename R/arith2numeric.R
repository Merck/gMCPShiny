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

#' Convert arithmetic (character) format to numeric
#'
#' @param x Character string containing arithmetic operators.
#'
#' @return The numeric value from evaluating the arithmetic expression.
#'
#' @export
#'
#' @examples
#' # Return numeric values
#' arithmetic_to_numeric("1/3")
#' arithmetic_to_numeric("sqrt(2)")
#' arithmetic_to_numeric("log(2)")
#' arithmetic_to_numeric("exp((-3^2)/2)/sqrt(2*pi)")
#'
#' # Return NA if containing non-arithmetic string
#' arithmetic_to_numeric("1/3a")
arithmetic_to_numeric <- function(x) {
  w_numeric <- try(safe_eval_str(as.character(x)), silent = TRUE)
  if (inherits(w_numeric, "try-error")) NA else w_numeric
}

#' Evaluate arithmetic expressions (in character string format) safely
#'
#' @param x A character string.
#'
#' @noRd
#'
#' @examples
#' # Can't access variables outside of that environment
#' a <- 1
#' safe_eval_str("a")
#'
#' # Can't create variable in that environment
#' safe_eval_str("a <- 2")
#'
#' # Can't access dangerous functions
#' safe_eval_str('cat("Hi!")')
#'
#' # Can't return non-numeric values
#' safe_eval_str('"a"')
safe_eval_str <- function(x) {
  if (!is.character(x)) stop("`x` must be a character.")
  res <- eval(parse(text = x), envir = env_safe())
  if (!is.numeric(res)) stop("The result must be a numeric.")
  res
}

#' Create a calculator environment to evaluate arithmetic expressions safely
#'
#' Modified from <https://stackoverflow.com/a/18391779>.
#'
#' @importFrom methods getGroupMembers
#'
#' @noRd
env_safe <- function() {
  safe_f <- c(getGroupMembers("Math"), getGroupMembers("Arith"), "(", "pi")
  safe_env <- new.env(parent = emptyenv())
  for (f in safe_f) safe_env[[f]] <- get(f, "package:base")
  safe_env
}
