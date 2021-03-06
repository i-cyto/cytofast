#' Read .fcs files created by cytosplore
#'
#' @description
#' This function reads and combines .FCS files created specifcally by Cytosplore.
#'
#' @param dir directory containing the .FCS files created by Cytosplore
#' @param colNames character string that specifies which label should be used as the column names. This
#' could be the name of the markers 'names' or the description for the markers 'description'.
#'
#' @return The function returns an object of class \code{\link[cytofast]{cfList}}. 
#'
#' @note To succesfully read the .FCS files created by cytosplore make sure that there are no double
#' channels. It could happen for example that the Cytosplore tag (CSPLR_ST) is added twice, which will most 
#' likely cause an error. Therefore, never add the sample tag twice. It is possible to remove the double
#' tag in software like Flowjo. 
#' 
#' As for the `colNames` parameter, both 'names' and 'description' will always work, it 
#' is up to the user to decide which one is most preferable. 
#'   
#' This function is a wrapper around \code{\link[flowCore]{read.FCS}}. For more
#' flexibility see their help page. 
#'
#' @keywords read, data, FCS, cytosplore
#'
#' @importFrom flowCore read.FCS
#' @import Rdpack
#'
#' @examples
#' dirFCS <- system.file("extdata", package="cytofast")
#' cfData <- readCytosploreFCS(dir = dirFCS, colNames = "description")
#'
#' @export
readCytosploreFCS <- function(dir=NULL, colNames = c("names", "description")){

  if(is.character(dir) == FALSE){
    stop("directory is not a character string")
  } else if(dir.exists(dir) == FALSE) {
    stop("directory does not exist")
  }

  if(missing(colNames)){
    warning("colNames was not specified and set to 'description'")
    colNames <- "description"
  } else if(!colNames %in% c("names", "description")){
    warning("colNames was not correctly specified and set to 'description'")
    colNames <- "description"
  }

  FCSFilePaths <- list.files(path=dir, pattern=".fcs", full.names=TRUE)
  FCSFileNames <- list.files(path=dir, pattern=".fcs", full.names=FALSE)
  if(length(FCSFileNames) == 0){
    stop("there are no .fcs files in this directory")
  }

  # Loop through files and read into R environment
  x <- data.frame()
  for(i in seq_along(FCSFilePaths)){
    message(paste("Reading .FCS cluster:",i))

    FCSfile <- flowCore::read.FCS(FCSFilePaths[i],
                        transformation=FALSE,
                        truncate_max_range=FALSE)

    # Only keep expression
    exprs <- FCSfile@exprs

    # Change column names to description
    if(colNames == "description"){
      colnames(exprs) <- FCSfile@parameters@data$desc
    }

    x <- rbind(x, data.frame(clusterID=FCSFileNames[i], exprs))
  }

  # Make sampletag a factor and rename to sampleID
  x$CSPLR_ST <- as.factor(x$CSPLR_ST)
  x$clusterID <- as.factor(x$clusterID)
  colnames(x)[colnames(x) == 'CSPLR_ST'] <- 'sampleID'

  # change order and return cfList
  x <- x[,c("clusterID", "sampleID", setdiff(colnames(x), c("clusterID", "sampleID")))]
  output <- new("cfList", samples = data.frame(sampleID = levels(x$sampleID),
                                               row.names = levels(x$sampleID)),
                          expr = x)
  return(output)
}


