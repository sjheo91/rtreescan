
#' Run TreeScan software in OS using prm file
#'
#' @description
#' Calls out into the OS to run TreeScan software, with the parameter file specified
#'
#' @details
#' The analysis is performed according to the options set in the parameter file.
#'
#' @param prmlocation A string containing the location of the directory where the parameter file is located
#' @param prmfilename Name of the parameter file without the extension, i.e., no ".prm".
#' @param tslocation A string containing the location where the TreeScan software is installed. The default location is "c:/Program Files/TreeScan", but the location "c:/Program Files (x86)/TreeScan" was also included.
#' @param tsbatchfilename Name of the TreeScan batch file. Depending on the version of the installed TreeScan software, "treescan64" or "treescan32" is possible, and the default is "treescan64".
#' @param cleanup If TRUE, deletes any TreeScan output files from the OS.
#' @param verbose If TRUE, display the results in the R console as if running TreeScan in batch. This may be especially useful if you expect TreeScan to take a long time to run.
#' @export

treescan <- function(prmlocation, prmfilename, tslocation = "c:/Program Files/TreeScan", tsbatchfilename = "treescan64", cleanup = TRUE, verbose = FALSE) {

  stripslash <- function(string) {
    laststr <- tail(unlist(strsplit(string, "")), 1)
    return(ifelse(laststr == "/", substr(string, 1, nchar(string) - 1), string))
  }
  
  tsfile_0 <- paste0(stripslash(tslocation), "/", tsbatchfilename)
  tsfile_1 <- paste0(stripslash("c:/Program Files (x86)/TreeScan"), "/", tsbatchfilename)
  
  if (prod(Sys.which(c(tsfile_0, tsfile_1)) == ""))
    stop("TreeScan is not there or is not runnable")
  
  if(Sys.which(tsfile_0) != ""){tsfile = tsfile_0}else{tsfile = tsfile_1}
  
  prmloc <- paste0(stripslash(prmlocation), "/")
  infile <- paste0(prmloc, prmfilename, ".prm")

  if (!file.exists(infile))  stop("I can't find that parameter file")
  system(paste(shQuote(tsfile), shQuote(infile)), show.output.on.console = verbose)

  read.treescanmain <- function(location, file) suppressWarnings(readLines(paste0(location, file, ".txt")))

  prm <- suppressWarnings(readLines(infile))
  mainfile <- if (file.exists(paste0(prmloc, prmfilename, ".txt")))
    read.treescanmain(prmloc, prmfilename) else NA

  csvfile <- if (file.exists(paste0(prmloc, prmfilename, ".csv")))
    read.csv(paste0(prmloc, prmfilename, ".csv")) else NA

  llrfile <- if (file.exists(paste0(prmloc, prmfilename, "_llr.csv")))
    read.csv(paste0(prmloc, prmfilename, "_llr.csv")) else NA

  if (cleanup) {
    suppressWarnings(file.remove(paste0(prmloc, prmfilename, ".txt")))
    suppressWarnings(file.remove(paste0(prmloc, prmfilename, ".csv")))
    suppressWarnings(file.remove(paste0(prmloc, prmfilename, "_llr.csv")))
  }
  return(structure(list(main = mainfile, csv = csvfile, llr = llrfile, prm = prm), class = "treescan"))
}

#' Run TreeScan software in OS when a prm file is NOT present
#'
#' @description
#' Calls out into the OS to run TreeScan software, without the parameter file specified
#'
#' @details
#' A parameter file is created with the arguments of the function, and analysis is performed accordingly.
#'
#' @param prmstatus A string indicating the presence or absence of a parameter file
#' @param location A string containing the location of the directory where the case and tree files are located
#' @param cas data frame
#' @param tre data frame
#' @param filename Name of the parameter file you want to create
#' @param scan Interger for scan type (TREEONLY=0, TREETIME=1, TIMEONLY=2)
#' @param model Interger for probability model type (POISSON=0, BERNOULLI=1, UNIFORM=2, Not-Applicable=3)
#' @param conditional Interger for conditional type (UNCONDITIONAL=0, TOTALCASES=1, NODE=2, NODEANDTIME=3)
#' @param self A string for self-control design : unconditional Bernoulli only (y/n)
#' @param prob Numeric for case probability : (integer/integer)
#' @param start A string for start data time range : [integer, integer]
#' @param end A string for end data time range : [integer, integer]
#' @param period A string for data time range : [integer, integer]
#' @param csv A string indicating whether to create CSV results
#' @param html A string indicating whether to create HTML results
#' @param llr A string indicating whether to create LLR results
#' @export

tbss <- function(prmstatus=0, location, filename, cas=NA, tre=NA, scan=0, model=0, conditional=0, self="n", prob="1/2", start="[0,0]", end="[0,0]", period="[0,0]", csv="y", html="n", llr="n", tslocation = "c:/Program Files/TreeScan") {

  if (prmstatus=="y"|prmstatus==1) {
    result <- treescan(prmlocation=location, prmfilename=filename, tslocation=tslocation)
  } else {

    write.cas(cas, location, filename)
    write.tre(tre, location, filename)

    invisible(ts.options(reset = TRUE)) #invisible: not print the return

    # --set parameter options-- #
    ts.options(list("tree-filename"=paste0(filename, ".tre"), "count-filename"=paste0(filename, ".cas")))
    ts.options(list("scan-type"=scan, "probability-model"=model, "conditional-type"=conditional))
    ts.options(list("apply-risk-window-restriction"='y'))
    ts.options(list("results-csv"=csv, "results-html"=html, "results-llr"=llr))

    # Bernoulli
    ts.options(list("self-control-design"=self, "event-probability"=prob))

    # Tree-temporal
    ts.options(list("window-start-range"=start, "window-end-range"=end,"data-time-range"=period))

    write.ts.prm(location, filename)
    result <- treescan(location, filename, tslocation)
  }
    #file.remove(paste0(loc,filename, c('.prm','.cas','.tre')))
    return(result)
}

#' Methods for treescan-class objects
#'
#' @description
#' Define the default methods for Treescan-class objects, which are the result objects from a call to `treescan()`
#'
#' @param x A treescan object
#' @export

print.treescan <- function(x, ...) {
  stopifnot(class(x) == "treescan")
  cat(x$main, fill = 1)
  invisible(x)
}


#' Convert an object a `data.tree` structure
#'
#' @description
#' Creates a `data.tree` structure using hierarchical information from the entered tree file
#'
#' @details
#' This is necessary to visualize the tree structure.
#'
#' @param tree data frame
#' @param fillcolor A string for node color. The default is "lightgrey".
#' @param penwidth A string for node edge thickness. The default is 1.
#' @export
#' @import dplyr
#' @import data.tree
#' @import DiagrammeR

maketree <- function(tree, fillcolor = "lightgrey", penwidth = 1) {

  colnames(tree) <- c("V1","V2")

  i <- 1
  while(TRUE) {
    inter <- intersect(tree[, i], tree[, i + 1])
    tree1 <- tree[tree[, i]%in%inter, c(i, i + 1)]
    tree1 <- tree1[!duplicated(tree1), ]

    if(length(inter) <= 2) break

    colnames(tree1) <- c(paste0("V", i + 1),paste0("V", i + 2))
    tree <- left_join(tree, tree1)
    tree <- as.matrix(tree)
    tree <- ifelse(is.na(tree), "", tree)
    tree <- as.data.frame(tree, stringsAsFactors = FALSE)

    i <- i + 1
  }

  # tree pathstring
  entirenode <<- apply(tree, 1, function(x) paste(x[seq(ncol(tree), 1)], collapse = "/"))
  entiretree <- as.Node(data.frame(pathString = entirenode))

  # define default coloring options
  SetGraphStyle(entiretree, rankdir = "TB")
  SetEdgeStyle(entiretree, arrowhead = "vee", color = "black", penwidth = penwidth)
  SetNodeStyle(entiretree, style = "filled, rounded", shape = "box", fillcolor = fillcolor, fontname = "helvetica", tooltip = GetDefaultTooltip)

  return(entiretree)
}


#' Color the signals detected in the tree structure
#'
#' @description
#' Specifies the color of significant nodes in the entire tree structure created by the `maketree()` function
#'
#' @details
#' The `maketree()` function must be executed first because the result of `maketree()` is an argument.
#'
#' @param result A treescan object
#' @param entiretree A maketree object
#' @param pv Numeric for P-value. The default value is 0.05.
#' @param onlysignal If TRUE, only the part of the tree containing the detected signal, i.e., the sub-tree, is output. If FALSE, color the detected signals across the entire tree structure.
#' @param fillcolor A string for the color of undetected signals. The default is "lightgrey".
#' @param signalcolor A string for the color of detected signals. The default is "Thistle" (lightpink).
#' @param penwidth The thickness of the node line of undetected signals. The default is 1.
#' @param signalpenwidth The thickness of the node line of detected signals. The default is 1.
#' @import data.tree
#' @import DiagrammeR
#' @export
#'

makeSignaltree <- function(result, entiretree, pv = 0.05, onlysignal = TRUE, fillcolor = "lightgrey", signalcolor = "Thistle", penwidth = 1, signalpenwidth = 1) {
  signal <- result[["main"]][grep("Identifier", result[["main"]])]
  pvalue <- result[["main"]][grep("P-value", result[["main"]])]
  RR <- result[["main"]][grep("Relative Risk", result[["main"]])]

  for (i in 1:length(signal)) {
    signal[i] <- tail(strsplit(signal, split = " ")[[i]], 1)
    pvalue[i] <- tail(strsplit(pvalue, split = " ")[[i]], 1)
    RR[i] <- tail(strsplit(RR, split = " ")[[i]], 1)
  }

  path <- c()
  for (i in 1:length(signal)) {
    path[i] <- entirenode[grep(paste0(signal[i], "$"), entirenode)][length(entirenode[grep(paste0(signal[i], "$"), entirenode)])]
  }

  eachNode <- c()
  for (i in 1:length(entirenode)){
    eachNode[i] <- tail(strsplit(entirenode, split = "/")[[i]], 1)
  }

  # If Scan Statistic type is "Tree Temporal", output the Test Statistic; otherwise output the LLR value.
  if(grepl("Tree Temporal", result$main[9])) {
    Tstats <- gsub("^ +", replacement = "", x = result[["main"]][grep("Test Statistic", result[["main"]])])
    Tstats <- Tstats[grep("^Test Statistic", Tstats)];
    for (i in 1:length(signal)) {Tstats[i] <- tail(strsplit(Tstats, split = " ")[[i]], 1)}
    MLCs <<- data.frame("signalNode" = signal,"Pvalue" = as.numeric(pvalue), "Test Statistics" = Tstats, "RR" = RR, "pathString" = path)

  } else {
    LLR <- gsub("^ +", replacement = "", x = result[["main"]][grep("Log Likelihood Ratio", result[["main"]])])
    LLR <- LLR[grep("^Log Likelihood Ratio", LLR)];
    for (i in 1:length(signal)) {LLR[i] <- tail(strsplit(LLR, split = " ")[[i]], 1)}
    MLCs <<- data.frame("signalNode" = signal,"Pvalue" = as.numeric(pvalue), "LLR" = LLR, "RR" = RR, "pathString" = path)
  }

  if(onlysignal == T){signaltree <- as.Node(MLCs[MLCs$Pvalue <= pv, ]) }
  if(onlysignal == F){signaltree <- entiretree}

  # define default coloring options
  SetGraphStyle(signaltree, rankdir = "TB")
  SetEdgeStyle(signaltree, arrowhead = "vee", color = "black", penwidth = penwidth)


  if (sum(signal[pvalue <= pv]%in%as.list(entiretree)[[1]])==0) {
    # Signals contain root
    for(i in 1:length(signal[pvalue <= pv])){ #color signals
      SetNodeStyle(FindNode(node = signaltree, name = signal[pvalue <= pv][i]), inherit = FALSE, keepExisting = F, fillcolor = signalcolor, fontcolor = "black", penwidth = signalpenwidth)}
    SetNodeStyle(signaltree, style = "filled, rounded", shape = "box", fillcolor = fillcolor, fontname = "helvetica", tooltip = GetDefaultTooltip, penwidth = penwidth)
  } else {
    # Signals do not contain root
    eachsignalNode <- gsub(pattern = "\\s", replacement = "", x = gsub("[|°-]", "", as.data.frame(signaltree)$levelName))
    for(i in 1:sum(!eachsignalNode%in%signal)) { #color signalX
      SetNodeStyle(FindNode(node = signaltree, name = eachsignalNode[!eachsignalNode%in%signal][i]), inherit = FALSE, fillcolor = fillcolor, fontcolor = "black", penwidth = penwidth)
    }
    SetGraphStyle(signaltree, rankdir = "TB")
    SetEdgeStyle(signaltree, arrowhead = "vee", color = "black", penwidth = signalpenwidth)
    SetNodeStyle(signaltree, style = "filled, rounded", shape = "box", fillcolor = signalcolor, fontname = "helvetica", tooltip = GetDefaultTooltip, penwidth = signalpenwidth)
  }

  return(signaltree)

}

#' Convert an object a `data.tree` structure1
#'
#' @description
#' Creates a `data.tree` structure using hierarchical information from the entered tree file
#'
#' @details
#' This is necessary to visualize the tree structure.
#'
#' @param tree data frame
#' @param fillcolor A string for node color. The default is "lightgrey".
#' @param penwidth A string for node edge thickness. The default is 1.
#' @export
#' @import dplyr
#' @import data.tree
#' @import DiagrammeR

maketree1 <- function(tree = tree, fillcolor = "lightgrey") {
  
  if (!requireNamespace("collapsibleTree")){
    install.packages("collapsibleTree")
  }
  
  library(collapsibleTree)
  
  tree[,2][which(tree[,2] == '')] <- NA
  tree <- tree[c(2,1)]
  
  tree$Color <- fillcolor
  entiretree <- collapsibleTreeNetwork(tree, fill = "Color", collapsed = FALSE)
  return(entiretree)
}


#' Color the signals detected in the tree structure1
#'
#' @description
#' Specifies the color of significant nodes in the entire tree structure created by the `maketree()` function
#'
#' @details
#' The `maketree()` function must be executed first because the result of `maketree()` is an argument.
#'
#' @param result A treescan object
#' @param tree Tree Structure
#' @param fillcolor A string for the color of undetected signals. The default is "lightgrey".
#' @param signalcolor A string for the color of detected signals. The default is "Thistle" (lightpink).
#' @import data.tree
#' @import DiagrammeR
#' @export
#'

makeSignaltree1 <- function(result = result, tree = tree, 
                            fillcolor = "lightgrey", signalcolor = "Thistle") {
  
  if (!requireNamespace("collapsibleTree")){
    install.packages("collapsibleTree")
  }

  library(collapsibleTree)  
  
  signal <- result$csv$Node.Identifier
  pvalue <- result$csv$P.value
  RR <- result$csv$Relative.Risk
  
  tree[,2][which(tree[,2] == '')] <- NA
  tree <- tree[c(2,1)]
  
  tree$Color <- ifelse(tree$NodeID %in% signal, signalcolor, fillcolor)
  tree$P.value <- ifelse(tree$NodeID %in% signal, pvalue, "No cut reported for node.")
  tree$RelativeRisk <- ifelse(tree$NodeID %in% signal, RR, " ")
  
  
  signaltree <- collapsibleTreeNetwork(tree, fill = "Color", 
                                       attribute = c('P.value'),collapsed = FALSE)
  
  return(signaltree)
  
}

