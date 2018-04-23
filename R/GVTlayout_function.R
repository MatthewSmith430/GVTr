#' @title GVT layout
#'
#' @description Creates a matrix with tree layout for basic igraph plot
#' @param g The GVT graph
#' @export
#' @return Tree layout matrix

GVTlayout<-function(g){
  GVT2<-switchEdge(g)
  GVT2<-as.data.frame(GVT2)
  GVT3<-igraph::graph.data.frame(GVT2)
  igraph::E(GVT3)$weight<-GVT2$weight
  lo<-igraph::layout.reingold.tilford(GVT3,mode='out')
  rownames(lo)<-igraph::V(GVT3)$name

  lo2<-as.data.frame(lo)
  lo2$name<-rownames(lo2)
  target<-igraph::V(g)$name
  lo3<-lo2[match(target,lo2$name),]
  lo3$name<-NULL
  lo3<-as.matrix(lo3)
  return(lo3)
}
