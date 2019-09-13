#################################################################################################################
#GECON
#ÁREA:CRÉDITO
#PLANILHA ABERTURA DAS CONTRIBUIÇÕES DE CONCESSÕES DE CRÉDITO
#FELIPE SIMPLÍCIO FERREIRA
#DATA:12-09-2019
#################################################################################################################

#PACOTES REQUERIDOS:
#INSTALAR QUANDO NECESSÁRIO
#EXEMPLO:install.packages("pryr")
#library(xlsx)
library(RCurl)
library(XML)

#DEFINIR PASTAS DE RESULTADOS:
getwd()
setwd("C:\\Users\\e270780232\\Documents")

#ATUALIZAR DATA (alinhar com primeiro mes dos dados)
datainicial="01/03/2011"
datafinal= format(Sys.time(), "%d/%m/%Y")

#1)Concessões com recursos livres - Pessoa Jurídica
serie=c(20636, 20637, 20638, 20639, 20640, 20641, 20643, 20644, 20645, 20646, 20648, 20649, 20651, 20652, 20653, 20654, 20655, 20657, 20658, 20659, 20660, 20661, 20635)

for (i in 1:length(serie)){
  dados = read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[i],"/dados?formato=csv&dataInicial=",datainicial,"&dataFinal=",datafinal,sep="")),sep=";")
  dados$data = as.Date(dados$data, "%d/%m/%Y")
  nome = paste("vec_ind", i, sep = "")
  assign(nome, dados)
  if(i==1)
    base = vec_ind1
  else
    base = merge(base, dados, by = "data", all = T)
}

rm(dados)
rm(list=objects(pattern="^vec_ind"))

#Deflacionando séries com IPCA
base[,-1]=apply(base[,-1],2,function(x)as.numeric(gsub("\\.","",x)))
url_ipea="http://www.ipeadata.gov.br/ExibeSerie.aspx?serid=36482"
ipea.table = readHTMLTable(htmlParse(getURL(url_ipea, useragent="curl/7.39.0 Rcurl/1.95.4.5")), header=T, which=3,stringsAsFactors=F)
ipea.table = ipea.table[-1:-4,-3]
names(ipea.table) = c("Data", "IPCA")
ipea.table = ipea.table[rowSums(is.na(ipea.table)) == 0,]
ipea.table = ipea.table[-dim(ipea.table)[1],]
ipea.table = ipea.table[-dim(ipea.table)[1],]
deflator = ipea.table[which(ipea.table$Data=="2011.03"):which(ipea.table$Data==format(as.Date(tail(base$data,1)),"%Y.%m")),]
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
  for(i in 13:dim(base)[1]) peso[i]=(x[i-12]/base$valor[i-12])
  return(peso)
})

contribuicao = (peso*variacao)

base=cbind(base,contribuicao)
base=base[,c(1,2,25,3,26,4,27,5,28,6,29,7,30,8,31,9,32,10,33,11,34,12,35,13,36,14,37,15,38,16,39,17,40,18,41,19,42,20,43,21,44,22,45,23,46,24,47)]

names(base)=c("Data", "Concessões - Pessoas jurídicas - Desconto de duplicatas e recebíveis - Recursos Livres -  20366", "20366 - Contribuição para a variação total",
              "Concessões - Pessoas jurídicas - Desconto de cheques - Recursos Livres - 20637", " 20637 - Contribuição para a variação total",
              "Concessões - Pessoas jurídicas - Antecipação de faturas de cartão de crédito - Recursos Livres - 20638", "20638 - Contribuição para a variação total",
              "Concessões - Pessoas jurídicas - Capital de giro com prazo de até 365 dias - Recursos Livres - 20639", "20639 - Contribuição para a variação total",
              "Concessões - Pessoas jurídicas - Capital de giro com prazo superior a 365 dias - Recursos Livres - 20640", "20640 -  Contribuição para a variação total",
              "Concessões - Pessoas jurídicas - Capital de giro rotativo - Recursos Livres - 20641", "20641 - Contribuição para a variação total",
              "Concessões - Pessoas jurídicas - Conta garantida - Recursos Livres - 20643", "20643 - Contribuição para a variação total",
              "Concessões - Pessoas jurídicas - Cheque especial - Recursos Livres - 20644", "20644 - Contribuição para a variação total",
              "Concessões - Pessoas jurídicas - Aquisição de veículos - Recursos Livres - 20645", " 20645 - Contribuição para a variação total",
              "Concessões - Pessoas jurídicas - Aquisição de outros bens - Recursos Livres - 20646", "20646 - Contribuição para a variação total",
              "Concessões - Pessoas jurídicas - Arrendamento mercantil de veículos - Recursos Livres - 20648", "20648 - Contribuição para a variação total",
              "Concessões - Pessoas jurídicas - Arrendamento mercantil de outros bens - Recursos Livres - 20649", "20649 - Contribuição para a variação total",
              "Concessões - Pessoas jurídicas - Vendor - Recursos Livres - 20651", "20651 - Contribuição para a variação total", 
              "Concessões - Pessoas jurídicas - Compror - Recursos Livres - 20652", "20652 - Contribuição para a variação total",
              "Concessões - Pessoas jurídicas - Cartão de crédito rotativo  - Recursos Livres - 20653", "20653 - Contribuição para a variação total", 
              "Concessões - Pessoas jurídicas - Cartão de crédito parcelado - Recursos Livres - 20654", "20654 - Contribuição para a variação total",
              "Concessões - Pessoas jurídicas - Cartão de crédito à vista - Recursos Livres - 20655", "20655 - Contribuição para a variação total",
              "Concessões - Pessoas jurídicas - Adiantamento sobre contratos de câmbio (ACC) - Recursos Livres - 20657", "20657 - Contribuição para a variação total",
              "Concessões - Pessoas jurídicas - Financiamento a importações - Recursos Livres - 20658", "20658 - Contribuição para a variação total",
              "Concessões - Pessoas jurídicas - Financiamento a exportações - Recursos Livres	- 20659", "20659 -Contribuição para a variação total",
              "Concessões - Pessoas jurídicas - Repasse externo - Recursos Livres - 20660", "20660 - Contribuição para a variação total",
              "Concessões - Pessoas jurídicas - Outros créditos livres - Recursos Livres - 20661", "20661 - Contribuição para a variação total",
              "Concessões - Pessoas jurídicas - Total	- Recursos livres - 20635", "20635 - Contribuição para a variação total")


write.csv2(base,"01 - Contribuicoes concessoes pessoa juridica recursos livres (em R$ milhões).csv", row.names = F)

#2)Concessões com recursos livres - Pessoa Física
serie=c(20665, 20666, 20667, 20668, 20669, 20670, 20673, 20674, 20676, 20677, 20679, 20680, 20681, 20683, 20684, 20662)

for (i in 1:length(serie)){
  dados = read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[i],"/dados?formato=csv&dataInicial=",datainicial,"&dataFinal=",datafinal,sep="")),sep=";")
  dados$data = as.Date(dados$data, "%d/%m/%Y")
  nome = paste("vec_ind", i, sep = "")
  assign(nome, dados)
  if(i==1)
    base2 = vec_ind1
  else
    base2 = merge(base2, dados, by = "data", all = T)
}

rm(dados)
rm(list=objects(pattern="^vec_ind"))

#Deflacionando séries com IPCA
base2[,-1]=apply(base2[,-1],2,function(x)as.numeric(gsub("\\.","",x)))
base2=cbind(base2,deflator)
base2=cbind(base2[1],apply(base2[,2:17],2,function(x) x*(tail(deflator,1)/deflator)))

# Cálculo da contribuicao:
# A função apply irá aplicar a função em cada coluna da base2[,-1] (em cada série do bcb)
variacao=apply(base2[,-1],2,function(x){
  variacao_YoY=rep(NA,12)
  for(i in 13:dim(base2)[1]) variacao_YoY[i]=(x[i]/x[i-12])-1
  return(variacao_YoY)
})

peso=apply(base2[,-1],2,function(x){
  peso=rep(NA,12)
  for(i in 13:dim(base2)[1]) peso[i]=(x[i-12]/base2$valor.y.7[i-12])
  return(peso)
})

contribuicao = (peso*variacao)

base2=cbind(base2,contribuicao)
base2=base2[,c(1,2,18,3,19,4,20,5,21,6,22,7,23,8,24,9,25,10,26,11,27,12,28,13,29,14,30,15,31,16,32,17,33)]

names(base2)=c("Data", "Concessões - Pessoas físicas - Cheque especial - Recursos livres - 20665", "20665 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Crédito pessoal não consignado - Recursos livres - 20666", "20666 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Crédito pessoal não consignado vinculado à composição de dívidas - Recursos livres - 20667", "20667 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Crédito pessoal consignado para trabalhadores do setor privado - Recursos livres - 20668", "20668 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Crédito pessoal consignado para trabalhadores do setor público - Recursos livres - 20669", "20669 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Crédito pessoal consignado para aposentados e pensionistas do INSS - Recursos livres - 20670", "20670 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Aquisição de veículos - Recursos livres - 20673", "20673 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Aquisição de outros bens - Recursos livres - 20674", "20674 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Arrendamento mercantil de veículos - Recursos livres - 20676", "20676 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Arrendamento mercantil de outros bens - Recursos livres - 20677", "20677 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Cartão de crédito rotativo - Recursos livres - 20679", "20679 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Cartão de crédito parcelado - Recursos livres - 20680", "20680 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Cartão de crédito à vista - Recursos livres - 20681", "20681 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Desconto de cheques - Recursos livres - 20683", "20683 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Outros créditos livres - Recursos livres - 20684", "20684 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Total - Recursos livres - 20662", "20662 - Contribuição para a variação total")
               
               

write.csv2(base2,"02 - Contribuicoes concessoes pessoa fisica recursos livres (em R$ milhões).csv", row.names = F)

#3)Concessões com recursos direcionados - Pessoa Jurídica
serie=c(20687, 20688, 20690, 20691, 20693, 20694, 20695, 20697, 20686)

for (i in 1:length(serie)){
  dados = read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[i],"/dados?formato=csv&dataInicial=",datainicial,"&dataFinal=",datafinal,sep="")),sep=";")
  dados$data = as.Date(dados$data, "%d/%m/%Y")
  nome = paste("vec_ind", i, sep = "")
  assign(nome, dados)
  if(i==1)
    base3 = vec_ind1
  else
    base3 = merge(base3, dados, by = "data", all = T)
}

rm(dados)
rm(list=objects(pattern="^vec_ind"))

#Deflacionando séries com IPCA
base3[,-1]=apply(base3[,-1],2,function(x)as.numeric(gsub("\\.","",x)))
base3=cbind(base3,deflator)
base3=cbind(base3[1],apply(base3[,2:10],2,function(x) x*(tail(deflator,1)/deflator)))

# Cálculo da contribuicao:
# A função apply irá aplicar a função em cada coluna da base3[,-1] (em cada série do bcb)
variacao=apply(base3[,-1],2,function(x){
  variacao_YoY=rep(NA,12)
  for(i in 13:dim(base3)[1]) variacao_YoY[i]=(x[i]/x[i-12])-1
  return(variacao_YoY)
})

peso=apply(base3[,-1],2,function(x){
  peso=rep(NA,12)
  for(i in 13:dim(base3)[1]) peso[i]=(x[i-12]/base3$valor[i-12])
  return(peso)
})

contribuicao = (peso*variacao)

base3=cbind(base3,contribuicao)
base3=base3[,c(1,2,11,3,12,4,13,5,14,6,15,7,16,8,17,9,18,10,19)]

names(base3)=c("Data", "Concessões - Pessoas jurídicas - Crédito rural com taxas de mercado - Recursos direcionados - 20687", "20687 - Contribuição para a variação total",
               "Concessões - Pessoas jurídicas - Crédito rural com taxas reguladas - Recursos direcionados - 20688", "20688 - Contribuição para a variação total",
               "Concessões - Pessoas jurídicas - Financiamento imobiliário com taxas de mercado - Recursos direcionados - 20690", "20690 - Contribuição para a variação total",
               "Concessões - Pessoas jurídicas - Financiamento imobiliário com taxas reguladas - Recursos direcionados - 20691", "20691 - Contribuição para a variação total",
               "Concessões - Pessoas jurídicas - Capital de giro com recursos do BNDES - Recursos direcionados - 20693", "20693 - Contribuição para a variação total",
               "Concessões - Pessoas jurídicas - Financiamento de investimentos com recursos do BNDES - Recursos direcionados - 20694", "20694 - Contribuição para a variação total",
               "Concessões - Pessoas jurídicas - Financiamento agroindustrial com recursos do BNDES - Recursos direcionados - 20695", "20695 - Contribuição para a variação total",
               "Concessões - Pessoas jurídicas - Outros créditos direcionados - Recursos direcionados - 20697", "20697 - Contribuição para a variação total",
               "Concessões - Pessoas jurídicas - Total - Recursos direcionados - 20686", "20686 - Contribuição para a variação total")



write.csv2(base3,"03 - Contribuicoes concessoes pessoa juridica recursos direcionados (em R$ milhões).csv", row.names = F)

#3)Concessões com recursos direcionados - Pessoa Jurídica
serie=c(20699, 20700, 20702, 20703, 20705, 20706, 20707, 20709, 20710, 20713, 20698)

for (i in 1:length(serie)){
  dados = read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",serie[i],"/dados?formato=csv&dataInicial=",datainicial,"&dataFinal=",datafinal,sep="")),sep=";")
  dados$data = as.Date(dados$data, "%d/%m/%Y")
  nome = paste("vec_ind", i, sep = "")
  assign(nome, dados)
  if(i==1)
    base4 = vec_ind1
  else
    base4 = merge(base4, dados, by = "data", all = T)
}

rm(dados)
rm(list=objects(pattern="^vec_ind"))

#Deflacionando séries com IPCA
base4[,-1]=apply(base4[,-1],2,function(x)as.numeric(gsub("\\.","",x)))
base4=cbind(base4,deflator)
base4=cbind(base4[1],apply(base4[,2:12],2,function(x) x*(tail(deflator,1)/deflator)))

# Cálculo da contribuicao:
# A função apply irá aplicar a função em cada coluna da base4[,-1] (em cada série do bcb)
variacao=apply(base4[,-1],2,function(x){
  variacao_YoY=rep(NA,12)
  for(i in 13:dim(base4)[1]) variacao_YoY[i]=(x[i]/x[i-12])-1
  return(variacao_YoY)
})

peso=apply(base4[,-1],2,function(x){
  peso=rep(NA,12)
  for(i in 13:dim(base4)[1]) peso[i]=(x[i-12]/base4$valor[i-12])
  return(peso)
})

contribuicao = (peso*variacao)

base4=cbind(base4,contribuicao)
base4=base4[,c(1,2,13,3,14,4,15,5,16,6,17,7,18,8,19,9,20,10,21,11,22,12,23)]

names(base4)=c("Data", "Concessões - Pessoas físicas - Crédito rural com taxas de mercado - Recursos direcionados - 20699", "20699 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Crédito rural com taxas reguladas - Recursos direcionados - 20700", "20700 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Financiamento imobiliário com taxas de mercado - Recursos direcionados- 20702", "20702 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Financiamento imobiliário com taxas reguladas - Recursos direcionados - 20703", "20703 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Capital de giro com recursos do BNDES - Recursos direcionados - 20705", "20705 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Financiamento de investimentos com recursos do BNDES - Recursos direcionados - 20706", "20706 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Financiamento agroindustrial com recursos do BNDES - Recursos direcionados - 20707", "20707 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Microcrédito destinado a consumo - Recursos direcionados - 20709", "20709 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Microcrédito destinado a microempreendedores - Recursos direcionados - 20710", "20710 - Contribuição para a variação total",
               "Concessões - Pessoas físicas - Outros créditos direcionados - Recursos direcionados - 20713", "20713 - Contribuição para a variação total", 
               "Concessões - Pessoas físicas - Total - Recursos direcionados - 20698", "20698 - Contribuição para a variação total")


write.csv2(base4,"04 - Contribuicoes concessoes pessoa fisica recursos direcionados (em R$ milhões).csv", row.names = F)