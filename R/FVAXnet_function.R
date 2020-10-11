#' @title FVAX network
#'
#' @description This creates a value added contribution matrix from the raw wiot data
#' @param wiot The WIOT data loaded with \code{data(wiotyear)} command
#' @param loop TRUE to keep loop (country A to country A), FALSE to remove loops
#' @param ROW TRUE to keep ROW (Rest of World), FALSE to remove ROW
#' @param YEAR year
#' @export
#' @return Value added contribution matrix
#' @references Zhu Z, Puliga M, Cerina F, Chessa A, Riccaboni M (2015) Global Value Trees. PLoS ONE 10(5): e0126699. https://doi.org/10.1371/journal.pone.0126699
FVAXnet<-function(wiot,loop,ROW,YEAR){
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

  FVA1 <- decompr::decomp( x = inter2,
                y = final2,
                k = countries,
                i = industries,
                o = output,
                method = "leontief" )

  FVA2<-dplyr::as_tibble(FVA1)
  FVA2<-dplyr::select(FVA2,-c(Source_Industry,Using_Industry))

  if (loop==FALSE){
    FVA2<-dplyr::filter(FVA2,!Source_Country==Using_Country)
  }else{FVA2<-FVA2}

  FVA3<-dplyr::mutate(FVA2,
                      key=paste0(Source_Country,"_",Using_Country))

  FVA4<-aggregate(FVAX~key, sum, data=FVA3)

  FVA5<-tidyr::separate(FVA4,key,c("source","using"), "_")
  colnames(FVA5)[[3]]<-"weights"
  FVAgs<-igraph::graph_from_data_frame(d = FVA5,directed = TRUE)



  if (ROW==FALSE){
    FVAgs2<-igraph::delete_vertices(FVAgs, "ROW")
    VERT<-igraph::get.data.frame(FVAgs2,what="vertices")
    VERT<-dplyr::mutate(VERT,order=1:length(VERT$name))

    WDIDataSeries<-WDI::WDI_data
    WDICountryInfo<-WDIDataSeries$country
    WD<-as.data.frame(WDICountryInfo,stringsAsFactors = FALSE)

    COUNTRYlist<-WDICountryInfo[,"iso3c"]
    REGIONlist<-WDICountryInfo[,"region"]
    INCOMElist<-WDICountryInfo[,"income"]
    DATA<-dplyr::tibble(country=COUNTRYlist,
                        region=REGIONlist,
                        income=INCOMElist)

    WDIgdp1<-WDI::WDI(country="all",indicator = "NY.GDP.PCAP.KD", start = YEAR, end=YEAR )
    WDIgdp1<-as.data.frame(WDIgdp1,stringsAsFactors=FALSE)
    #WDIgdp1<-merge(WD,WDIgdp1,by="iso2c")
    WDIgdp1$iso3<-WD$iso3c[match(WDIgdp1$iso2c,WD$iso2c)]
    WDIgdp2<-cbind(as.vector(WDIgdp1$iso3),
                   as.vector(WDIgdp1$NY.GDP.PCAP.KD))
    colnames(WDIgdp2)<-c("iso3","GDP")
    WDIgdp2<-as.data.frame(WDIgdp2,stringsAsFactors=FALSE)

    WDIGDPgrowth1<-WDI::WDI(country="all",indicator = "NY.GDP.MKTP.KD.ZG", start = YEAR, end=YEAR )
    WDIGDPgrowth1<-as.data.frame(WDIGDPgrowth1,stringsAsFactors=FALSE)
    WDIGDPgrowth1$iso3<-WD$iso3c[match(WDIGDPgrowth1$iso2c,WD$iso2c)]
    WDIGDPgrowth2<-cbind(as.vector(WDIGDPgrowth1$iso3),
                         as.vector(WDIGDPgrowth1$NY.GDP.MKTP.KD.ZG))
    colnames(WDIGDPgrowth2)<-c("iso3","GDPgrowth")
    WDIGDPgrowth2<-as.data.frame(WDIGDPgrowth2,stringsAsFactors=FALSE)

    WDIGDPPC1<-WDI::WDI(country="all",indicator = "NY.GDP.PCAP.PP.KD", start = YEAR, end=YEAR )
    WDIGDPPC1<-as.data.frame(WDIGDPPC1,stringsAsFactors=FALSE)
    WDIGDPPC1$iso3<-WD$iso3c[match(WDIGDPPC1$iso2c,WD$iso2c)]
    WDIGDPPC2<-cbind(as.vector(WDIGDPPC1$iso3),as.vector(WDIGDPPC1$NY.GDP.PCAP.PP.KD))
    colnames(WDIGDPPC2)<-c("iso3","GDPPC")
    WDIGDPPC2<-as.data.frame(WDIGDPPC2,stringsAsFactors=FALSE)

    WDIFDI1<-WDI::WDI(country="all",indicator = "BN.KLT.DINV.CD", start = YEAR, end=YEAR )
    WDIFDI1<-as.data.frame(WDIFDI1,stringsAsFactors=FALSE)
    WDIFDI1$iso3<-WD$iso3c[match(WDIFDI1$iso2c,WD$iso2c)]
    WDIFDI2<-cbind(as.vector(WDIFDI1$iso3),as.vector(WDIFDI1$BN.KLT.DINV.CD))
    colnames(WDIFDI2)<-c("iso3","FDI")
    WDIFDI2<-as.data.frame(WDIFDI2,stringsAsFactors=FALSE)

    D1<-merge(DATA,WDIgdp2,by.x="country",by.y="iso3",all.x=FALSE,
              all.y = TRUE)
    D1$GDP<-as.numeric(D1$GDP)

    D2<-merge(D1,WDIGDPPC2,by.x="country",by.y="iso3")
    D2$GDPPC<-as.numeric(D2$GDPPC)

    D3<-merge(D2,WDIFDI2,by.x="country",by.y="iso3")
    D3$FDI<-as.numeric(D3$FDI)

    VERT2<-merge(VERT,D3,by.x="name",by.y="country",all.x=TRUE,
                 all.y=FALSE)

    VERT2<-dplyr::arrange(VERT2,order)

    VERT2$region[is.na(VERT2$region)]<-"East Asia & Pacific"
    VERT2$income[is.na(VERT2$income)]<-"Upper middle income"
    VERT2$GDP[is.na(VERT2$GDP)]<-mean(VERT2$GDP,na.rm = TRUE)
    VERT2$GDPPC[is.na(VERT2$GDPPC)]<-mean(VERT2$GDPPC,na.rm = TRUE)
    VERT2$FDI[is.na(VERT2$FDI)]<-mean(VERT2$FDI,na.rm = TRUE)

    igraph::V(FVAgs2)$regionNAME<-VERT2$region
    igraph::V(FVAgs2)$region<-as.numeric(as.factor(VERT2$region))
    igraph::V(FVAgs2)$incomeNAME<-VERT2$income
    igraph::V(FVAgs2)$income<-as.numeric(as.factor(VERT2$income))
    igraph::V(FVAgs2)$GDP<-VERT2$GDP
    igraph::V(FVAgs2)$GDPPC<-VERT2$GDPPC
    igraph::V(FVAgs2)$logGDP<-log(VERT2$GDP)
    igraph::V(FVAgs2)$logGDPPC<-log(VERT2$GDPPC)
    igraph::V(FVAgs2)$FDI<-VERT2$FDI

  }else{FVAgs2<-FVAgs}

  return(FVAgs2)
  }
