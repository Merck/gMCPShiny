% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/df2graph.R
\name{df2graph}
\alias{df2graph}
\title{Convert transitions data frame into an hgraph matrix}
\usage{
df2graph(namesH, df)
}
\arguments{
\item{namesH}{Hypothesis names.}

\item{df}{Input data frame of transitions.}
}
\value{
An hgraph matrix.
}
\description{
Convert transitions data frame into an hgraph matrix,
given all the hypothesis names, with transition weights evaluated.
}
\examples{
df2graph(
  namesH = paste0("H", 1:6),
  df = data.frame(
    From = paste0("H", 1:4),
    To = paste0("H", c(2:4, 1)),
    Weight = rep(1, 4)
  )
)
}
