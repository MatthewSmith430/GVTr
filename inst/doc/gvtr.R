## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----packages,eval=FALSE-------------------------------------------------
#  library(igraph)
#  library(dplyr)
#  library(plyr)
#  library(ggplot2)
#  library(GGally)
#  library(intergraph)
#  library(sna)
#  library(decompr)
#  
#  #Install this package:
#  #library(devtools)
#  #devtools::install_github("MatthewSmith430/GVTr")
#  library(GVTr)

## ----data,eval=FALSE-----------------------------------------------------
#  data("wiot2000")

## ----VAC,eval=FALSE------------------------------------------------------
#  EL<-VACel(wiot2000) #Value added contribution edgelist
#  NET<-VACnet(wiot2000) #Value added contribution network
#  MAT<-VACmat(wiot2000) #Value added contribution matrix

## ----TreePrune,eval=FALSE------------------------------------------------
#  #Example Root Node - USA Automotive Sector
#  USAauto<-GVTprune(wiot2000,0.019,"USA.C29",5)

## ----TreePlot,eval=TRUE,warning=FALSE,message=FALSE----------------------
library(GVTr)
library(igraph)
library(plyr)
##Load Data
data("wiot2000")

##Create Tree
USAauto<-GVTprune(wiot2000,0.019,"USA.C29",5)

##Create Plot
gvtBasePlot(USAauto,"country")

## ----TreePlotCOW,eval=TRUE,warning = FALSE,message=FALSE-----------------
library(GVTr)
library(igraph)
library(pryr)
##Load Data
data("wiot2000")
data("wiot2004")
data("wiot2008")

##Create Trees
USAauto2000<-GVTprune(wiot2000,0.019,"USA.C29",5)
USAauto2004<-GVTprune(wiot2004,0.019,"USA.C29",5)
USAauto2008<-GVTprune(wiot2008,0.019,"USA.C29",5)

##Create & save plots using gvtBasePlot & pryr
p1 %<a-% {
  gvtBasePlot(USAauto2000,"country")
}

p2 %<a-% {
  gvtBasePlot(USAauto2004,"country")
}
p3 %<a-% {
  gvtBasePlot(USAauto2008,"country")
}

##Plot GVTs
split.screen(c(1, 3))
screen(1)
p1
screen(2)
p2
screen(3)
p3
close.screen(all=TRUE) 

## ----BasePlot,eval=TRUE,warning = FALSE,message=FALSE--------------------
library(GVTr)
library(ggplot2)
library(GGally)
##Load Data
data("wiot2000")

##Create Tree
USAauto<-GVTprune(wiot2000,0.019,"USA.C29",5)

##Create Plot
GVTplot(USAauto,FALSE)

## ----netD3,eval=TRUE,warning = FALSE,message=FALSE-----------------------
library(GVTr)
library(networkD3)
library(data.tree)
library(igraph)
##Load Data
data("wiot2008")

##Create Tree
USAauto<-GVTprune(wiot2008,0.019,"USA.C29",5)

##Use data.tree to process the data into a hierarchical 
##list that can be ploted with networkD3
GVTdf<-get.data.frame(USAauto) ##Get data frame from igraph objecy
tree1 <- FromDataFrameNetwork(GVTdf) 
tree2 <- ToListExplicit(tree1, unname = TRUE) ##identify root node of tree

###The following commands with produce html visualisations

##Diagonal Plot
diagonalNetwork(tree2,nodeColour = "red")

##Radial Plot
radialNetwork(List = tree2, 
              nodeColour = "blue",
              fontSize = 6, opacity = 0.9)

