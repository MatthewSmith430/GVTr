
#' @title GVT Plot Standard
#'
#' @description This creates a standard igraph GVT plot
#' @param g GVT igraph object
#' @param COL Node colour - by country or industry
#' @export
#' @return igraph GVT plot

gvtBasePlot<-function(g,COL){
  lo3<-GVTlayout
  NAMElist<-igraph::V(g)$id
  countryLIST<-list()
  industryLIST<-list()
  for (i in 1:length(NAMElist)){
    R<-NAMElist[i]
    RB<-strsplit(R,".",fixed=TRUE)
    RB<-unlist(RB)
    countryLIST[[i]]<-RB[1]
    industryLIST[[i]]<-RB[2]
  }
  dfCOUNTRY<-plyr::ldply(countryLIST, data.frame)
  colnames(dfCOUNTRY)<-"CountryCode"
  CountryAttr<-as.factor(dfCOUNTRY$CountryCode)
  igraph::V(g)$country<-CountryAttr

  dfindustry<-plyr::ldply(industryLIST,data.frame)
  colnames(dfindustry)<-"IndustryCode"
  IndustryAttr<-as.factor(dfindustry$IndustryCode)
  igraph::V(g)$industry<-IndustryAttr
  if (COL=="country"){
    igraph::plot.igraph(g,vertex.label=NA,vertex.size=5,edge.arrow.size=.1,edge.width=1.7,
         layout=lo3,vertex.color=igraph::V(g)$country)
  } else if (COL=="industry"){
    igraph::plot.igraph(g,vertex.label=NA,vertex.size=5,edge.arrow.size=.1,edge.width=1.7,
         layout=lo3,vertex.color=igraph::V(g)$industry)
  } else {
    igraph::plot.igraph(g,vertex.label=NA,vertex.size=5,edge.arrow.size=.1,edge.width=1.7,
         layout=lo3,vertex.color=igraph::V(g)$country)
  }
}



