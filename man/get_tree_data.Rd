% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/accessor.R
\name{get_tree_data}
\alias{get_tree_data}
\title{get_tree_data}
\usage{
get_tree_data(tree_object)
}
\arguments{
\item{tree_object}{a \code{treedata} object}
}
\value{
tbl_df
}
\description{
get associated data stored in treedata object
}
\examples{
library(treeio)
file <- system.file("extdata/BEAST", "beast_mcc.tree", package="treeio")
beast <- read.beast(file)
get_tree_data(beast)
}
\author{
guangchuang yu
}
