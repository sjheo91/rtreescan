
#' Substitute new values into the input object
#'
#' @description
#' Replace an existing value found in one object with a new one
#'
#' @details For each line of x, the function: 1) finds the "name" and the "value" 2) checks to see whether the "name" exists in tsparams; if not, prints a warning but if so, replaces the existing line of tsparams with that line of x. Not expected to be used directly.
#'
#' @param x A character vector of the form "name = value"
#' @param tsparams A character vector with arbitrary lines, currently imagined to be .ts.params
#' @return The modified tsparams
#' @export

subin <- function (x, tsparams) {
  for (i in 1:length(x)) {
    inprm <- substr(x[i], 1, regexpr("=", x[i]))
    indef <- substr(x[i], regexpr("=", x[i]) + 1, nchar(x[i]))
    if (length(which(substr(tsparams, 1, regexpr("=", tsparams)) == inprm)) == 0)
      warning('Trouble! There is no parameter "', substr(inprm, 1, regexpr("=",inprm) - 1), '"', call. = FALSE)
    else {tsparams[which(substr(tsparams, 1, regexpr("=",tsparams)) == inprm)] = paste0(inprm, indef)}
  }
  return(tsparams)
}


#' Change list version of parameters into character vectors
#'
#' @description
#' Turns a list of options into character vectors
#'
#' @details
#' The resulting character vector has values such as "name = value" where "name" was the named item of the list. Not expected to be used directly.
#'
#' @param x A list.
#' @return A character vector
#' @export

charlistopts <- function (x) {
  paste0(names(x), "=", unlist(x))
}

#' Set or reset parameters to be used by TreeScan
#'
#' @description
#' Set or reset parameters to be used by TreeScan
#'
#' @details
#' `ts.options()` is intended to function like `par()` or `options()`.
#'
#' @param invals A list with entries of the form "name = value", where the value should be in quotes unless it is a number. Alternatively, maybe a character vector whose entries are of the form "name = value". The "name" in either case should be a valid TreeScan parameter name.
#' @param reset If TRUE, restore the default parameter values
#' @export

ts.options <- function (invals = NULL, reset = FALSE) {
  inparms <- tsenv$.ts.params
  if (reset == TRUE) tsenv$.ts.params <- tsenv$.ts.params.defaults
  if (is.null(invals)) {return(tsenv$.ts.params)}
  else {
    if (class(invals) == "list") invals <- charlistopts(invals)
    tsenv$.ts.params <- subin(invals, inparms)
    invisible(tsenv$.ts.params)
  }
}
