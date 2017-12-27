# GVTr - Global Value Trees in R
This package presents a set of functions to implement the Global Value Tree (GVT) analysis approach of world input-output data (WIOD) developed by:  
Zhu Z, Puliga M, Cerina F, Chessa A, Riccaboni M (2015) Global Value Trees. PLoS ONE 10(5): e0126699. <https://doi.org/10.1371/journal.pone.0126699>

The packagae allows you to:  
-Load WIOD data for 2000 - 2014  
-Create a value added contribution matrix/edgelist/network from the WIOD  
-Create a GVT for a root country-industry node  
-Plot GVT  

## Packages
This package uses a number of other packages.
```{r packages,eval=FALSE}
library(igraph)
library(dplyr)
library(plyr)
library(ggplot2)
library(GGally)
library(intergraph)
library(sna)
library(decompr)
#I would recommend installing decompr using:
#devtools::install_github("bquast/decompr")

#Install this package:
#library(devtools)
#devtools::install_github("MatthewSmith430/GVTr")
library(GVTr)
```

## Load Data
You can load the WIOD using the following:
```{r data,eval=FALSE}
data("wiot2000")
```
This load in the world-input output table, in the above example, this is loaded for the year 2000 (years 2000-2014 are currently available)

## Value Added Contribution matrix/edgelist/network
The following functions creates a value added contribution objects from the wiot data.
```{r VAC,eval=FALSE}
EL<-VACel(wiot2000) #Value added contribution edgelist
NET<-VACnet(wiot2000) #Value added contribution network
MAT<-VACmat(wiot2000) #Value added contribution matrix
```

## GVT - Tree Prune
This command creates a Global Value Tree (as an igraph object) for specific root country-industry node. In creating this GVT - we examine the ties incoming, directed towards the root node.  
The edge threshold is employed as the complete and unfiltered Global Value Network is almost completely connected, therefore an edge threshold aids in helping retain only the more important value added ties. This produces a tree that shows the upstream value system of the country-industry. We only have a function for the upstream value system in the first instance, as  upstream ties are noted to be more important for many manufacturing sectors, such as the automotive sector.  
For the `GVTprune` function, you need to specify the wiot data (that can be loaded using the package)edge threshold,root country-sector node, (see <http://www.wiod.org/release16> for data description and coverage details) and the maximum number of layers to be included in the GVT.  

```{r TreePrune,eval=FALSE}
#Example Root Node - USA Automotive Sector
USAauto<-GVTprune(wiot2000,0.019,"USA.C29",5)
```
## Plots
There are two plot options that come with this package.  
1.) Tree Plot - uses a tree layout to plot the GVT  
2.) Standard network layout  
### Tree Plot
In the tree plot, the nodes are coloured by country or industry. The root node is at the top of the tree. You need to specify the GVT (calculated using `GVTprune`) and what you want the colour to be country/industry.  
```{r TreePlot,eval=FALSE}
gvtBasePlot(USAauto,"country")
```

### Standard Plot
In this plot, the network takes a more typical layout (and not a tree layout). Node are coloured on the basis of country, and ties colour indicates whether links are intra or inter country. You need to specify the GVT (calculated using `GVTprune`) and whether labels are present (TRUE/FALSE).
```{r BasePlot,eval=FALSE}
GVTplot(USAauto,FALSE)
```

