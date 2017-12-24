#' @title Global Value Tree Prune Plot
#'
#' @description This the Global Value Tree (GVT) network
#' @param GVT The GVT network object extracted with \code{GVTprune(root)} command
#' @param LAB Should the plot have labels - TRUE/FALSE
#' @export
#' @return Global Value Tree Plot
#' @references Zhu Z, Puliga M, Cerina F, Chessa A, Riccaboni M (2015) Global Value Trees. PLoS ONE 10(5): e0126699. https://doi.org/10.1371/journal.pone.0126699

GVTplot<-function(GVT,LAB){
  V(GVT)$id<-V(GVT)$name
   NAMElist<-V(GVT)$id
  countryLIST<-list()
  industryLIST<-list()
  for (i in 1:length(NAMElist)){
    R<-NAMElist[i]
    RB<-strsplit(R,".",fixed=TRUE)
    RB<-unlist(RB)
    countryLIST[[i]]<-RB[1]
    industryLIST[[i]]<-RB[2]
  }
  dfCOUNTRY<-ldply(countryLIST, data.frame)
  colnames(dfCOUNTRY)<-"CountryCode"
  CountryAttr<-as.factor(dfCOUNTRY$CountryCode)
  V(GVT)$country<-CountryAttr

  dfindustry<-ldply(industryLIST,data.frame)
  colnames(dfindustry)<-"IndustryCode"
  IndustryAttr<-as.factor(dfindustry$IndustryCode)
  V(GVT)$industry<-IndustryAttr
  gvtNET<-intergraph::asNetwork(GVT)
  HC<-as.character(CountryAttr)
  if (LAB==TRUE){
    GGally::ggnet2(gvtNET,
                   node.size=8,node.color = HC,color.palette = "Set1",
                   color.legend = "Country",label = TRUE,label.size = 3.5,
                   edge.color = c("color", "grey50"),arrow.size =12 )
  } else{
    GGally::ggnet2(gvtNET,
                   node.size=8,node.color = HC,color.palette = "Set1",
                   color.legend = "Country",
                   edge.color = c("color", "grey50"),arrow.size =12 )
  }


}
