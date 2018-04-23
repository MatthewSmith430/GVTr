#' @title Edge Switch
#'
#' @description Switches the edges so that tree layout can be calcuated
#' @param g graph object
#' @export
#' @return graph object with edges switched

switchEdge<-function(g){
  e<-igraph::get.data.frame(g,what="edges")
  neworder<-1:length(e)
  neworder[1:2]<-c(2,1)
  e<-e[neworder]
  names(e)<-names(e)[neworder]
  #igraph::graph.data.frame(e, vertices=igraph::get.data.frame(g,what="vertices"))
  e$Weight<-NULL
  return(e)
}
