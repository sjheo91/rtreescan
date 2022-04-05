
.onAttach <- function(libname, pkgname) {

  packageStartupMessage("rtreescan only does anything useful if you have TreeScan")
  packageStartupMessage("See http://www.treescan.org/ for free access")

  tsenv <<- new.env(parent = emptyenv())
  prm <- readLines("https://raw.githubusercontent.com/sjheo91/rtreescan/master/default.prm")

  tsenv$.ts.params.defaults <- prm
  tsenv$.ts.params <- prm
}
