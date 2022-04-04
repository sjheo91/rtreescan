rtreescan vignette
================

**TreeScan™** is a data mining software that allows users to analyze
large data sets using a different version of the tree-based scan
statistic. It looks for excess risk in any of a large number of
individual cells in a database as well as in groups of closely related
cells. It can be used to detect side effects of drugs and vaccines, as
well as to find a significant signal in other data in hierarchical tree
structures.<br/>

**rtreescan** allows TreeScan™ to operate in an R environment, making it
convenient and flexible.  
The functions in the package can be grouped into three main parts:
parameter functions that set parameters for TreeScan™ or write them in a
file to the OS; execution functions that run TreeScan™ in OS and
generate output files; plotting functions that visualizes the structure
of a tree.<br/>

rtreescan only does anything useful if you have TreeScan™. It is not
open-source, but it is distributed free of charge. You can be downloaded
for free from the link. \<<https://www.treescan.org>\><br/>

**Basic usage of the package will:**

1.  use the `ts_data()` function to covert data to return a tre
    structure and a count data structure
2.  use the `tbss()` function to call out into the OS to run TreeScan
    softwarem without the parameter file specified
3.  use the `maketree()` or `makeSignaltree1()` function to create a
    ‘data.tree’ structure using hierarchical information form the
    entered tree file </br>

------------------------------------------------------------------------

``` r
lsf.str("package:rtreescan")
```

    ## charlistopts : function (x)  
    ## makeSignaltree : function (result, entiretree, pv = 0.05, onlysignal = TRUE, fillcolor = "lightgrey", 
    ##     signalcolor = "Thistle", penwidth = 1, signalpenwidth = 1)  
    ## makeSignaltree1 : function (result = result, tree = tree, fillcolor = "lightgrey", signalcolor = "Thistle")  
    ## maketree : function (tree, fillcolor = "lightgrey", penwidth = 1)  
    ## maketree1 : function (tree = tree, fillcolor = "lightgrey")  
    ## subin : function (x, tsparams)  
    ## tbss : function (prmstatus = 0, location, filename, cas = NA, tre = NA, scan = 0, 
    ##     model = 0, conditional = 0, self = "n", prob = "1/2", start = "[0,0]", 
    ##     end = "[0,0]", period = "[0,0]", csv = "y", html = "n", llr = "n", 
    ##     tslocation = "c:/Program Files/TreeScan")  
    ## treescan : function (prmlocation, prmfilename, tslocation = "c:/Program Files/TreeScan", 
    ##     tsbatchfilename = "treescan64", cleanup = TRUE, verbose = FALSE)  
    ## ts.options : function (invals = NULL, reset = FALSE)  
    ## ts_data : function (data, AE_code, drug_code, case, control, lv_sep, model, condition, 
    ##     rate, match_vars, N, Start, End, match)  
    ## write.cas : function (x, location, filename, userownames = FALSE, sep = ",")  
    ## write.tre : function (x, location, filename, userownames = FALSE, sep = ",")  
    ## write.ts.prm : function (location, filename, matchout = TRUE)

## Main functions

### rtreescan

-   `makeSignaltree`: Specifies the color of significant nodes in the
    entire tree structure created by `maketree()` function

-   `maketree`: Creates a ‘data.tree’ structure using hierarchical
    information from the entered tree file

-   `tbss`: Calls out into the OS to run TreeScan software, without the
    parameter file specified

-   `treescan`: Calls out into the OS to run TreeScan software, with the
    parameter file specified

-   `ts.option`: Set or reset parameters to be used by TreeScan

-   `ts_data`: A function that converts data to return a tree structure
    and a count data structure

-   `write.cas`: Write a TreeScan cas (case) file

-   `write.tre`: Write a TreeScan tre (tree) file

-   `write.ts.prm`: Write a TreeScan prm (parameter) file

## Example data : The Korea Adverse Event Reporting System (KAERS)

KAERS is a system developed by KIDS to facilitate reporting and
management of adverse event (AE) reports. All reports of AEs have been
accumulated in KAERS since 2012.

Anyone who experiences AEs can report to KIDS using KAERS; Consumers,
Healthcare Professionals(HCPs), Regional Pharmacovigilance center
(RPVCs) and Marketing Authorization Holders (MAHs), who are mostly
pharmaceutical companies.

### 1. Tree Scan Statistic, Poisson Model

Poisson model is used for modeling count data, such as number of births,
number of disease occurrences, and so on. Each row contains the number
of cases and population on a node. </br>

The population size for the specified node. </br>

-   For the conditional Poisson model this could be raw population
    numbers. for the unconditional Poisson model is used, it must be the
    expected counts. In a conditional poisson model, the probability of
    incidence of adverse events in specific drugs can be obtained by
    using observed data.</br>

-   In an unconditional poisson model, the probability of incidence of
    adverse events in specific drugs can be obtained by using external
    information about the true probabilities underlying the null
    hypothesis.</br>

| Count File Format | Tree File Format |
|:-----------------:|:----------------:|
|      nodeID       |      nodeID      |
|    \# of cases    |  parentalNodeID  |
| \# of population  |        \-        |
