% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cytoHeatmaps.R
\name{cytoHeatmaps}
\alias{cytoHeatmaps}
\title{Draw heatmaps for cfList}
\usage{
cytoHeatmaps(cfList, group, legend = FALSE)
}
\arguments{
\item{cfList}{a cfList object.}

\item{group}{one of:
\itemize{
\item a character vector referring to a column name in the \code{samples} slot of the \code{cfList}.
\item a factor indicating the grouping (x-axis) for the boxplots.
}}

\item{legend}{logical, whether a legend should be added}
}
\value{
None
}
\description{
Function to draw two heatmaps. They visualize the median intensity of the markers for the
created clusters. The ordering of the clusters is based on the default
hierarchical cluster analysis \code{\link[stats]{hclust}}. Note that hclust takes the data after
the median intensity is calculated per cluster, thus placing the most similar clusters
next to each other.
}
\examples{
# Read Data
dirFCS <- system.file("extdata", package="cytofast")
cfData <- readCytosploreFCS(dir = dirFCS, colNames = "description")

# Add cell counts to cfList and add meta data
cfData <- cellCounts(cfData, frequency = TRUE, scale = TRUE)
meta <- spitzer[match(row.names(cfData@samples), spitzer[,"CSPLR_ST"]),]
cfData@samples <- cbind(cfData@samples, meta)

# Remove unnecessary markers
cfData@expr <- cfData@expr[,-c(3:10, 13:16, 55:59, 61:63)]

# Draw heatmaps
cytoHeatmaps(cfData, group = "group", legend = TRUE)

}
\keyword{FCS}
\keyword{heatmap,}
\keyword{markers,}
