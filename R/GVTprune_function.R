#' @title Global Value Tree Prune
#'
#' @description This creates a Global Value Tree (GVT) igraph network from the raw wiot data for a specific root country-industry node, with threshold and number of layers specified.
#' @param wiot The WIOT data loaded with \code{data(wiotyear)} command
#' @param threshold threshold cutoff for the GVT
#' @param root root node for the GVT
#' @param layer_max number of layers specified
#' @export
#' @return Global Value Tree Network Object
#' @references Zhu Z, Puliga M, Cerina F, Chessa A, Riccaboni M (2015) Global Value Trees. PLoS ONE 10(5): e0126699. https://doi.org/10.1371/journal.pone.0126699

GVTprune<-function(wiot,threshold,root,layer_max){
  gstart<-VACnet(wiot)
  gstart2 <- igraph::delete.edges(gstart, which(igraph::E(gstart)$weight < threshold))
  tree<-igraph::make_ego_graph(gstart2, nodes = root, order=layer_max,mode="in")
  tree2<-tree[[1]]
  G1<-igraph::delete_edges(tree2,igraph::incident(tree2,root,"out"))
  igraph::V(G1)$id<-igraph::V(G1)$name
  NAMES<-igraph::V(G1)$name
  DIS<-igraph::distances(G1,mode="in",algorithm = "unweighted")
  colnames(DIS)<-NAMES
  rownames(DIS)<-NAMES
  LAY1<-DIS[root,]
  igraph::V(G1)$LAYER<-LAY1
  ged<-list()
  for (i in 1:max(LAY1)){
    g2<- igraph::subgraph.edges(G1, igraph::E(G1)[inc(igraph::V(G1)[LAYER==i])])
    g3 <-igraph::delete.vertices(g2, igraph::V(g2)[ igraph::V(g2)[LAYER!=i] ])
    ged[[i]]<- igraph::get.edgelist(g3)
  }
  RRed<-do.call(rbind, ged)
  H<-as.list(RRed[,1])
  H1a<-as.character(H)
  H2<-as.list(RRed[,2])
  H2a<-as.character(H2)
  CHlist<-list()
  for (i in 1:length(H1a)){
    R1<-H1a[i]
    R2<-H2a[i]
    CHlist[[i]]<-paste0(R1,"|",R2)
  }
  CH2<-as.character(CHlist)
  Hgraph<-igraph::delete.edges(G1,CH2)
  N1<-Hgraph
  NAMESHgraph<-igraph::V(Hgraph)$name
  DISHgraph<-igraph::distances(Hgraph,mode="in",algorithm = "unweighted")
  colnames(DISHgraph)<-NAMESHgraph
  rownames(DISHgraph)<-NAMESHgraph
  LAY1Hgraph<-DISHgraph[root,]
  igraph::V(Hgraph)$LAYER<-LAY1Hgraph
  Lout<-list()
  for (i in 1:max(LAY1Hgraph)){
    g3b <-igraph::delete.vertices(Hgraph, igraph::V(Hgraph)[ igraph::V(Hgraph)[LAYER<i] ])
    R<-igraph::get.vertex.attribute(Hgraph,"name",igraph::V(Hgraph)$LAYER==i)
    L1<-list()
    for (z in 1:length(R)){
      g3b<-igraph::delete_edges(g3b,igraph::incident(g3b,R[z],"out"))
      H<-igraph::make_ego_graph(g3b,order= 1, nodes = R[z], mode = "in")
      Q<-H[[1]]
      TR<-as.data.frame(igraph::get.edgelist(Q))
      TRval<-as.data.frame(igraph::E(Q)$weight)
      EDGEtest<-cbind(TR,TRval)
      colnames(EDGEtest)<-c("V1","V2","Weight")
      L1[[z]]<-EDGEtest
    }
    Lout[[i]]<-L1
  }
  Ldf<-do.call(rbind, Lout)
  Ldf<-do.call(rbind, Ldf)
  net<-igraph::make_ego_graph(N1, nodes = root, order=1,mode="in")
  net2<-net[[1]]

  EGOroot<-as.data.frame(igraph::get.edgelist(net2))
  EGOrootWeight<-as.data.frame(igraph::E(net2)$weight)
  EGOrootFRAME<-cbind(EGOroot,EGOrootWeight)
  colnames(EGOrootFRAME)<-c("V1","V2","Weight")

  TESTdf<-rbind(EGOrootFRAME,Ldf)

  GFINAL<-igraph::graph_from_data_frame(TESTdf,direct=TRUE)
  igraph::E(GFINAL)$weight<-TESTdf$Weight
  igraph::V(GFINAL)$id<-igraph::V(GFINAL)$name
  GFINAL<-igraph::simplify(GFINAL,remove.multiple = TRUE,remove.loops = TRUE)
  return(GFINAL)

}
