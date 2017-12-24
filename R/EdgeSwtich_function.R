#' @title Edge Switch
#'
#' @description Switches the edges so that tree layout can be calcuated
#' @param g graph object
#' @export
#' @return graph object with edges switched

switchEdge<-function(g){
  e<-get.data.frame(g,what="edges")
  neworder<-1:length(e)
  neworder[1:2]<-c(2,1)
  e<-e[neworder]
  names(e)<-names(e)[neworder]
  graph.data.frame(e, vertices=get.data.frame(g,what="vertices"))
  e$Weight<-NULL
  return(e)
}
