
#' Write a TreeScan tre (tree) file
#'
#' @description
#' Create a file with the ".tre" extension and writes the input data frame in the OS
#'
#' @details
#' TreeScan software works with ASCII format files. `write.tre()` function creates input data in that format.
#'
#' @param x data frame
#' @param location A string containing the location of the directory where the file will be written.
#' @param filename Name of the tree file to be created without the extension, i.e., no ".tre".
#' @param userownames If TRUE, write the row names into the file. The default is FALSE.
#' @param sep A character string to separate the terms. The default separator is comma.
#' @export

write.tre <- function(x, location, filename, userownames = FALSE, sep = ",") {
  if (class(x) != "data.frame") stop("Need a data frame")
  if (dim(x)[2] < 2) stop("Need a data frame with 2 or more columns")
  utils::write.table(x, quote = FALSE, file = paste0(location, "/", filename, ".tre"), sep = sep, row.names = userownames, col.names = FALSE)
}


#' Write a TreeScan cas (case) file
#'
#' @description
#' Creates a file with the .cas extension and write input data frame in the OS
#'
#' @details
#' TreeScan software works with ASCII format files. `write.cas()` function creates input data in that format.
#' @param x data frame
#' @param location A string containing the location of the directory where the file will be written
#' @param filename Name of the cas file to be created without the extension, i.e., no ".cas"
#' @param userownames If TRUE, write the row names into the file. The default is FALSE
#' @param sep A character string to separate the terms. The default separator is comma.
#' @export

write.cas <- function(x, location, filename, userownames = FALSE, sep = ",") {
  if (class(x) != "data.frame") stop("Need a data frame")
  if (dim(x)[2] < 2) stop("Need a data frame with 2 or more columns")
  utils::write.table(x, quote = FALSE, file = paste0(location, "/", filename, ".cas"), sep = sep, row.names = userownames, col.names = FALSE)
}

#' Write a TreeScan prm (parameter) file
#'
#' @description
#' Creates the set of TreeScan parameter to a specified input data and other options in the OS
#'
#' @details
#' The TreeScan options can be reset or modified `ts.options()` and/or `ts.option.extra()`.
#'
#' @param location A string containing the location of the directory where the file will be written
#' @param filename Name of the prm file to be created without the extension, i.e., no ".prm".
#' @param matchout If TRUE, the result file parameter is reset to share the filename given here.
#' @export

write.ts.prm <- function(location, filename, matchout = TRUE)  {
  if (matchout) ts.options(list("results-filename" = paste0(filename, ".txt")))
  fileconn <- file(paste0(location, "/", filename, ".prm"))
  writeLines(tsenv$.ts.params, fileconn)
  close(fileconn)
  invisible()
}

