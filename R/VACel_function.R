#' @title Creating value added contribution edgelist
#'
#' @description This creates a value added contribution edgelist from the raw wiot data
#' @param wiot The WIOT data loaded with \code{data(wiotyear)} command
#' @export
#' @return Weighted Edgelist Dataframe
#' #' @references Zhu Z, Puliga M, Cerina F, Chessa A, Riccaboni M (2015) Global Value Trees. PLoS ONE 10(5): e0126699. https://doi.org/10.1371/journal.pone.0126699
VACel<-function(wiot){
  industry<-wiot$IndustryCode
  industry<-unique(industry)
  industry<-as.vector(industry)
  industry<-industry[1:56]
  industries<-as.character(industry)

  country<-wiot$Country
  country<-unique(country)
  country<-country[country != "TOT"]
  countries<-as.character(country)

  WI<-as.matrix(wiot)
  inter<-WI[1:2464,6:2469]
  final<-WI[1:2464,2470:2689]
  inter<-as.matrix(inter)
  final<-as.matrix(final)
  inter2 <- mapply(inter, FUN=as.numeric)
  inter2<-matrix(inter2,nrow = 2464,ncol = 2464)

  final2 <- mapply(final, FUN=as.numeric)
  final2<-matrix(final2,nrow = 2464,ncol = 2464)

  output<-WI[1:2464,2690]
  output<-as.integer(output)
  va<-WI[2470,6:2469]
  va<-as.integer(va)

  G<-decompr::decomp(x = inter2,
              y = final2,
              k=countries,
              i=industries,
              o= output,
              method = "leontief",post="none",long=FALSE)
  G<-as.matrix(G)
  G[is.na(G)]=0
  diag(G)<-0

  WEL<- igraph::graph.adjacency(G,weighted=TRUE)
  WEL2<-igraph::get.edgelist(WEL)
  WEL2<-as.data.frame(WEL2)
  WEL2$weight<-E(WEL)$weight
  return(WEL2)

}


