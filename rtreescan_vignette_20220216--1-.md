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

## Installation

    devtools::install_github("sjheo91/rtreescan")

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

The case and control population data for each leaf node as shown below
*(Count file: Poiscas)*.

``` r
head(Poiscas)
```

    ##   nodeID cases population
    ## 1  Leaf1     1        200
    ## 2  Leaf2     2        300
    ## 3  Leaf3     0        400
    ## 4  Leaf4     6        200
    ## 5  Leaf5     4        300
    ## 6  Leaf6     2        200

**If you don’t have count and tree file, you can make these files by
using ‘ts_data()’ function.**

#### 1.1 Unconditional Poisson model

``` r
ts.1 <- ts_data(data=vaccine_samp2, AE_code="WHOART2lv", drug_code="DRUG_CHEM", 
                case = "influenza, inactivated, split virus or surface antigen", 
                control = NULL, lv_sep="_", model=0, condition=0, rate = 0.5)

head(cas.1 <-ts.1$Count)
```

    ##    NodeID Cases Expectation
    ## 1 0100_14     0         0.5
    ## 2 0100_24     1         1.5
    ## 3 0100_27     1         0.5
    ## 4 0100_28     1         0.5
    ## 5 0100_37     0         0.5
    ## 6 0100_49     0         0.5

``` r
head(tre.1 <-ts.1$Tree)
```

    ##    NodeID ParentID
    ## 1 0100_14     0100
    ## 2 0100_24     0100
    ## 3 0100_27     0100
    ## 4 0100_28     0100
    ## 5 0100_37     0100
    ## 6 0100_49     0100

In
`ts_data(data, AE_code, drug_code, case, control, lv_sep, model, condition, rate, match_vars, N, Start, End)`,
enter the variable name with drug_code in the drug_code option. </br>

-   For the poisson model, enter a case drug code in the case option,
    ‘NULL’ in the control option, ‘0’ in the model option.</br>

-   For the Unconditional Poisson model, enter ‘0’ in the condition
    option </br>

More information on options is available on appendix section.<br/>

**Using `tbss()`, users can easily perform analysis without creating
parameter files themselves.**

**Run tbss function If parameter file is not available, Run tbss
function as shown below.**

``` r
tbss(location = loc, filename = "UCPoisson", cas = cas.1, tre = tre.1, model = 0, conditional = 0)
```

**If a parameter file is available, set the prmstatus options to ‘y’.**

``` r
tbss(prmstatus = "y", location = loc, filename = "UCPoisson")
```

In
`tbss(location, filename, cas, tre, scan, model, conditional, csv, html)`,
enter the path for the TreeScan-readable files(.cas, .tre), parameter
file name, and options related to model setting and saving results.Enter
‘0’ in model option for the Poisson model, and enter ‘0’ in conditional
option for Unconditional poisson model. </br>

More information on options is available on appendix section.<br/>

**The result can also be seen in R if the option “results-csv”=“y” is
set in the parameter file. **

``` r
result.1 <- tbss(prmstatus = "y", location = loc, filename = "UCPoisson")
result.1$csv
```

    ##   Cut.No. Node.Identifier Tree.Level Observed.Cases Expected Relative.Risk
    ## 1       1         1820_57          3              4      2.5           1.6
    ##   Excess.Cases Log.Likelihood.Ratio P.value Parent.Node Branch.Order
    ## 1          1.5             0.380015   0.991        1820            1

**To visualize the results**, pre-create the entire tree structure using
`maketree()`. Then you can also use the `makeSignaltree()` to create a
tree structure in which the signals are captured.

``` r
entiretree.1 <- maketree(ts.1$Tree)
plot(entiretree.1)
```

{% include plot/example1.1.1.html %}

``` r
signaltree.1 <- makeSignaltree1(result.1, ts.1$Tree,fillcolor = "lightgrey", signalcolor = "brown")
signaltree.1
```

{% include plot/example1.1.1.html %}

#### 1.2 Conditional Poisson model

``` r
ts.2 <- ts_data(data=vaccine_samp2, AE_code="WHOART2lv", drug_code="DRUG_CHEM", 
                    case = "influenza, inactivated, split virus or surface antigen", 
                    control = NULL, lv_sep="_", model=0, condition=1, rate = 0.5)

head(ts.2$Count)
```

    ##    NodeID Cases Population
    ## 1 0100_14     0          1
    ## 2 0100_24     1          3
    ## 3 0100_27     1          1
    ## 4 0100_28     1          1
    ## 5 0100_37     0          1
    ## 6 0100_49     0          1

``` r
head(ts.2$Tree)
```

    ##    NodeID ParentID
    ## 1 0100_14     0100
    ## 2 0100_24     0100
    ## 3 0100_27     0100
    ## 4 0100_28     0100
    ## 5 0100_37     0100
    ## 6 0100_49     0100

In
`ts_data(data, AE_code, drug_code, case, control, lv_sep, model, condition, rate, match_vars, N, Start, End)`,
enter the variable name with durg_code in the durg_code option. </br> -
For the poisson model, enter a case drug code in the case option, ‘NULL’
in the control option, ‘0’ in the model option.</br> - For the
Conditional Poisson model, enter ‘1’ in the condition option. </br>

More information on options is available on appendix section.<br/>

**Using `tbss()`, users can easily perform analysis without creating
parameter files themselves.**

**Run tbss function If parameter file is not available, Run tbss
function as shown below.**

``` r
tbss(location = loc, filename = 'CPoisson', cas = ts.2$Count, tre = ts.2$Tree, model = 0, condition = 1)
```

**If a parameter file is available, set the prmstatus options to ‘y’.**

``` r
tbss(prmstatus = "y", location = loc, filename = "CPoisson")
```

In
`tbss(location, filename, cas, tre, scan, model, conditional, csv, html)`,
enter the path for the TreeScan-readable files(.cas, .tre), parameter
file name, and options related to model setting and saving results.
Enter ‘0’ in model option for the Poisson model, and enter ‘0’ in
conditional option for Unconditional poisson model. <br/>

More information on options is available on appendix section.<br/>

**The result can also be seen in R if the option “results-csv”=“y” is
set in the parameter file. **

``` r
result.2 <- tbss(prmstatus = "y", location = loc, filename = "CPoisson")
result.2$csv
```

    ##   Cut.No. Node.Identifier Tree.Level Observed.Cases Expected Relative.Risk
    ## 1       1         1820_57          3              4     1.70          2.77
    ## 2       2            1820          2              6     4.08          1.73
    ## 3     2_1         1820_57          3              4     1.70          2.77
    ## 4     2_2         1820_54          3              1     0.34          3.06
    ## 5     2_3         1820_58          3              1     0.68          1.50
    ##   Excess.Cases Log.Likelihood.Ratio P.value Parent.Node Branch.Order
    ## 1         2.56             1.304919   0.863        1820            2
    ## 2         2.53             0.544281   0.986        Root            1
    ## 3         2.56                   NA      NA        1820           NA
    ## 4         0.67                   NA      NA        1820           NA
    ## 5         0.33                   NA      NA        1820           NA

**To visualize the results**, pre-create the entire tree structure using
`maketree()`. Then you can also use the `makeSignaltree()` to create a
tree structure in which the signals are captured.

``` r
entiretree.2 <- maketree(ts.2$Tree)
plot(entiretree.2)
```

<div id="htmlwidget-e7d8c45eb652815eee9d" style="width:672px;height:480px;" class="grViz html-widget"></div>
<script type="application/json" data-for="htmlwidget-e7d8c45eb652815eee9d">{"x":{"diagram":"digraph {\n\ngraph [rankdir = \"TB\"]\n\n\n\n  \"1\" [label = \"Root\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: Root\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"2\" [label = \"0100\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0100\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"3\" [label = \"0100_14\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0100_14\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"4\" [label = \"0100_24\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0100_24\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"5\" [label = \"0100_27\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0100_27\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"6\" [label = \"0100_28\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0100_28\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"7\" [label = \"0100_37\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0100_37\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"8\" [label = \"0100_49\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0100_49\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"9\" [label = \"0200\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0200\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"10\" [label = \"0200_73\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0200_73\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"11\" [label = \"0410\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0410\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"12\" [label = \"0410_109\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0410_109\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"13\" [label = \"0431\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0431\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"14\" [label = \"0431_241\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0431_241\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"15\" [label = \"0500\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0500\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"16\" [label = \"0500_1185\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0500_1185\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"17\" [label = \"0600\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0600\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"18\" [label = \"0600_1393\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0600_1393\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"19\" [label = \"0600_293\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0600_293\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"20\" [label = \"1100\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1100\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"21\" [label = \"1100_517\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1100_517\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"22\" [label = \"1100_539\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1100_539\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"23\" [label = \"1100_540\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1100_540\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"24\" [label = \"1100_543\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1100_543\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"25\" [label = \"1100_805\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1100_805\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"26\" [label = \"1220\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1220\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"27\" [label = \"1220_577\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1220_577\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"28\" [label = \"1810\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1810\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"29\" [label = \"1810_1705\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1810_1705\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"30\" [label = \"1810_223\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1810_223\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"31\" [label = \"1810_712\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1810_712\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"32\" [label = \"1810_724\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1810_724\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"33\" [label = \"1810_725\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1810_725\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"34\" [label = \"1810_730\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1810_730\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"35\" [label = \"1810_731\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1810_731\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"36\" [label = \"1820\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"37\" [label = \"1820_1880\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820_1880\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"38\" [label = \"1820_1881\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820_1881\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"39\" [label = \"1820_54\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820_54\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"40\" [label = \"1820_57\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820_57\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"41\" [label = \"1820_58\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820_58\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"42\" [label = \"1830\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1830\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"43\" [label = \"1830_862\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1830_862\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n\"1\"->\"2\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"9\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"11\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"13\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"15\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"17\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"20\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"26\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"28\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"36\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"42\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"2\"->\"3\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"2\"->\"4\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"2\"->\"5\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"2\"->\"6\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"2\"->\"7\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"2\"->\"8\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"9\"->\"10\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"11\"->\"12\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"13\"->\"14\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"15\"->\"16\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"17\"->\"18\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"17\"->\"19\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"20\"->\"21\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"20\"->\"22\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"20\"->\"23\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"20\"->\"24\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"20\"->\"25\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"26\"->\"27\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"28\"->\"29\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"28\"->\"30\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"28\"->\"31\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"28\"->\"32\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"28\"->\"33\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"28\"->\"34\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"28\"->\"35\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"36\"->\"37\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"36\"->\"38\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"36\"->\"39\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"36\"->\"40\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"36\"->\"41\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"42\"->\"43\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n}","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script>

``` r
signaltree.2 <- makeSignaltree1(result.2, ts.2$Tree,fillcolor = "lightgrey", signalcolor = "brown")
```

    ## Warning: 패키지 'collapsibleTree'는 R 버전 4.1.3에서 작성되었습니다

``` r
signaltree.2
```

<div id="htmlwidget-27d518f03c4e91d3e734" style="width:672px;height:480px;" class="collapsibleTree html-widget"></div>
<script type="application/json" data-for="htmlwidget-27d518f03c4e91d3e734">{"x":{"data":{"name":"Root","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"0100","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"0100_14","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"0100_24","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"0100_27","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"0100_28","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"0100_37","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"0100_49","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]},{"name":"0200","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"0200_73","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]},{"name":"0410","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"0410_109","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]},{"name":"0431","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"0431_241","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]},{"name":"0500","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"0500_1185","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]},{"name":"0600","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"0600_1393","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"0600_293","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]},{"name":"1100","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"1100_517","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"1100_539","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"1100_540","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"1100_543","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"1100_805","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]},{"name":"1220","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"1220_577","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]},{"name":"1810","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"1810_1705","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"1810_223","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"1810_712","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"1810_724","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"1810_725","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"1810_730","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"1810_731","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]},{"name":"1820","fill":"brown","WeightOfNode":"0.863","children":[{"name":"1820_1880","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"1820_1881","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"1820_54","fill":"brown"},{"name":"1820_57","fill":"brown"},{"name":"1820_58","fill":"brown"}]},{"name":"1830","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"1830_862","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]}]},"options":{"hierarchy":[1,2,3],"input":null,"attribute":"P.value","linkLength":null,"fontSize":10,"tooltip":true,"collapsed":false,"zoomable":true,"margin":{"top":20,"bottom":20,"left":45,"right":70}}},"evals":[],"jsHooks":[]}</script>

If the only signal option is set to **FALSE**, it shows the entire tree
where the signal is captured, and if set to **TRUE**, it only shows
where the signal is captured (default = FALSE). Users can also set the
desired p-value level using the pv option. In this example, the p-value
level is set to 0.1.</br></br>

### 2. Bernoulli tree-based scan statistic

Bernoulli model is used for binary data, including disease status,
exposure status, etc. Each row contains the number of cases and controls
on a node.

The number of observed cases and controls for the specified node. Must
be a non-negative integer. </br>

| Count File Format | Tree File Format |
|:-----------------:|:----------------:|
|      nodeID       |      nodeID      |
|    \# of cases    |  parentalNodeID  |
| \# of population  |        \-        |

The case and population data for each leaf node as shown below (count
file: Berncas).

``` r
head(Berncas)
```

    ##   nodeID cases controls
    ## 1  Leaf1     1        2
    ## 2  Leaf2     2        3
    ## 3  Leaf3     0        4
    ## 4  Leaf4     6        2
    ## 5  Leaf5     4        3
    ## 6  Leaf6     2        2

|             Model             | Self-control design | Save |
|:-----------------------------:|:-------------------:|:----:|
| Unconditional Bernoulli model |         Yes         | csv  |
|  Conditional Bernoulli model  |         No          | csv  |

**If you don’t have count and tree file, you can make these files by
using ‘ts_data()’ function.**

#### 2.1 Unconditional Bernoulli model

``` r
ts.3 <- ts_data(data = vaccine_samp_2, AE_code="WHOART2lv", drug_code="DRUG_CHEM", case = "pneumococcus, purified polysaccharides antigen conjugated", control = 'pneumococcus, purified polysaccharides antigen', lv_sep="_", model=1, condition=0, match_vars = c('AGE_RANGE', 'PTNT_SEX'), N = 1)

head(ts.3$Count)
```

    ##      NodeID Cases Controls
    ## 1   0200_73     8        4
    ## 2  0410_138     0        4
    ## 3  0431_241     4        0
    ## 4 0600_1351     0        4
    ## 5  0600_308     0       12
    ## 6  1810_716     4        0

``` r
head(ts.3$Tree)
```

    ##      NodeID ParentID
    ## 1   0200_73     0200
    ## 2  0410_138     0410
    ## 3  0431_241     0431
    ## 4 0600_1351     0600
    ## 5  0600_308     0600
    ## 6  1810_716     1810

In
`ts_data(data, AE_code, drug_code, case, control, lv_sep, model, condition, rate, match_vars, N, Start, End)`,
enter the variable name with durg_code in the durg_code option. </br> -
For the Bernoulli model, enter a case drug code in the case option, a
control drug code in the control option, ‘1’ in the model option.</br> -
For the Unconditional Bernoulli model, enter ‘0’ in the condition
option. </br>

For more information on options, see Appendix (in this document).<br/>

**Using `tbss()`, users can easily perform analysis without creating
parameter files themselves.**

**Run tbss function If parameter file is not available, Run tbss
function as shown below.**

``` r
tbss(location = loc, filename = "UCBernoulli", cas = ts.3$Count, tre = ts.3$Tree, model = 1, conditional = 0)
```

**If a parameter file is available, set the prmstatus options to ‘y’.**

``` r
tbss(prmstatus = "y", location = loc, filename = "UCBernoulli")
```

In
`tbss(location, filename, cas, tre, scan, model, conditional, csv, html)`,
enter the path for the TreeScan-readable files(.cas, .tre), parameter
file name, and options related to model setting and saving results.
Enter ‘1’ in model option for the Bernoulli model, and enter ‘0’ in
conditional option for the Unconditional Bernoulli model. <br/>

For more information on options, see Appendix (in this document) or
TreeScan guideline.<br/>

**The result can also be seen in R if the option “results-csv”=“y” is
set in the parameter file. **

``` r
result.3 <- tbss(prmstatus = "y", location = loc, filename = "UCBernoulli")
head(result.3$csv)
```

    ##   Cut.No. Node.Identifier Tree.Level Observations Cases Expected Relative.Risk
    ## 1       1       1820_1881          3           20    20       10             2
    ## 2       2       1820_1880          3            8     8        4             2
    ## 3       3         1820_57          3            4     4        2             2
    ## 4       4       1820_1910          3            4     4        2             2
    ## 5       5        1810_730          3            4     4        2             2
    ## 6       6        1810_716          3            4     4        2             2
    ##   Excess.Cases Log.Likelihood.Ratio P.value Parent.Node Branch.Order
    ## 1           10            13.862944   0.001        1820           10
    ## 2            4             5.545177   0.008        1820            9
    ## 3            2             2.772589   0.428        1820           12
    ## 4            2             2.772589   0.428        1820           11
    ## 5            2             2.772589   0.428        1810            7
    ## 6            2             2.772589   0.428        1810            6

**To visualize the results**, pre-create the entire tree structure using
`maketree()`. Then you can also use the `makeSignaltree()` to create a
tree structure in which the signals are captured.

``` r
entiretree.3<- maketree(ts.3$Tree)
plot(entiretree.3)
```

<div id="htmlwidget-321aaca6dda635604f01" style="width:672px;height:480px;" class="grViz html-widget"></div>
<script type="application/json" data-for="htmlwidget-321aaca6dda635604f01">{"x":{"diagram":"digraph {\n\ngraph [rankdir = \"TB\"]\n\n\n\n  \"1\" [label = \"Root\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: Root\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"2\" [label = \"0200\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0200\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"3\" [label = \"0200_73\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0200_73\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"4\" [label = \"0410\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0410\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"5\" [label = \"0410_138\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0410_138\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"6\" [label = \"0431\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0431\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"7\" [label = \"0431_241\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0431_241\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"8\" [label = \"0600\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0600\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"9\" [label = \"0600_1351\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0600_1351\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"10\" [label = \"0600_308\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0600_308\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"11\" [label = \"1810\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1810\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"12\" [label = \"1810_716\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1810_716\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"13\" [label = \"1810_725\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1810_725\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"14\" [label = \"1810_730\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1810_730\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"15\" [label = \"1820\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"16\" [label = \"1820_1372\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820_1372\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"17\" [label = \"1820_1880\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820_1880\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"18\" [label = \"1820_1881\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820_1881\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"19\" [label = \"1820_1910\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820_1910\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"20\" [label = \"1820_57\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820_57\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"21\" [label = \"1820_58\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820_58\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"22\" [label = \"1830\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1830\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"23\" [label = \"1830_736\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1830_736\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n\"1\"->\"2\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"4\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"6\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"8\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"11\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"15\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"22\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"2\"->\"3\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"4\"->\"5\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"6\"->\"7\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"8\"->\"9\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"8\"->\"10\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"11\"->\"12\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"11\"->\"13\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"11\"->\"14\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"15\"->\"16\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"15\"->\"17\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"15\"->\"18\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"15\"->\"19\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"15\"->\"20\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"15\"->\"21\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"22\"->\"23\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n}","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script>

``` r
signaltree.3 <- makeSignaltree1(result.3, ts.3$Tree, fillcolor = "lightgrey", signalcolor = "brown")
signaltree.3
```

<div id="htmlwidget-a3034b40ec238a190574" style="width:672px;height:480px;" class="collapsibleTree html-widget"></div>
<script type="application/json" data-for="htmlwidget-a3034b40ec238a190574">{"x":{"data":{"name":"Root","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"0200","fill":"brown","WeightOfNode":"0.808","children":[{"name":"0200_73","fill":"brown","WeightOfNode":"0.001"}]},{"name":"0410","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"0410_138","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]},{"name":"0431","fill":"brown","WeightOfNode":"0.994","children":[{"name":"0431_241","fill":"brown","WeightOfNode":"0.428"}]},{"name":"0600","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"0600_1351","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"0600_308","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]},{"name":"1810","fill":"brown","children":[{"name":"1810_716","fill":"brown","WeightOfNode":"0.428"},{"name":"1810_725","fill":"brown","WeightOfNode":"0.428"},{"name":"1810_730","fill":"brown","WeightOfNode":"0.428"}]},{"name":"1820","fill":"brown","children":[{"name":"1820_1372","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"1820_1880","fill":"brown","WeightOfNode":"0.604"},{"name":"1820_1881","fill":"brown"},{"name":"1820_1910","fill":"brown"},{"name":"1820_57","fill":"brown"},{"name":"1820_58","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]},{"name":"1830","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"1830_736","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]}]},"options":{"hierarchy":[1,2,3],"input":null,"attribute":"P.value","linkLength":null,"fontSize":10,"tooltip":true,"collapsed":false,"zoomable":true,"margin":{"top":20,"bottom":20,"left":45,"right":70}}},"evals":[],"jsHooks":[]}</script>

``` r
onlysignaltree.3 <- makeSignaltree(result.3, ts.3$Tree, pv = 0.01, onlysignal = TRUE,fillcolor = "lightgrey",  signalcolor = "brown") 
plot(onlysignaltree.3)
```

<div id="htmlwidget-60b21eb64ad9b1ae66a6" style="width:672px;height:480px;" class="grViz html-widget"></div>
<script type="application/json" data-for="htmlwidget-60b21eb64ad9b1ae66a6">{"x":{"diagram":"digraph {\n\ngraph [rankdir = \"TB\"]\n\n\n\n  \"1\" [label = \"Root\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: Root\", penwidth = \"1\", fillcolor = \"#A52A2A\", fontcolor = \"#FFFFFF\"] \n  \"2\" [label = \"1820\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820\", penwidth = \"1\", fillcolor = \"#A52A2A\", fontcolor = \"#FFFFFF\"] \n  \"3\" [label = \"1820_1881\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- LLR: 13.862944\n- Pvalue: 0.001\n- RR: 2.00\n- signalNode: 1820_1881\", penwidth = \"1\", fillcolor = \"#A52A2A\", fontcolor = \"#FFFFFF\"] \n  \"4\" [label = \"1820_1880\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- LLR: 5.545177\n- Pvalue: 0.008\n- RR: 2.00\n- signalNode: 1820_1880\", penwidth = \"1\", fillcolor = \"#A52A2A\", fontcolor = \"#FFFFFF\"] \n\"1\"->\"2\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"2\"->\"3\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"2\"->\"4\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n}","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script>

If the only signal option is set to **FALSE**, it shows the entire tree
where the signal is captured, and if set to **TRUE**, it only shows
where the signal is captured (default = FALSE). Users can also set the
desired p-value level using the pv option. In this example, the p-value
level is set to 0.01.</br></br>

#### 2.2 Conditional Bernoulli

``` r
ts.4 <- ts_data(data = vaccine_samp_2, AE_code="WHOART2lv", drug_code="DRUG_CHEM", case = "pneumococcus, purified polysaccharides antigen conjugated", control = 'pneumococcus, purified polysaccharides antigen',  lv_sep="_", model=1, condition=1)
head(ts.4$Count)
```

    ##      NodeID Cases Controls
    ## 1   0100_24     1        0
    ## 2   0200_73     2        1
    ## 3  0410_109     1        0
    ## 4  0410_138     0        1
    ## 5 0410_1877     1        0
    ## 6   0410_93     1        0

``` r
head(ts.4$Tree)
```

    ##      NodeID ParentID
    ## 1   0100_24     0100
    ## 2   0200_73     0200
    ## 3  0410_109     0410
    ## 4  0410_138     0410
    ## 5 0410_1877     0410
    ## 6   0410_93     0410

In
`ts_data(data, AE_code, drug_code, case, control, lv_sep, model, condition, rate, match_vars, N, Start, End)`,
enter the variable name with durg_code in the durg_code option. </br> -
For the Bernoulli model, enter a case drug code in the case option, a
control drug code in the control option, ‘1’ in the model option.

-   For the Conditional Bernoulli model, enter ‘1’ in the condition
    option.

More information on options is available on appendix section.</br>

**Using `tbss()`, users can easily perform analysis without creating
parameter files themselves.**

**Run tbss function If parameter file is not available, Run tbss
function as shown below.**

``` r
tbss(location = loc, filename = 'CBernoulli', cas = ts.4$Count, tre = ts.4$Tree, model = 1, condition = 1)
```

**If a parameter file is available, set the prmstatus options to ‘y’.**

``` r
tbss(prmstatus = "y", location = loc, filename = "CBernoulli")
```

In
`tbss(location, filename, cas, tre, scan, model, conditional, csv, html)`,
enter the path for the TreeScan-readable files(.cas, .tre), parameter
file name, and options related to model setting and saving results.
Enter ‘1’ in model option for the Bernoulli model, and enter ‘1’ in
conditional option for the Conditional Bernoulli model. <br/>

For more information on options, see Appendix (in this document) or
TreeScan guideline.<br/>

**The result can also be seen in R if the option “results-csv”=“y” is
set in the parameter file. **

``` r
result.4 <- tbss(prmstatus = "y", location = loc, filename = "CBernoulli")
result.4$csv
```

    ##    Cut.No. Node.Identifier Tree.Level Observations Cases Expected Relative.Risk
    ## 1        1       1820_1881          3            5     5     3.62          1.50
    ## 2        2       1820_1880          3            2     2     1.45          1.42
    ## 3        3            1820          2           11     9     7.97          1.23
    ## 4      3_1       1820_1881          3            5     5     3.62          1.50
    ## 5      3_2       1820_1880          3            2     2     1.45          1.42
    ## 6      3_3       1820_1910          3            1     1     0.72          1.40
    ## 7      3_4         1820_57          3            1     1     0.72          1.40
    ## 8        4            1810          2            5     4     3.62          1.13
    ## 9      4_1        1810_716          3            1     1     0.72          1.40
    ## 10     4_2        1810_730          3            1     1     0.72          1.40
    ## 11     4_3        1810_725          3            3     2     2.17          0.91
    ##    Excess.Cases Log.Likelihood.Ratio P.value Parent.Node Branch.Order
    ## 1          1.67            1.8047360   0.298        1820            4
    ## 2          0.59            0.6733530   0.977        1820            3
    ## 3          1.67            0.4082880   0.985        Root            2
    ## 4          1.67                   NA      NA        1820           NA
    ## 5          0.59                   NA      NA        1820           NA
    ## 6          0.29                   NA      NA        1820           NA
    ## 7          0.29                   NA      NA        1820           NA
    ## 8          0.46            0.0917694   0.998        Root            1
    ## 9          0.29                   NA      NA        1810           NA
    ## 10         0.29                   NA      NA        1810           NA
    ## 11        -0.19                   NA      NA        1810           NA

**To visualize the results**, pre-create the entire tree structure using
`maketree()`. Then you can also use the `makeSignaltree()` to create a
tree structure in which the signals are captured.

``` r
entiretree.4 <- maketree(ts.4$Tree)
plot(entiretree.4)
```

<div id="htmlwidget-2152759034c5deb53631" style="width:672px;height:480px;" class="grViz html-widget"></div>
<script type="application/json" data-for="htmlwidget-2152759034c5deb53631">{"x":{"diagram":"digraph {\n\ngraph [rankdir = \"TB\"]\n\n\n\n  \"1\" [label = \"Root\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: Root\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"2\" [label = \"0100\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0100\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"3\" [label = \"0100_24\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0100_24\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"4\" [label = \"0200\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0200\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"5\" [label = \"0200_73\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0200_73\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"6\" [label = \"0410\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0410\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"7\" [label = \"0410_109\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0410_109\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"8\" [label = \"0410_138\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0410_138\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"9\" [label = \"0410_1877\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0410_1877\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"10\" [label = \"0410_93\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0410_93\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"11\" [label = \"0431\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0431\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"12\" [label = \"0431_241\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0431_241\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"13\" [label = \"0600\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0600\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"14\" [label = \"0600_1351\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0600_1351\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"15\" [label = \"0600_308\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 0600_308\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"16\" [label = \"1100\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1100\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"17\" [label = \"1100_543\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1100_543\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"18\" [label = \"1810\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1810\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"19\" [label = \"1810_716\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1810_716\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"20\" [label = \"1810_725\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1810_725\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"21\" [label = \"1810_730\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1810_730\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"22\" [label = \"1820\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"23\" [label = \"1820_1372\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820_1372\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"24\" [label = \"1820_1880\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820_1880\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"25\" [label = \"1820_1881\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820_1881\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"26\" [label = \"1820_1910\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820_1910\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"27\" [label = \"1820_57\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820_57\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"28\" [label = \"1820_58\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820_58\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"29\" [label = \"1830\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1830\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n  \"30\" [label = \"1830_736\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1830_736\", fillcolor = \"#D3D3D3\", fontcolor = \"#000000\"] \n\"1\"->\"2\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"4\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"6\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"11\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"13\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"16\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"18\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"22\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"1\"->\"29\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"2\"->\"3\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"4\"->\"5\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"6\"->\"7\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"6\"->\"8\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"6\"->\"9\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"6\"->\"10\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"11\"->\"12\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"13\"->\"14\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"13\"->\"15\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"16\"->\"17\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"18\"->\"19\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"18\"->\"20\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"18\"->\"21\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"22\"->\"23\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"22\"->\"24\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"22\"->\"25\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"22\"->\"26\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"22\"->\"27\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"22\"->\"28\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"29\"->\"30\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n}","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script>

``` r
signaltree.4 <- makeSignaltree1(result.4, ts.4$Tree, fillcolor = "lightgrey", signalcolor = "brown")
signaltree.4
```

<div id="htmlwidget-ca4cbafa121a739168c7" style="width:672px;height:480px;" class="collapsibleTree html-widget"></div>
<script type="application/json" data-for="htmlwidget-ca4cbafa121a739168c7">{"x":{"data":{"name":"Root","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"0100","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"0100_24","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]},{"name":"0200","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"0200_73","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]},{"name":"0410","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"0410_109","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"0410_138","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"0410_1877","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"0410_93","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]},{"name":"0431","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"0431_241","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]},{"name":"0600","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"0600_1351","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"0600_308","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]},{"name":"1100","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"1100_543","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]},{"name":"1810","fill":"brown","children":[{"name":"1810_716","fill":"brown"},{"name":"1810_725","fill":"brown","WeightOfNode":"0.298"},{"name":"1810_730","fill":"brown","WeightOfNode":"0.977"}]},{"name":"1820","fill":"brown","children":[{"name":"1820_1372","fill":"lightgrey","WeightOfNode":"No cut reported for node."},{"name":"1820_1880","fill":"brown"},{"name":"1820_1881","fill":"brown"},{"name":"1820_1910","fill":"brown"},{"name":"1820_57","fill":"brown"},{"name":"1820_58","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]},{"name":"1830","fill":"lightgrey","WeightOfNode":"No cut reported for node.","children":[{"name":"1830_736","fill":"lightgrey","WeightOfNode":"No cut reported for node."}]}]},"options":{"hierarchy":[1,2,3],"input":null,"attribute":"P.value","linkLength":null,"fontSize":10,"tooltip":true,"collapsed":false,"zoomable":true,"margin":{"top":20,"bottom":20,"left":45,"right":70}}},"evals":[],"jsHooks":[]}</script>

``` r
onlySignalTree1.4 <- makeSignaltree(result.4, ts.4$Tree, pv = 0.6,onlysignal = TRUE, fillcolor = "lightgrey", signalcolor = "brown")
plot(onlySignalTree1.4)
```

<div id="htmlwidget-b41de71d567784f30e88" style="width:672px;height:480px;" class="grViz html-widget"></div>
<script type="application/json" data-for="htmlwidget-b41de71d567784f30e88">{"x":{"diagram":"digraph {\n\ngraph [rankdir = \"TB\"]\n\n\n\n  \"1\" [label = \"Root\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: Root\", penwidth = \"1\", fillcolor = \"#A52A2A\", fontcolor = \"#FFFFFF\"] \n  \"2\" [label = \"1820\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- name: 1820\", penwidth = \"1\", fillcolor = \"#A52A2A\", fontcolor = \"#FFFFFF\"] \n  \"3\" [label = \"1820_1881\", style = \"filled, rounded\", shape = \"box\", fontname = \"helvetica\", tooltip = \"- LLR: 1.804736\n- Pvalue: 0.298\n- RR: 1.50\n- signalNode: 1820_1881\", penwidth = \"1\", fillcolor = \"#A52A2A\", fontcolor = \"#FFFFFF\"] \n\"1\"->\"2\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n\"2\"->\"3\" [arrowhead = \"vee\", color = \"black\", penwidth = \"1\"] \n}","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script>

If the only signal option is set to **FALSE**, it shows the entire tree
where the signal is captured, and if set to **TRUE**, it only shows
where the signal is captured (default = FALSE). Users can also set the
desired p-value level using the pv option. In this example, the p-value
level is set to 0.6.</br></br>

### 3. Tree Temporal scan statistic

Tree-Temporal Scan Statistics identifies how cases are distributed over
time in a tree. (To be more specific, the tree-temporal scan statistic
is a fusion of the standard tree-based scan statistics and the temporal
scan statistic.) It is commonly used in vaccine studies where
vaccination times are precisely defined. </br> Each row contains the
number of cases and the time of cases on a node.</br>

|                  Model                   | Time Study period (Start, End range) |   Save    |
|:----------------------------------------:|:------------------------------------:|:---------:|
| Conditional tree-temporal scan statistic |      1 \~ 28 (1 \~ 14, 1 \~ 21)      | csv, html |

| Count File Format | Tree File Format |
|:-----------------:|:----------------:|
|      nodeID       |      nodeID      |
|    \# of cases    |  parentalNodeID  |
| \# time of cases  |        \-        |

The case and time of cases data for each leaf node as shown below
*(Count file: TreeTemporal.cas)*.

``` r
head(TreeTempcas)
```

    ##   nodeID cases timeOfcases
    ## 1  Leaf1     1           6
    ## 2  Leaf1     1          16
    ## 3  Leaf1     1          23
    ## 4  Leaf2     2           7
    ## 5  Leaf2     1          24
    ## 6  Leaf2     1          25

**If you don’t have count and tree file, you can make these files using
‘ts_data()’ function.**

#### 3.1 Tree-temporal model

In
`ts_data(data, AE_code, drug_code, case, control, lv_sep, model, condition, rate, match_vars, N, Start, End)`,
enter the variable name with durg_code in the durg_code option.

-   For the Tree Temporal model, enter a case drug code in the case
    option, ‘NULL’ in the control option, ‘2’ in the model option.

More information on options is available on appendix section.<br/>

**Using `tbss()`, users can easily perform analysis without creating
parameter files themselves.** Run tbss function If parameter file is not
available, Run tbss function as shown below.

**If a parameter file is available, set the prmstatus options to ‘y’.**

In
`tbss(location, filename, cas, tre, scan, model, conditional, csv, html)`,
enter the path for the TreeScan-readable files(.cas, .tre), parameter
file name, and options related to model setting and saving results.</br>
For more information on options, see Appendix 1 (in this document) or
TreeScan guideline.<br/>

**The result can also be seen in R if the option “results-csv”=“y” is
set in the parameter file. **

**To visualize the results**, pre-create the entire tree structure using
`maketree()`. Then you can also use the `makeSignaltree()` to create a
tree structure in which the signals are captured.

If the only signal option is set to **FALSE**, it shows the entire tree
where the signal is captured, and if set to **TRUE**, it only shows
where the signal is captured (default = FALSE). Users can also set the
desired p-value level using the pv option. In this example, the p-value
level is set to 0.1.</br></br>

## Appendix

### **‘ts_data()’** </br> </br>

Category of arguments in `ts_data()` function </br> If you don’t have
count and tree file, you can make these files using ‘ts_data()’
function. </br>

**\[Arguments\]**

-   data: data frame in which to interpret the variables named in the
    AE_code, drug_code, case, and control arguments and so on.

-   AE_code: AE_code should include two or more hierarchical levels of
    adverse events. For example, if you use WHO-ART and have 2 levels,
    it can be expressed in the form of “SOC_PT”.

-   drug_code: If a Bernoulli model is selected, drug_code must include
    case and control drug. Also, if a Poisson model is selected,
    drug_code must include case drug and other drugs and if a
    Tree-temporal model is selected, drug_code must include case drug.

-   case: case name

-   control: If a Bernoulli model is selected, case represents the case
    name. But if a Poisson model or Tree-temporal model is selected,
    control must be “NULL”.

-   lv_sep: It represents a pattern symbol that distinguishes between an
    upper level and a lower level in the AE_code. For example, if data
    is input in the form of “SOC_PT”, lv_sep=“\_“.

-   model: Interger for probability model type (POISSON=0, BERNOULLI=1,
    TREE-TEMPORAL=2)

-   condition: conditional type (UNCONDITIONAL=0, TOTALCASES=1)

-   rate: the expected probability for unconditional type

-   match_vars: variables that wants to match

-   N: matching ratio

-   Start: start data time range (window-start-range)

-   End: end data time range (window-end-range)

### **‘tbss()’** </br> </br>

Category of arguments in `tbss` fucntion </br>

**\[Input\]**

-   prmstatus: value indicating the existence of a parameter file
    (default: 0)

-   location: path with a .prm file (if prmstatus = 1) or path with .cas
    and .tre files (if prmstatus = 0)

-   filename: parameter file name (if prmstatus = 1)

-   cas: count data file name

-   tre: tree structure file name

**\[Analysis\]**

-   scan: scan type (TREEONLY=0, TREETIME=1, TIMEONLY=2)

-   model: probability model type (POISSON=0, BERNOULLI=1, UNIFORM=2,
    Not-Applicable=3)

-   conditional: conditional type (UNCONDITIONAL=0, TOTALCASES=1,
    NODE=2, NODEANDTIME=3)

-   self: self control design - unconditional Bernoulli only (y/n)

-   prob: case probability (default: 1/2)

-   start: start data time range (window-start-range)

-   end: end data time range (window-end-range)

-   period: data time range

**\[Output\]**

-   filename: results file name (if prmstatus = 0)

-   csv/html/llr: create CSV/HTML/LLR results (y/n)
