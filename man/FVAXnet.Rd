% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/FVAXnet_function.R
\name{FVAXnet}
\alias{FVAXnet}
\title{FVAX network}
\usage{
FVAXnet(wiot, loop, ROW, YEAR)
}
\arguments{
\item{wiot}{The WIOT data loaded with \code{data(wiotyear)} command}

\item{loop}{TRUE to keep loop (country A to country A), FALSE to remove loops}

\item{ROW}{TRUE to keep ROW (Rest of World), FALSE to remove ROW}

\item{YEAR}{year}
}
\value{
Value added contribution matrix
}
\description{
This creates a value added contribution matrix from the raw wiot data
}
\references{
Zhu Z, Puliga M, Cerina F, Chessa A, Riccaboni M (2015) Global Value Trees. PLoS ONE 10(5): e0126699. https://doi.org/10.1371/journal.pone.0126699
}
