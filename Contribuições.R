#################################################################################################################
#GECON
#ÁREA:CRÉDITO
#PLANILHA ABERTURA DAS CONTRIBUIÇÕES DE CRÉDITO
#FELIPE SIMPLÍCIO FERREIRA
#DATA:18-06-2018
#################################################################################################################

#PACOTES REQUERIDOS:
#INSTALAR QUANDO NECESSÁRIO
#EXEMPLO:install.packages("pryr")
library(xlsx)
library(RCurl)
library(XML)

#DEFINIR PASTAS DE RESULTADOS:
getwd()
setwd("//SRJN3/area_corporativa/Projeto GAP-DIMAC/Automatizações/Contribuições")

#ATUALIZAR DATA (alinhar com primeiro mes dos dados)
data1="01/03/2011"
data2="31/12/2018"
data3="2018.12"

#1)Pessoas Jurídicas - Recursos livres
serie=c(20544,20545,20546,20547,20548,20549,20551,20552,20553,20554,20556,20557,20559,20560,20561,20562,20563,20565,20566,20567,20568,20569,20543)


vec_ind1=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[1],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind2=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[2],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind3=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[3],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind4=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[4],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind5=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[5],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind6=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[6],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind7=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[7],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind8=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[8],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind9=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[9],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind10=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[10],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind11=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[11],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind12=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[12],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind13=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[13],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind14=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[14],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind15=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[15],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind16=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[16],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind17=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[17],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind18=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[18],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind19=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[19],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind20=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[20],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind21=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[21],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind22=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[22],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind23=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[23],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")

base=cbind(vec_ind1,vec_ind2[,2],vec_ind3[,2],vec_ind4[,2],vec_ind5[,2], vec_ind6[,2], vec_ind7[,2], vec_ind8[,2], vec_ind9[,2], vec_ind10[,2],vec_ind11[,2],vec_ind12[,2],vec_ind13[,2], vec_ind14[,2], vec_ind15[,2], vec_ind16[,2], vec_ind17[,2], vec_ind18[,2],vec_ind19[,2], vec_ind20[,2], vec_ind21[,2], vec_ind22[,2], vec_ind23[,2])
rm(list=objects(pattern="vec_ind[0-23]"))

#Deflacionando séries com IPCA
base[,-1]=apply(base[,-1],2,function(x)as.numeric(gsub("\\.","",x)))
url_ipea="http://www.ipeadata.gov.br/ExibeSerie.aspx?serid=36482"
ipea.table = readHTMLTable(htmlParse(getURL(url_ipea, useragent="curl/7.39.0 Rcurl/1.95.4.5")), header=T, which=3,stringsAsFactors=F)
deflator= ipea.table[which(ipea.table$V1=="2011.03"):which(ipea.table$V1==data3),]
deflator=as.numeric(gsub(",","\\.",gsub("\\.","",deflator[,2])))

base=cbind(base,deflator)
base=cbind(base[1],apply(base[,2:24],2,function(x) x*(tail(deflator,1)/deflator)))

# Cálculo da contribuicao:
# A função apply irá aplicar a função em cada coluna da base[,-1] (em cada série do bcb)
variacao=apply(base[,-1],2,function(x){
  variacao_YoY=rep(NA,12)
  for(i in 13:dim(base)[1]) variacao_YoY[i]=(x[i]/x[i-12])-1
  return(variacao_YoY)
})

peso=apply(base[,-1],2,function(x){
  peso=rep(NA,12)
  for(i in 13:dim(base)[1]) peso[i]=(x[i-12]/base$`vec_ind23[, 2]`[i-12])
  return(peso)
})

contribuicao = (peso*variacao)

base=cbind(base,contribuicao)
base=base[,c(1,2,25,3,26,4,27,5,28,6,29,7,30,8,31,9,32,10,33,11,34,12,35,13,36,14,37,15,38,16,39,17,40,18,41,19,42,20,43,21,44,22,45,23,46,24,47)]

names(base)=c("Data", "Saldo (em R$ milhões) - Pessoas jurídicas - Desconto de duplicatas e recebíveis - 20544", "20544 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas jurídicas - Desconto de cheques- 20545", "20545 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas jurídicas - Antecipação de faturas de cartão de crédito - 20546", "20546 - Contribuição para a variação total",  
              "Saldo (em R$ milhões) - Pessoas jurídicas - Capital de giro com prazo de até 365 dias - 20547", "20547 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas jurídicas - Capital de giro com prazo superior a 365 dias - 20548", "20548 - Contribuição para a variação total",  
              "Saldo (em R$ milhões) - Pessoas jurídicas - Capital de giro rotativo - 20549", "20549 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas jurídicas - Conta garantida - 20551", "20551 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas jurídicas - Cheque especial - 20552", "20552 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas jurídicas - Aquisição de veículos - 20553", "20553 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas jurídicas - Aquisição de outros bens - 20554", "20554 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas jurídicas - Arrendamento mercantil de veículos - 20556", "20556 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas jurídicas - Arrendamento mercantil de outros bens - 20557", "20557 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas jurídicas - Vendor - 20559", "20559 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas jurídicas - Compror - 20560", "20560 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas jurídicas - Cartão de crédito rotativo - 20561", "20561 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas jurídicas - Cartão de crédito parcelado - 20562", "20562 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas jurídicas - Cartão de crédito à vista - 20563", "20563 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas jurídicas - Adiantamento sobre contratos de câmbio (ACC) - 20565", "20565 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas jurídicas - Financiamento a importações - 20566", "20566 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas jurídicas - Financiamento a exportações - 20567", "20567 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas jurídicas - Repasse externo - 20568", "20568 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas jurídicas - Outros créditos livres - 20569", "20569 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas jurídicas - Total - 20543", "20543 - Contribuição para a variação total")


write.xlsx(base,"01 - Contribuicoes pessoa juridica recursos livres (em R$ milhões).xlsx", row.names = F)

#2)Pessoas Físicas - Recursos livres
serie=c(20573,20574,20575,20576,20577,20578,20581,20582,20584,20585,20587,20588,20589,20591,20592,20570)

vec_ind1=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[1],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind2=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[2],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind3=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[3],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind4=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[4],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind5=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[5],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind6=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[6],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind7=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[7],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind8=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[8],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind9=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[9],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind10=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[10],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind11=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[11],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind12=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[12],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind13=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[13],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind14=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[14],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind15=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[15],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind16=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[16],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")

base2=cbind(vec_ind1,vec_ind2[,2],vec_ind3[,2],vec_ind4[,2],vec_ind5[,2], vec_ind6[,2], vec_ind7[,2], vec_ind8[,2], vec_ind9[,2], vec_ind10[,2],vec_ind11[,2],vec_ind12[,2],vec_ind13[,2], vec_ind14[,2], vec_ind15[,2], vec_ind16[,2])
rm(list=objects(pattern="vec_ind[0-16]"))

#Deflacionando séries com IPCA
base2[,-1]=apply(base2[,-1],2,function(x)as.numeric(gsub("\\.","",x)))
url_ipea="http://www.ipeadata.gov.br/ExibeSerie.aspx?serid=36482"
ipea.table = readHTMLTable(htmlParse(getURL(url_ipea, useragent="curl/7.39.0 Rcurl/1.95.4.5")), header=T, which=3,stringsAsFactors=F)
deflator= ipea.table[which(ipea.table$V1=="2011.03"):which(ipea.table$V1==data3),]
deflator=as.numeric(gsub(",","\\.",gsub("\\.","",deflator[,2])))

base2=cbind(base2,deflator)
base2=cbind(base2[1],apply(base2[,2:17],2,function(x) x*(tail(deflator,1)/deflator)))

# Cálculo da contribuicao:
# A função apply irá aplicar a função em cada coluna da base[,-1] (em cada série do bcb)
variacao=apply(base2[,-1],2,function(x){
  variacao_YoY=rep(NA,12)
  for(i in 13:dim(base2)[1]) variacao_YoY[i]=(x[i]/x[i-12])-1
  return(variacao_YoY)
})

peso=apply(base2[,-1],2,function(x){
  peso=rep(NA,12)
  for(i in 13:dim(base2)[1]) peso[i]=(x[i-12]/base2$`vec_ind16[, 2]`[i-12])
  return(peso)
})

contribuicao = (peso*variacao)

base2=cbind(base2,contribuicao)
base2=base2[,c(1,2,18,3,19,4,20,5,21,6,22,7,23,8,24,9,25,10,26,11,27,12,28,13,29,14,30,15,31,16,32,17,33)]

names(base2)=c("Data", "Saldo (em R$ milhões) - Pessoas físicas - Cheque especial - 20573", "20573 - Contribuição para a variação total",  
              "Saldo (em R$ milhões) - Pessoas físicas - Crédito pessoal não consignado - 20574", "20574 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas físicas - Crédito pessoal não consignado vinculado à composição de dívidas - 20575", "20575 - Contribuição para a variação total",  
              "Saldo (em R$ milhões) - Pessoas físicas - Crédito pessoal consignado para trabalhadores do setor privado - 20576", "20576 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas físicas - Crédito pessoal consignado para trabalhadores do setor público - 20577", "20577 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas físicas - Crédito pessoal consignado para aposentados e pensionistas do INSS - 20578", "20578 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas físicas - Aquisição de veículos - 20581", "20581 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas físicas - Aquisição de outros bens - 20582", "20582 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas físicas - Arrendamento mercantil de veículos - 20584", "20584 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas físicas - Arrendamento mercantil de outros bens - 20585", "20585 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas físicas - Cartão de crédito rotativo - 20587", "20587 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas físicas - Cartão de crédito parcelado - 20588", "20588 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas físicas - Cartão de crédito à vista - 20589", "20589 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas físicas - Desconto de cheques - 20591", "20591 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) - Pessoas físicas - Outros créditos livres - 20592", "20592 - Contribuição para a variação total", 
              "Saldo (em R$ milhões) da carteira de crédito com recursos livres - Pessoas físicas - Total - 20570", "20570 - Contribuição para a variação total")


write.xlsx(base2,"02 - Contribuicoes pessoa fisica recursos livres (em R$ milhões).xlsx", row.names = F)

#3)Pessoas Jurídicas - Recursos direcionados
serie=c(20595,20596,20598,20599,20601,20602,20603,20605,20594)

vec_ind1=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[1],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind2=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[2],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind3=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[3],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind4=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[4],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind5=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[5],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind6=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[6],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind7=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[7],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind8=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[8],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind9=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[9],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")

base3=cbind(vec_ind1,vec_ind2[,2],vec_ind3[,2],vec_ind4[,2],vec_ind5[,2], vec_ind6[,2], vec_ind7[,2], vec_ind8[,2], vec_ind9[,2])
rm(list=objects(pattern="vec_ind[0-9]"))

#Deflacionando séries com IPCA
base3[,-1]=apply(base3[,-1],2,function(x)as.numeric(gsub("\\.","",x)))
url_ipea="http://www.ipeadata.gov.br/ExibeSerie.aspx?serid=36482"
ipea.table = readHTMLTable(htmlParse(getURL(url_ipea, useragent="curl/7.39.0 Rcurl/1.95.4.5")), header=T, which=3,stringsAsFactors=F)
deflator= ipea.table[which(ipea.table$V1=="2011.03"):which(ipea.table$V1==data3),]
deflator=as.numeric(gsub(",","\\.",gsub("\\.","",deflator[,2])))

base3=cbind(base3,deflator)
base3=cbind(base3[1],apply(base3[,2:10],2,function(x) x*(tail(deflator,1)/deflator)))

# Cálculo da contribuicao:
# A função apply irá aplicar a função em cada coluna da base[,-1] (em cada série do bcb)
variacao=apply(base3[,-1],2,function(x){
  variacao_YoY=rep(NA,12)
  for(i in 13:dim(base3)[1]) variacao_YoY[i]=(x[i]/x[i-12])-1
  return(variacao_YoY)
})

peso=apply(base3[,-1],2,function(x){
  peso=rep(NA,12)
  for(i in 13:dim(base3)[1]) peso[i]=(x[i-12]/base3$`vec_ind9[, 2]`[i-12])
  return(peso)
})

contribuicao = (peso*variacao)

base3=cbind(base3,contribuicao)
base3=base3[,c(1,2,11,3,12,4,13,5,14,6,15,7,16,8,17,9,18,10,19)]

names(base3)=c("Data", "Saldo (em R$ milhões) - Pessoas jurídicas - Crédito rural com taxas de mercado - 20595", "20595 - Contribuição para a variação total", 
               "Saldo (em R$ milhões) - Pessoas jurídicas - Crédito rural com taxas reguladas - 20596", "20596 - Contribuição para a variação total", 
               "Saldo (em R$ milhões) - Pessoas jurídicas - Financiamento imobiliário com taxas de mercado - 20598", "20598 - Contribuição para a variação total",  
               "Saldo (em R$ milhões) - Pessoas jurídicas - Financiamento imobiliário com taxas reguladas - 20599", "20599 - Contribuição para a variação total", 
               "Saldo (em R$ milhões) - Pessoas jurídicas - Capital de giro com recursos do BNDES - 20601", "20601 - Contribuição para a variação total",  
               "Saldo (em R$ milhões) - Pessoas jurídicas - Financiamento de investimentos com recursos do BNDES - 20602", "20602 - Contribuição para a variação total", 
               "Saldo (em R$ milhões) - Pessoas jurídicas - Financiamento agroindustrial com recursos do BNDES - 20603", "20603 - Contribuição para a variação total", 
               "Saldo (em R$ milhões) - Pessoas jurídicas - Outros créditos direcionados - 20605", "20605 - Contribuição para a variação total", 
               "Saldo (em R$ milhões) - Pessoas jurídicas - Total - 20594", "20594 - Contribuição para a variação total")

write.xlsx(base3,"03 - Contribuicoes pessoa juridica recursos direcionados (em R$ milhões).xlsx", row.names = F)

#4)Pessoas Físicas - Recursos direcionados
serie=c(20607,20608,20610,20611,20613,20614,20615,20617,20618,20621,20606)

vec_ind1=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[1],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind2=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[2],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind3=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[3],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind4=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[4],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind5=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[5],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind6=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[6],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind7=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[7],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind8=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[8],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind9=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[9],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind10=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[10],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")
vec_ind11=read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[11],"/dados?formato=csv&dataInicial=",data1,"&dataFinal=",data2,sep="")),sep=";")

base4=cbind(vec_ind1,vec_ind2[,2],vec_ind3[,2],vec_ind4[,2],vec_ind5[,2], vec_ind6[,2], vec_ind7[,2], vec_ind8[,2], vec_ind9[,2], vec_ind10[,2], vec_ind11[,2])
rm(list=objects(pattern="vec_ind[0-11]"))

#Deflacionando séries com IPCA
base4[,-1]=apply(base4[,-1],2,function(x)as.numeric(gsub("\\.","",x)))
url_ipea="http://www.ipeadata.gov.br/ExibeSerie.aspx?serid=36482"
ipea.table = readHTMLTable(htmlParse(getURL(url_ipea, useragent="curl/7.39.0 Rcurl/1.95.4.5")), header=T, which=3,stringsAsFactors=F)
deflator= ipea.table[which(ipea.table$V1=="2011.03"):which(ipea.table$V1==data3),]
deflator=as.numeric(gsub(",","\\.",gsub("\\.","",deflator[,2])))

base4=cbind(base4,deflator)
base4=cbind(base4[1],apply(base4[,2:12],2,function(x) x*(tail(deflator,1)/deflator)))

# Cálculo da contribuicao:
# A função apply irá aplicar a função em cada coluna da base[,-1] (em cada série do bcb)
variacao=apply(base4[,-1],2,function(x){
  variacao_YoY=rep(NA,12)
  for(i in 13:dim(base4)[1]) variacao_YoY[i]=(x[i]/x[i-12])-1
  return(variacao_YoY)
})

peso=apply(base4[,-1],2,function(x){
  peso=rep(NA,12)
  for(i in 13:dim(base4)[1]) peso[i]=(x[i-12]/base4$`vec_ind11[, 2]`[i-12])
  return(peso)
})

contribuicao = (peso*variacao)

base4=cbind(base4,contribuicao)
base4=base4[,c(1,2,13,3,14,4,15,5,16,6,17,7,18,8,19,9,20,10,21,11,22,12,23)]

names(base4)=c("Data", " Saldo (R$ milhões) - Pessoas físicas - Crédito rural com taxas de mercado - 20607", "20607 - Contribuição para a variação total", 
               "Saldo (R$ milhões) - Pessoas físicas - Crédito rural com taxas reguladas - 20608", "20608 - Contribuição para a variação total", 
               "Saldo (R$ milhões) - Pessoas físicas - Financiamento imobiliário com taxas de mercado - 20610", "20610 - Contribuição para a variação total",  
               "Saldo (R$ milhões) - Pessoas físicas - Financiamento imobiliário com taxas reguladas - 20611", "20611 - Contribuição para a variação total", 
               "Saldo (R$ milhões) - Pessoas físicas - Capital de giro com recursos do BNDES - 20613", "20613 - Contribuição para a variação total",  
               "Saldo (R$ milhões) - Pessoas físicas - Financiamento de investimentos com recursos do BNDES - 20614", "20614 - Contribuição para a variação total", 
               "Saldo (R$ milhões) - Pessoas físicas - Financiamento agroindustrial com recursos do BNDES - 20615", "20615 - Contribuição para a variação total", 
               "Saldo (R$ milhões) - Pessoas físicas - Microcrédito destinado a consumo - 20617", "20617 - Contribuição para a variação total", 
               "Saldo (R$ milhões) - Pessoas físicas - Microcrédito destinado a microempreendedores - 20618", "20618 - Contribuição para a variação total",
               "Saldo (R$ milhões) - Pessoas físicas - Outros créditos direcionados - 20621", "20621 - Contribuição para a variação total", 
               "Saldo (R$ milhões) - Pessoas físicas - Total - 20606", "20606 - Contribuição para a variação total")


write.xlsx(base4,"04 - Contribuicoes pessoa fisica recursos direcionados (em R$ milhões).xlsx", row.names = F)