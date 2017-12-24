#' @title GVT layout
#'
#' @description Creates a matrix with tree layout for basic igraph plot
#' @param g The GVT graph
#' @export
#' @return Tree layout matrix

GVTlayout<-function(g){
  GVT2<-switchEdge(g)
  GVT2<-as.data.frame(GVT2)
  GVT3<-graph.data.frame(GVT2)
  E(GVT3)$weight<-GVT2$weight
  lo<-layout.reingold.tilford(GVT3,mode='out')
  rownames(lo)<-V(GVT3)$name

  lo2<-as.data.frame(lo)
  lo2$name<-rownames(lo2)
  target<-V(g)$name
  lo3<-lo2[match(target,lo2$name),]
  lo3$name<-NULL
  lo3<-as.matrix(lo3)
  return(lo3)
}
