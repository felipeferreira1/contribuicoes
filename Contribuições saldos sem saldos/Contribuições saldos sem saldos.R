#################################################################################################################
#GECON
#�REA:CR�DITO
#PLANILHA ABERTURA DAS CONTRIBUI��ES DE CR�DITO
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

#DEFINI��O DE FUN��ES
#Fun��o de coleta de dados
coleta_dados = function(series,datainicial="01/03/2011", datafinal = format(Sys.time(), "%d/%m/%Y")){
  
  for (i in 1:length(series)){
    dados = read.csv(url(paste("http://api.bcb.gov.br/dados/serie/bcdata.sgs.",series[i],"/dados?formato=csv&dataInicial=",datainicial,"&dataFinal=",datafinal,sep="")),sep=";")
    nome_coluna = series[i]
    colnames(dados) = c('data', nome_coluna)
    nome_arquivo = paste("dados", i, sep = "")
    assign(nome_arquivo, dados)
    
    if(i==1)
      base = dados1
    else
      base = merge(base, dados, by = "data", all = T)
    print(paste(i, length(serie), sep = '/'))
  }
  
  base$data = as.Date(base$data, "%d/%m/%Y")
  base = base[order(base$data),]
  base[,-1]=apply(base[,-1],2,function(x)as.numeric(gsub("\\.","",x)))
  rm(list=objects(pattern="^nome"))
  rm(list=objects(pattern="^dados"))
  return(base)
}

#Deflacionando s�ries com IPCA
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

# C�lculo da contribuicao:
# A fun��o apply ir� aplicar a fun��o em cada coluna da base[,-1] (em cada s�rie do bcb)
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

#COLETA DOS DADOS
#1)Pessoas Jur�dicas - Recursos livres
serie=c(20544,20545,20546,20547,20548,20549,20551,20552,20553,20554,20556,20557,20559,20560,20561,20562,20563,20565,20566,20567,20568,20569,20543)

base = coleta_dados(serie)
base = deflaciona(base)
base = contribuicao(base, '20543')

names(base)=c("Data", "Contribui��o para a varia��o total - Pessoas jur�dicas - Desconto de duplicatas e receb�veis - 20544",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Desconto de cheques- 20545",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Antecipa��o de faturas de cart�o de cr�dito - 20546",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Capital de giro com prazo de at� 365 dias - 20547",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Capital de giro com prazo superior a 365 dias - 20548",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Capital de giro rotativo - 20549",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Conta garantida - 20551",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Cheque especial - 20552",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Aquisi��o de ve�culos - 20553",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Aquisi��o de outros bens - 20554",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Arrendamento mercantil de ve�culos - 20556",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Arrendamento mercantil de outros bens - 20557",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Vendor - 20559",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Compror - 20560",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Cart�o de cr�dito rotativo - 20561",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Cart�o de cr�dito parcelado - 20562",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Cart�o de cr�dito � vista - 20563",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Adiantamento sobre contratos de c�mbio (ACC) - 20565",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Financiamento a importa��es - 20566",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Financiamento a exporta��es - 20567",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Repasse externo - 20568",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Outros cr�ditos livres - 20569",
              "Contribui��o para a varia��o total - Pessoas jur�dicas - Total - 20543")


write.csv2(base,"01 - Contribuicoes saldo pessoa juridica recursos livres (em R$ milh�es).csv", row.names = F)
export(base, "Contribui��es saldo pessoas jur�dica e f�sica com recursos livres e direcionados(fonte).xlsx", sheetName = "PJ Livres")

#2)Pessoas F�sicas - Recursos livres
serie2=c(20573,20574,20575,20576,20577,20578,20581,20582,20584,20585,20587,20588,20589,20591,20592,20570)

base2 = coleta_dados(serie2)
base2 = deflaciona(base2)
base2 = contribuicao(base2, '20570')

names(base2)=c("Data", "Contribui��o para a varia��o total - Pessoas f�sicas - Cheque especial - 20573",
              "Contribui��o para a varia��o total - Pessoas f�sicas - Cr�dito pessoal n�o consignado - 20574",
              "Contribui��o para a varia��o total - Pessoas f�sicas - Cr�dito pessoal n�o consignado vinculado � composi��o de d�vidas - 20575",
              "Contribui��o para a varia��o total - Pessoas f�sicas - Cr�dito pessoal consignado para trabalhadores do setor privado - 20576",
              "Contribui��o para a varia��o total - Pessoas f�sicas - Cr�dito pessoal consignado para trabalhadores do setor p�blico - 20577",
              "Contribui��o para a varia��o total - Pessoas f�sicas - Cr�dito pessoal consignado para aposentados e pensionistas do INSS - 20578",
              "Contribui��o para a varia��o total - Pessoas f�sicas - Aquisi��o de ve�culos - 20581",
              "Contribui��o para a varia��o total - Pessoas f�sicas - Aquisi��o de outros bens - 20582",
              "Contribui��o para a varia��o total - Pessoas f�sicas - Arrendamento mercantil de ve�culos - 20584",
              "Contribui��o para a varia��o total - Pessoas f�sicas - Arrendamento mercantil de outros bens - 20585",
              "Contribui��o para a varia��o total - Pessoas f�sicas - Cart�o de cr�dito rotativo - 20587",
              "Contribui��o para a varia��o total - Pessoas f�sicas - Cart�o de cr�dito parcelado - 20588",
              "Contribui��o para a varia��o total - Pessoas f�sicas - Cart�o de cr�dito � vista - 20589",
              "Contribui��o para a varia��o total - Pessoas f�sicas - Desconto de cheques - 20591",
              "Contribui��o para a varia��o total - Pessoas f�sicas - Outros cr�ditos livres - 20592",
              "Contribui��o para a varia��o total da carteira de cr�dito com recursos livres - Pessoas f�sicas - Total - 20570")


write.csv2(base2,"02 - Contribuicoes saldo pessoa fisica recursos livres (em R$ milh�es).csv", row.names = F)
export(base2, "Contribui��es saldo pessoas jur�dica e f�sica com recursos livres e direcionados(fonte).xlsx", which = "PF Livres")

#3)Pessoas Jur�dicas - Recursos direcionados
serie3=c(20595,20596,20598,20599,20601,20602,20603,20605,20594)

base3 = coleta_dados(serie3)
base3 = deflaciona(base3)
base3 = contribuicao(base3, '20594')

names(base3)=c("Data", "Contribui��o para a varia��o total - Pessoas jur�dicas - Cr�dito rural com taxas de mercado - 20595",
               "Contribui��o para a varia��o total - Pessoas jur�dicas - Cr�dito rural com taxas reguladas - 20596",
               "Contribui��o para a varia��o total - Pessoas jur�dicas - Financiamento imobili�rio com taxas de mercado - 20598",
               "Contribui��o para a varia��o total - Pessoas jur�dicas - Financiamento imobili�rio com taxas reguladas - 20599",
               "Contribui��o para a varia��o total - Pessoas jur�dicas - Capital de giro com recursos do BNDES - 20601",
               "Contribui��o para a varia��o total - Pessoas jur�dicas - Financiamento de investimentos com recursos do BNDES - 20602",
               "Contribui��o para a varia��o total - Pessoas jur�dicas - Financiamento agroindustrial com recursos do BNDES - 20603",
               "Contribui��o para a varia��o total - Pessoas jur�dicas - Outros cr�ditos direcionados - 20605",
               "Contribui��o para a varia��o total - Pessoas jur�dicas - Total - 20594")

write.csv2(base3,"03 - Contribuicoes saldo pessoa juridica recursos direcionados (em R$ milh�es).csv", row.names = F)
export(base3, "Contribui��es saldo pessoas jur�dica e f�sica com recursos livres e direcionados(fonte).xlsx", which = "PJ Direcionados")

#4)Pessoas F�sicas - Recursos direcionados
serie4=c(20607,20608,20610,20611,20613,20614,20615,20617,20618,20621,20606)

base4 = coleta_dados(serie4)
base4 = deflaciona(base4)
base4 = contribuicao(base4, '20606')

names(base4)=c("Data", " Contribui��o para a varia��o total - Pessoas f�sicas - Cr�dito rural com taxas de mercado - 20607",
               "Contribui��o para a varia��o total - Pessoas f�sicas - Cr�dito rural com taxas reguladas - 20608",
               "Contribui��o para a varia��o total - Pessoas f�sicas - Financiamento imobili�rio com taxas de mercado - 20610",
               "Contribui��o para a varia��o total - Pessoas f�sicas - Financiamento imobili�rio com taxas reguladas - 20611",
               "Contribui��o para a varia��o total - Pessoas f�sicas - Capital de giro com recursos do BNDES - 20613",
               "Contribui��o para a varia��o total - Pessoas f�sicas - Financiamento de investimentos com recursos do BNDES - 20614",
               "Contribui��o para a varia��o total - Pessoas f�sicas - Financiamento agroindustrial com recursos do BNDES - 20615",
               "Contribui��o para a varia��o total - Pessoas f�sicas - Microcr�dito destinado a consumo - 20617",
               "Contribui��o para a varia��o total - Pessoas f�sicas - Microcr�dito destinado a microempreendedores - 20618",
               "Contribui��o para a varia��o total - Pessoas f�sicas - Outros cr�ditos direcionados - 20621",
               "Contribui��o para a varia��o total - Pessoas f�sicas - Total - 20606")


write.csv2(base4,"04 - Contribuicoes saldo pessoa fisica recursos direcionados (em R$ milh�es).csv", row.names = F)
export(base4, "Contribui��es saldo pessoas jur�dica e f�sica com recursos livres e direcionados(fonte).xlsx", which = "PF Direcionados")