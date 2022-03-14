## ----"setup", include=FALSE---------------------------------------------------
knitr::opts_knit$set(root.dir = getwd())  # with something else than `getwd()`

## ---- message=FALSE-----------------------------------------------------------
library("rtreescan")
library("data.tree")

## ---- echo = FALSE------------------------------------------------------------
# environmental variable
tsenv <- new.env()
tsenv$.ts.params <- prm
tsenv$.ts.params.defaults <- prm

# loading case and tree files
data(Berncas, package = "rtreescan")
data(Poiscas, package = "rtreescan")
data(TreeTempcas, package = "rtreescan")
data(tree, package = "rtreescan")

# loading prm files
data(Bernprm, package = "rtreescan")
data(Poisprm, package = "rtreescan")
data(TreeTempprm, package = "rtreescan")

# setting working directory
loc <- getwd()
setwd(loc)

## -----------------------------------------------------------------------------
head(tree)

## -----------------------------------------------------------------------------
head(Poiscas)

## ---- eval = FALSE------------------------------------------------------------
#  # If a parameter file is available, set the prmstatus options to 'y'.
#  tbss(prmstatus = "y", location = loc, filename = "Poisson")

## ---- eval = TRUE-------------------------------------------------------------
result <- tbss(prmstatus = "y", location = loc, filename = "Poisson")
result$csv

## ---- fig.width=7, message = FALSE--------------------------------------------
entiretree <- maketree(tree)
plot(entiretree)

signaltree <- makeSignaltree(result, entiretree, pv = 0.1, onlysignal = FALSE)
plot(signaltree)

onlysignaltree <- makeSignaltree(result, entiretree, pv = 0.1, onlysignal = TRUE)
plot(onlysignaltree)

## -----------------------------------------------------------------------------
head(Berncas)

## -----------------------------------------------------------------------------
# Check the currently set options.
head(ts.options())

## ---- eval=FALSE--------------------------------------------------------------
#  # Set options as specified above.
#  ts.options(list("scan-type"=0, "probablity-model"=1, "self-control-design"="y", "result-csv"="y"))

## ---- eval = FALSE------------------------------------------------------------
#  # run tbss funtion
#  tbss(location = loc, filename = "Bernoulli", cas = Berncas, tre = tree, conditional = 0, model = 1, self = "y", csv = "y")

## ---- echo = FALSE------------------------------------------------------------
result <- tbss(prmstatus = "y", location = loc, filename="Bernoulli")

## ---- fig.width=7, message = FALSE--------------------------------------------
signaltree <- makeSignaltree(result, entiretree, pv = 0.1, onlysignal = FALSE)
plot(signaltree)

## -----------------------------------------------------------------------------
head(TreeTempcas)

## ---- eval = FALSE------------------------------------------------------------
#  # Set working directory
#  loc <- "C:/Users/Desktop"
#  
#  # Write cas and tre files in a TreeScan-readable format
#  write.cas(TreeTempcas, loc, "TreeTemporal")
#  write.tre(tree, loc, "TreeTemporal")
#  
#  # Reset options to default pararmeter values
#  invisible(ts.options(reset = TRUE)) #invisible: not print the return
#  
#  # Set TreeScan parameters that the user wants
#  ts.options(list("tree-filename"="TreeTemporal.tre", "count-filename"="TreeTemporal.cas"))
#  ts.options(list("scan-type"=1, "probability-model"=2, "conditional-type"=3))
#  ts.options(list("window-start-range"="[1,14]", "window-end-range"="[1,21]", "data-time-range"="[1,28]"))
#  ts.options(list("apply-risk-window-restriction"='y'))
#  ts.options(list("results-csv"="y", "results-html"="y"))
#  
#  # write new parameter file with options set above
#  write.ts.prm(loc, "TreeTemporal")
#  
#  # run TreeScan in the OS
#  result <- treescan(loc, "TreeTemporal")

## ---- eval = FALSE------------------------------------------------------------
#  tbss(location = loc, filename = "TreeTemporal", cas = TreeTempcas, tre = tree, scan = 1, model = 2, conditional = 3, start = "[1,14]", end = "[1,21]", period = "[1,28]", csv = "y")

## ---- fig.width=7, message = FALSE--------------------------------------------
signaltree <- makeSignaltree(result, entiretree, pv = 0.1, onlysignal = FALSE)
plot(signaltree)

## -----------------------------------------------------------------------------
data(PVcas, package = "rtreescan")
data(PVtre, package = "rtreescan")

## -----------------------------------------------------------------------------

## -----------------------------------------------------------------------------
head(PVcas)
head(PVtre)

## -----------------------------------------------------------------------------
# write cas and tre files in a TreeScan-readable format
write.cas(PVcas, loc, "PV")
write.tre(PVtre, loc, "PV")

invisible(ts.options(reset = TRUE)) #invisible: not print the return

# set TreeScan parameters
ts.options(list("tree-filename" = "PV.tre", "count-filename" = "PV.cas"))
ts.options(list("probability-model"= 1, "conditional-type" = 0, "self-control-design"='y'))
ts.options(list("apply-risk-window-restriction"='y'))
ts.options(list("results-csv"='y'))

# write parameter file
write.ts.prm(loc, "PV")

# run TreeScan in the OS
result <- tbss(prmstatus="y", location=loc, filename = "PV")

## ---- fig.width=7, message = FALSE--------------------------------------------
entiretree <- maketree(PVtre)

signaltree <- makeSignaltree(result, entiretree, onlysignal = FALSE)
plot(signaltree)

## ---- echo=FALSE, message = FALSE---------------------------------------------
result <- tbss(prmstatus = "y", location = loc, filename = "Bernoulli")
entiretree <- maketree(tree)

## ---- fig.width=7-------------------------------------------------------------
onlysignaltree <- makeSignaltree(result, entiretree, onlysignal = T, signalcolor = "darkolivegreen4")
plot(onlysignaltree)

SetNodeStyle(onlysignaltree$Node6$Node3, fillcolor = "goldenrod2", penwidth = "5px")
plot(onlysignaltree)

## ---- echo = FALSE, include = FALSE-------------------------------------------
#clean up!
#file.remove(paste0(loc,"/Bernoulli.txt"))
#file.remove(paste0(loc,"/Poisson.txt"))
#file.remove(paste0(loc,"/Poisson.html"))
#file.remove(paste0(loc,"/TreeTemporal.txt"))
#file.remove(paste0(loc,"/PV.txt"))

