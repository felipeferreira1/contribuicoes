#################################################################################################################
#GECON
#�REA:CR�DITO
#PLANILHA ABERTURA DAS CONTRIBUI��ES DE CONCESS�ES DE CR�DITO
#FELIPE SIMPL�CIO FERREIRA
#DATA:10-11-2020
#################################################################################################################

#PACOTES REQUERIDOS:
#INSTALAR QUANDO NECESS�RIO
#EXEMPLO:install.packages("pryr")
#library(xlsx)
library(RCurl)
library(XML)
library(rio)

#DEFINIR PASTAS DE RESULTADOS:
getwd()
setwd("C:\\Users\\User\\Documents")

#Criando fun��o para coleta de s�ries
coleta_dados_sgs = function(series,datainicial="01/03/2011", datafinal = format(Sys.time(), "%d/%m/%Y")){
  #Argumentos: vetor de s�ries, datainicial que pode ser manualmente alterada e datafinal que automaticamente usa a data de hoje
  #Cria estrutura de repeti��o para percorrer vetor com c�digos de s�ries e depois juntar todas em um �nico dataframe
  for (i in 1:length(series)){
    dados = read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",series[i],"/dados?formato=csv&dataInicial=",datainicial,"&dataFinal=",datafinal,sep="")),sep=";")
    dados[,-1] = as.numeric(gsub(",",".",dados[,-1])) #As colunas do dataframe em objetos num�ricos exceto a da data
    nome_coluna = series[i] #Nomeia cada coluna do dataframe com o c�digo da s�rie
    colnames(dados) = c('data', nome_coluna)
    nome_arquivo = paste("dados", i, sep = "") #Nomeia os v�rios arquivos intermedi�rios que s�o criados com cada s�rie
    assign(nome_arquivo, dados)
    
    if(i==1)
      base = dados1 #Primeira repeti��o cria o dataframe
    else
      base = merge(base, dados, by = "data", all = T) #Demais repeti��es agregam colunas ao dataframe criado
    print(paste(i, length(series), sep = '/')) #Printa o progresso da repeti��o
  }
  
  base$data = as.Date(base$data, "%d/%m/%Y") #Transforma coluna de data no formato de data
  base = base[order(base$data),] #Ordena o dataframe de acordo com a data
  return(base)
}

#Fun��o de calculo de s�rie por dia �til
dia_util = function(base, datainicial = '2011.03'){
  url_ipea="http://www.ipeadata.gov.br/ExibeSerie.aspx?serid=459044792"
  ipea.table = readHTMLTable(htmlParse(getURL(url_ipea, useragent="curl/7.39.0 Rcurl/1.95.4.5")), header=T, which=3,stringsAsFactors=F)
  ipea.table = ipea.table[-1:-4,-3]
  names(ipea.table) = c("Data", "Dias �teis")
  ipea.table = ipea.table[rowSums(is.na(ipea.table)) == 0,]
  ipea.table = ipea.table[-dim(ipea.table)[1],]
  ipea.table = ipea.table[-dim(ipea.table)[1],]
  dias_uteis= ipea.table[which(ipea.table$Data==datainicial):which(ipea.table$Data==format(as.Date(tail(base$data,1)),"%Y.%m")),]
  base_a = base
  base_a=apply(base_a[,2:length(base_a)],2,function(x){base_a=x/as.numeric(dias_uteis[,2]);return(base_a)})
  base_a = as.data.frame(base_a)
  base_a = cbind(base[,1], base_a)
  base = base_a
  colnames(base)[1] = 'data'
  return(base)
}

#Fun��o para deflacionar s�ries com IPCA
deflaciona = function(base, datainicial = '2011.03'){
  url_ipea="http://www.ipeadata.gov.br/ExibeSerie.aspx?serid=36482"
  ipea.table = readHTMLTable(htmlParse(getURL(url_ipea, useragent="curl/7.39.0 Rcurl/1.95.4.5")), header=T, which=3,stringsAsFactors=F)
  ipea.table = ipea.table[-1:-4,-3]
  names(ipea.table) = c("Data", "IPCA")
  ipea.table = ipea.table[rowSums(is.na(ipea.table)) == 0,]
  ipea.table = ipea.table[-dim(ipea.table)[1],]
  ipea.table = ipea.table[-dim(ipea.table)[1],]
  deflator = ipea.table[which(ipea.table$Data==datainicial):which(ipea.table$Data==format(as.Date(tail(base$data,1)),"%Y.%m")),]
  deflator=as.numeric(gsub(",","\\.",gsub("\\.","",deflator[,2])))
  base=cbind(base,deflator)
  base=cbind(base[1],apply(base[,2:(length(base)-1)],2,function(x) x*(tail(deflator,1)/deflator)))
  colnames(base)[1] = 'data'
  return(base)
}

#Fun��o para c�lculo da contribuicao:
#A fun��o apply ir� aplicar a fun��o em cada coluna da base[,-1] (em cada s�rie do bcb)
contribuicao = function(base, total){
  variacao=apply(base[,-1],2,function(x){
    variacao_YoY=rep(NA,12)
    for(i in 13:dim(base)[1])
      variacao_YoY[i]=(x[i]/x[i-12])-1
    return(variacao_YoY)
  })
  
  peso=apply(base[,-1],2,function(x){
    peso=rep(NA,12)
    for(i in 13:dim(base)[1])
      peso[i]=(x[i-12]/base[i-12, total])
    return(peso)
  })
  
  contribuicao = (peso*variacao)
  contribuicao = as.data.frame(contribuicao)
  contribuicao = cbind(base[,1], contribuicao)
  contribuicao = contribuicao[-c(1:12),]
  colnames(contribuicao)[1] = 'data'
  return(contribuicao)
}

#1)Concess�es com recursos livres - Pessoa Jur�dica
series1=c(20636, 20637, 20638, 20639, 20640, 20641, 20643, 20644, 20645, 20646, 20648, 20649, 20651, 20652, 20653, 20654, 20655, 20657, 20658, 20659, 20660, 20661, 20635)

base1 <- coleta_dados_sgs(series1)

#Calculo de s�rie por dia �til
base1 <- dia_util(base1)

#Deflacionando s�ries com IPCA
base1 <- deflaciona(base1)

#Calculando da contribuicao:
base1 <- contribuicao(base1, "20635")

names(base1)=c("Data", "Concess�es - Pessoas jur�dicas - Desconto de duplicatas e receb�veis - Recursos Livres -  20366",
              "Concess�es - Pessoas jur�dicas - Desconto de cheques - Recursos Livres - 20637",
              "Concess�es - Pessoas jur�dicas - Antecipa��o de faturas de cart�o de cr�dito - Recursos Livres - 20638",
              "Concess�es - Pessoas jur�dicas - Capital de giro com prazo de at� 365 dias - Recursos Livres - 20639",
              "Concess�es - Pessoas jur�dicas - Capital de giro com prazo superior a 365 dias - Recursos Livres - 20640",
              "Concess�es - Pessoas jur�dicas - Capital de giro rotativo - Recursos Livres - 20641",
              "Concess�es - Pessoas jur�dicas - Conta garantida - Recursos Livres - 20643",
              "Concess�es - Pessoas jur�dicas - Cheque especial - Recursos Livres - 20644",
              "Concess�es - Pessoas jur�dicas - Aquisi��o de ve�culos - Recursos Livres - 20645",
              "Concess�es - Pessoas jur�dicas - Aquisi��o de outros bens - Recursos Livres - 20646",
              "Concess�es - Pessoas jur�dicas - Arrendamento mercantil de ve�culos - Recursos Livres - 20648",
              "Concess�es - Pessoas jur�dicas - Arrendamento mercantil de outros bens - Recursos Livres - 20649",
              "Concess�es - Pessoas jur�dicas - Vendor - Recursos Livres - 20651",
              "Concess�es - Pessoas jur�dicas - Compror - Recursos Livres - 20652",
              "Concess�es - Pessoas jur�dicas - Cart�o de cr�dito rotativo  - Recursos Livres - 20653",
              "Concess�es - Pessoas jur�dicas - Cart�o de cr�dito parcelado - Recursos Livres - 20654",
              "Concess�es - Pessoas jur�dicas - Cart�o de cr�dito � vista - Recursos Livres - 20655",
              "Concess�es - Pessoas jur�dicas - Adiantamento sobre contratos de c�mbio (ACC) - Recursos Livres - 20657",
              "Concess�es - Pessoas jur�dicas - Financiamento a importa��es - Recursos Livres - 20658",
              "Concess�es - Pessoas jur�dicas - Financiamento a exporta��es - Recursos Livres	- 20659",
              "Concess�es - Pessoas jur�dicas - Repasse externo - Recursos Livres - 20660",
              "Concess�es - Pessoas jur�dicas - Outros cr�ditos livres - Recursos Livres - 20661",
              "Concess�es - Pessoas jur�dicas - Total	- Recursos livres - 20635")


write.csv2(base1,"01 - Contribuicoes concessoes pessoa juridica recursos livres.csv", row.names = F)
export(base1, "Contribui��es concess�es pessoas jur�dica e f�sica com recursos livres e direcionados(fonte).xlsx", sheetName = "PJ Livres")

#2)Concess�es com recursos livres - Pessoa F�sica
series2=c(20665, 20666, 20668, 20669, 20670, 20673, 20674, 20676, 20677, 20679, 20680, 20681, 20683, 20684, 20662)

base2 <- coleta_dados_sgs(series2)

#Calculo de s�rie por dia �til
base2 <- dia_util(base2)

#Deflacionando s�ries com IPCA
base2 <- deflaciona(base2)

#Calculando da contribuicao:
base2 <- contribuicao(base2, "20662")

names(base2)=c("Data", "Concess�es - Pessoas f�sicas - Cheque especial - Recursos livres - 20665",
               "Concess�es - Pessoas f�sicas - Cr�dito pessoal n�o consignado - Recursos livres - 20666",
               "Concess�es - Pessoas f�sicas - Cr�dito pessoal consignado para trabalhadores do setor privado - Recursos livres - 20668",
               "Concess�es - Pessoas f�sicas - Cr�dito pessoal consignado para trabalhadores do setor p�blico - Recursos livres - 20669",
               "Concess�es - Pessoas f�sicas - Cr�dito pessoal consignado para aposentados e pensionistas do INSS - Recursos livres - 20670",
               "Concess�es - Pessoas f�sicas - Aquisi��o de ve�culos - Recursos livres - 20673",
               "Concess�es - Pessoas f�sicas - Aquisi��o de outros bens - Recursos livres - 20674",
               "Concess�es - Pessoas f�sicas - Arrendamento mercantil de ve�culos - Recursos livres - 20676",
               "Concess�es - Pessoas f�sicas - Arrendamento mercantil de outros bens - Recursos livres - 20677",
               "Concess�es - Pessoas f�sicas - Cart�o de cr�dito rotativo - Recursos livres - 20679",
               "Concess�es - Pessoas f�sicas - Cart�o de cr�dito parcelado - Recursos livres - 20680",
               "Concess�es - Pessoas f�sicas - Cart�o de cr�dito � vista - Recursos livres - 20681",
               "Concess�es - Pessoas f�sicas - Desconto de cheques - Recursos livres - 20683",
               "Concess�es - Pessoas f�sicas - Outros cr�ditos livres - Recursos livres - 20684",
               "Concess�es - Pessoas f�sicas - Total - Recursos livres - 20662")

write.csv2(base2,"02 - Contribuicoes concessoes pessoa fisica recursos livres.csv", row.names = F)
export(base2, "Contribui��es concess�es pessoas jur�dica e f�sica com recursos livres e direcionados(fonte).xlsx", which = "PF Livres")

#3)Concess�es com recursos direcionados - Pessoa Jur�dica
series3=c(20687, 20688, 20690, 20691, 20693, 20694, 20695, 20697, 20686)

base3 <- coleta_dados_sgs(series3)

#Calculo de s�rie por dia �til
base3 <- dia_util(base3)

#Deflacionando s�ries com IPCA
base3 <- deflaciona(base3)

#Calculando da contribuicao:
base3 <- contribuicao(base3, "20686")

names(base3)=c("Data", "Concess�es - Pessoas jur�dicas - Cr�dito rural com taxas de mercado - Recursos direcionados - 20687",
               "Concess�es - Pessoas jur�dicas - Cr�dito rural com taxas reguladas - Recursos direcionados - 20688",
               "Concess�es - Pessoas jur�dicas - Financiamento imobili�rio com taxas de mercado - Recursos direcionados - 20690",
               "Concess�es - Pessoas jur�dicas - Financiamento imobili�rio com taxas reguladas - Recursos direcionados - 20691",
               "Concess�es - Pessoas jur�dicas - Capital de giro com recursos do BNDES - Recursos direcionados - 20693",
               "Concess�es - Pessoas jur�dicas - Financiamento de investimentos com recursos do BNDES - Recursos direcionados - 20694",
               "Concess�es - Pessoas jur�dicas - Financiamento agroindustrial com recursos do BNDES - Recursos direcionados - 20695",
               "Concess�es - Pessoas jur�dicas - Outros cr�ditos direcionados - Recursos direcionados - 20697",
               "Concess�es - Pessoas jur�dicas - Total - Recursos direcionados - 20686")



write.csv2(base3,"03 - Contribuicoes concessoes pessoa juridica recursos direcionados.csv", row.names = F)
export(base3, "Contribui��es concess�es pessoas jur�dica e f�sica com recursos livres e direcionados(fonte).xlsx", which = "PJ Direcionados")

#4)Concess�es com recursos direcionados - Pessoa F�sica
series4=c(20699, 20700, 20702, 20703, 20705, 20706, 20707, 20709, 20710, 20713, 20698)

base4 <- coleta_dados_sgs(series4)

#Calculo de s�rie por dia �til
base4 <- dia_util(base4)

#Deflacionando s�ries com IPCA
base4 <- deflaciona(base4)

#Calculando da contribuicao:
base4 <- contribuicao(base4, "20698")


names(base4)=c("Data", "Concess�es - Pessoas f�sicas - Cr�dito rural com taxas de mercado - Recursos direcionados - 20699",
               "Concess�es - Pessoas f�sicas - Cr�dito rural com taxas reguladas - Recursos direcionados - 20700",
               "Concess�es - Pessoas f�sicas - Financiamento imobili�rio com taxas de mercado - Recursos direcionados- 20702",
               "Concess�es - Pessoas f�sicas - Financiamento imobili�rio com taxas reguladas - Recursos direcionados - 20703",
               "Concess�es - Pessoas f�sicas - Capital de giro com recursos do BNDES - Recursos direcionados - 20705",
               "Concess�es - Pessoas f�sicas - Financiamento de investimentos com recursos do BNDES - Recursos direcionados - 20706",
               "Concess�es - Pessoas f�sicas - Financiamento agroindustrial com recursos do BNDES - Recursos direcionados - 20707",
               "Concess�es - Pessoas f�sicas - Microcr�dito destinado a consumo - Recursos direcionados - 20709",
               "Concess�es - Pessoas f�sicas - Microcr�dito destinado a microempreendedores - Recursos direcionados - 20710",
               "Concess�es - Pessoas f�sicas - Outros cr�ditos direcionados - Recursos direcionados - 20713",
               "Concess�es - Pessoas f�sicas - Total - Recursos direcionados - 20698")


write.csv2(base4,"04 - Contribuicoes concessoes pessoa fisica recursos direcionados.csv", row.names = F)
export(base4, "Contribui��es concess�es pessoas jur�dica e f�sica com recursos livres e direcionados(fonte).xlsx", which = "PF Direcionados")