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
setwd("C:\\Users\\User\\Documents")

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

#Calculo de série por dia útil
base[,-1]=apply(base[,-1],2,function(x)as.numeric(gsub("\\.","",x)))
url_ipea="http://www.ipeadata.gov.br/ExibeSerie.aspx?serid=459044792"
ipea.table1 = readHTMLTable(htmlParse(getURL(url_ipea, useragent="curl/7.39.0 Rcurl/1.95.4.5")), header=T, which=3,stringsAsFactors=F)
ipea.table1 = ipea.table1[-1:-4,-3]
names(ipea.table1) = c("Data", "Dias úteis")
ipea.table1 = ipea.table1[rowSums(is.na(ipea.table1)) == 0,]
ipea.table1 = ipea.table1[-dim(ipea.table1)[1],]
ipea.table1 = ipea.table1[-dim(ipea.table1)[1],]
dias_uteis= ipea.table1[which(ipea.table1$Data=="2011.03"):which(ipea.table1$Data==format(as.Date(tail(base$data,1)),"%Y.%m")),]
base_a = base
base_a=apply(base_a[,2:24],2,function(x){base_a=x/as.numeric(dias_uteis[,2]);return(base_a)})
base_a = as.data.frame(base_a)
base_a = cbind(base[,1], base_a)
base = base_a

#Deflacionando séries com IPCA
url_ipea="http://www.ipeadata.gov.br/ExibeSerie.aspx?serid=36482"
ipea.table = readHTMLTable(htmlParse(getURL(url_ipea, useragent="curl/7.39.0 Rcurl/1.95.4.5")), header=T, which=3,stringsAsFactors=F)
ipea.table = ipea.table[-1:-4,-3]
names(ipea.table) = c("Data", "IPCA")
ipea.table = ipea.table[rowSums(is.na(ipea.table)) == 0,]
ipea.table = ipea.table[-dim(ipea.table)[1],]
ipea.table = ipea.table[-dim(ipea.table)[1],]
deflator = ipea.table[which(ipea.table$Data=="2011.03"):which(ipea.table$Data==format(as.Date(tail(base$`base[, 1]`,1)),"%Y.%m")),]
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

contribuicao1 = (peso*variacao)
contribuicao1 = as.data.frame(contribuicao1)
contribuicao1 = cbind(base[,1], contribuicao1)
contribuicao1 = contribuicao1[-c(1:12),]

names(contribuicao1)=c("Data", "Concessões - Pessoas jurídicas - Desconto de duplicatas e recebíveis - Recursos Livres -  20366",
              "Concessões - Pessoas jurídicas - Desconto de cheques - Recursos Livres - 20637",
              "Concessões - Pessoas jurídicas - Antecipação de faturas de cartão de crédito - Recursos Livres - 20638",
              "Concessões - Pessoas jurídicas - Capital de giro com prazo de até 365 dias - Recursos Livres - 20639",
              "Concessões - Pessoas jurídicas - Capital de giro com prazo superior a 365 dias - Recursos Livres - 20640",
              "Concessões - Pessoas jurídicas - Capital de giro rotativo - Recursos Livres - 20641",
              "Concessões - Pessoas jurídicas - Conta garantida - Recursos Livres - 20643",
              "Concessões - Pessoas jurídicas - Cheque especial - Recursos Livres - 20644",
              "Concessões - Pessoas jurídicas - Aquisição de veículos - Recursos Livres - 20645",
              "Concessões - Pessoas jurídicas - Aquisição de outros bens - Recursos Livres - 20646",
              "Concessões - Pessoas jurídicas - Arrendamento mercantil de veículos - Recursos Livres - 20648",
              "Concessões - Pessoas jurídicas - Arrendamento mercantil de outros bens - Recursos Livres - 20649",
              "Concessões - Pessoas jurídicas - Vendor - Recursos Livres - 20651",
              "Concessões - Pessoas jurídicas - Compror - Recursos Livres - 20652",
              "Concessões - Pessoas jurídicas - Cartão de crédito rotativo  - Recursos Livres - 20653",
              "Concessões - Pessoas jurídicas - Cartão de crédito parcelado - Recursos Livres - 20654",
              "Concessões - Pessoas jurídicas - Cartão de crédito à vista - Recursos Livres - 20655",
              "Concessões - Pessoas jurídicas - Adiantamento sobre contratos de câmbio (ACC) - Recursos Livres - 20657",
              "Concessões - Pessoas jurídicas - Financiamento a importações - Recursos Livres - 20658",
              "Concessões - Pessoas jurídicas - Financiamento a exportações - Recursos Livres	- 20659",
              "Concessões - Pessoas jurídicas - Repasse externo - Recursos Livres - 20660",
              "Concessões - Pessoas jurídicas - Outros créditos livres - Recursos Livres - 20661",
              "Concessões - Pessoas jurídicas - Total	- Recursos livres - 20635")


write.csv2(contribuicao1,"01 - Contribuicoes concessoes pessoa juridica recursos livres.csv", row.names = F)

#2)Concessões com recursos livres - Pessoa Física
serie=c(20665, 20666, 20668, 20669, 20670, 20673, 20674, 20676, 20677, 20679, 20680, 20681, 20683, 20684, 20662)

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

#Calculo de série por dia útil
base2[,-1]=apply(base2[,-1],2,function(x)as.numeric(gsub("\\.","",x)))
base_a = base2
base_a=apply(base_a[,2:16],2,function(x){base_a=x/as.numeric(dias_uteis[,2]);return(base_a)})
base_a = as.data.frame(base_a)
base_a = cbind(base[,1], base_a)
base2 = base_a

#Deflacionando séries com IPCA
base2=cbind(base2,deflator)
base2=cbind(base2[1],apply(base2[,2:16],2,function(x) x*(tail(deflator,1)/deflator)))

# Cálculo da contribuicao:
# A função apply irá aplicar a função em cada coluna da base2[,-1] (em cada série do bcb)
variacao=apply(base2[,-1],2,function(x){
  variacao_YoY=rep(NA,12)
  for(i in 13:dim(base2)[1]) variacao_YoY[i]=(x[i]/x[i-12])-1
  return(variacao_YoY)
})

peso=apply(base2[,-1],2,function(x){
  peso=rep(NA,12)
  for(i in 13:dim(base2)[1]) peso[i]=(x[i-12]/base2$valor[i-12])
  return(peso)
})

contribuicao2 = (peso*variacao)
contribuicao2 = as.data.frame(contribuicao2)
contribuicao2 = cbind(base[,1], contribuicao2)
contribuicao2 = contribuicao2[-c(1:12),]

names(contribuicao2)=c("Data", "Concessões - Pessoas físicas - Cheque especial - Recursos livres - 20665",
               "Concessões - Pessoas físicas - Crédito pessoal não consignado - Recursos livres - 20666",
               "Concessões - Pessoas físicas - Crédito pessoal consignado para trabalhadores do setor privado - Recursos livres - 20668",
               "Concessões - Pessoas físicas - Crédito pessoal consignado para trabalhadores do setor público - Recursos livres - 20669",
               "Concessões - Pessoas físicas - Crédito pessoal consignado para aposentados e pensionistas do INSS - Recursos livres - 20670",
               "Concessões - Pessoas físicas - Aquisição de veículos - Recursos livres - 20673",
               "Concessões - Pessoas físicas - Aquisição de outros bens - Recursos livres - 20674",
               "Concessões - Pessoas físicas - Arrendamento mercantil de veículos - Recursos livres - 20676",
               "Concessões - Pessoas físicas - Arrendamento mercantil de outros bens - Recursos livres - 20677",
               "Concessões - Pessoas físicas - Cartão de crédito rotativo - Recursos livres - 20679",
               "Concessões - Pessoas físicas - Cartão de crédito parcelado - Recursos livres - 20680",
               "Concessões - Pessoas físicas - Cartão de crédito à vista - Recursos livres - 20681",
               "Concessões - Pessoas físicas - Desconto de cheques - Recursos livres - 20683",
               "Concessões - Pessoas físicas - Outros créditos livres - Recursos livres - 20684",
               "Concessões - Pessoas físicas - Total - Recursos livres - 20662")
               
               

write.csv2(contribuicao2,"02 - Contribuicoes concessoes pessoa fisica recursos livres.csv", row.names = F)

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

#Calculo de série por dia útil
base3[,-1]=apply(base3[,-1],2,function(x)as.numeric(gsub("\\.","",x)))
base_a = base3
base_a=apply(base_a[,2:10],2,function(x){base_a=x/as.numeric(dias_uteis[,2]);return(base_a)})
base_a = as.data.frame(base_a)
base_a = cbind(base[,1], base_a)
base3 = base_a

#Deflacionando séries com IPCA
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

contribuicao3 = (peso*variacao)
contribuicao3 = as.data.frame(contribuicao3)
contribuicao3 = cbind(base[,1], contribuicao3)
contribuicao3 = contribuicao3[-c(1:12),]

names(contribuicao3)=c("Data", "Concessões - Pessoas jurídicas - Crédito rural com taxas de mercado - Recursos direcionados - 20687",
               "Concessões - Pessoas jurídicas - Crédito rural com taxas reguladas - Recursos direcionados - 20688",
               "Concessões - Pessoas jurídicas - Financiamento imobiliário com taxas de mercado - Recursos direcionados - 20690",
               "Concessões - Pessoas jurídicas - Financiamento imobiliário com taxas reguladas - Recursos direcionados - 20691",
               "Concessões - Pessoas jurídicas - Capital de giro com recursos do BNDES - Recursos direcionados - 20693",
               "Concessões - Pessoas jurídicas - Financiamento de investimentos com recursos do BNDES - Recursos direcionados - 20694",
               "Concessões - Pessoas jurídicas - Financiamento agroindustrial com recursos do BNDES - Recursos direcionados - 20695",
               "Concessões - Pessoas jurídicas - Outros créditos direcionados - Recursos direcionados - 20697",
               "Concessões - Pessoas jurídicas - Total - Recursos direcionados - 20686")



write.csv2(contribuicao3,"03 - Contribuicoes concessoes pessoa juridica recursos direcionados.csv", row.names = F)

#4)Concessões com recursos direcionados - Pessoa Física
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

#Calculo de série por dia útil
base4[,-1]=apply(base4[,-1],2,function(x)as.numeric(gsub("\\.","",x)))
base_a = base4
base_a=apply(base_a[,2:12],2,function(x){base_a=x/as.numeric(dias_uteis[,2]);return(base_a)})
base_a = as.data.frame(base_a)
base_a = cbind(base[,1], base_a)
base4 = base_a

#Deflacionando séries com IPCA
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

contribuicao4 = (peso*variacao)
contribuicao4 = as.data.frame(contribuicao4)
contribuicao4 = cbind(base[,1], contribuicao4)
contribuicao4 = contribuicao4[-c(1:12),]


names(contribuicao4)=c("Data", "Concessões - Pessoas físicas - Crédito rural com taxas de mercado - Recursos direcionados - 20699",
               "Concessões - Pessoas físicas - Crédito rural com taxas reguladas - Recursos direcionados - 20700",
               "Concessões - Pessoas físicas - Financiamento imobiliário com taxas de mercado - Recursos direcionados- 20702",
               "Concessões - Pessoas físicas - Financiamento imobiliário com taxas reguladas - Recursos direcionados - 20703",
               "Concessões - Pessoas físicas - Capital de giro com recursos do BNDES - Recursos direcionados - 20705",
               "Concessões - Pessoas físicas - Financiamento de investimentos com recursos do BNDES - Recursos direcionados - 20706",
               "Concessões - Pessoas físicas - Financiamento agroindustrial com recursos do BNDES - Recursos direcionados - 20707",
               "Concessões - Pessoas físicas - Microcrédito destinado a consumo - Recursos direcionados - 20709",
               "Concessões - Pessoas físicas - Microcrédito destinado a microempreendedores - Recursos direcionados - 20710",
               "Concessões - Pessoas físicas - Outros créditos direcionados - Recursos direcionados - 20713",
               "Concessões - Pessoas físicas - Total - Recursos direcionados - 20698")


write.csv2(contribuicao4,"04 - Contribuicoes concessoes pessoa fisica recursos direcionados.csv", row.names = F)