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
library(rbcb)
library(xlsx)

#DEFINIR PASTAS DE RESULTADOS:
getwd()
setwd("//SRJN3/area_corporativa/Projeto GAP-DIMAC/Automatizações/Contribuições")

#ATUALIZAR DATA (alinhar com primeiro mes dos dados)
data1="2011-03-01"

#1)Pessoas Jurídicas - Recursos livres
serie=c(20544,20545,20546,20547,20548,20549,20551,20552,20553,20554,20556,20557,20559,20560,20561,20562,20563,20565,20566,20567,20568,20569,20543)


vec_ind1 = get_series(serie[1], start_date = data1)
vec_ind2 = get_series(serie[2], start_date = data1)
vec_ind3 = get_series(serie[3], start_date = data1)
vec_ind4 = get_series(serie[4], start_date = data1)
vec_ind5 = get_series(serie[5], start_date = data1)
vec_ind6 = get_series(serie[6], start_date = data1)
vec_ind7 = get_series(serie[7], start_date = data1)
vec_ind8 = get_series(serie[8], start_date = data1)
vec_ind9 = get_series(serie[9], start_date = data1)
vec_ind10 = get_series(serie[10], start_date = data1)
vec_ind11 = get_series(serie[11], start_date = data1)
vec_ind12 = get_series(serie[12], start_date = data1)
vec_ind13 = get_series(serie[13], start_date = data1)
vec_ind14 = get_series(serie[14], start_date = data1)
vec_ind15 = get_series(serie[15], start_date = data1)
vec_ind16 = get_series(serie[16], start_date = data1)
vec_ind17 = get_series(serie[17], start_date = data1)
vec_ind18 = get_series(serie[18], start_date = data1)
vec_ind19 = get_series(serie[19], start_date = data1)
vec_ind20 = get_series(serie[20], start_date = data1)
vec_ind21 = get_series(serie[21], start_date = data1)
vec_ind22 = get_series(serie[22], start_date = data1)
vec_ind23 = get_series(serie[23], start_date = data1)

base=cbind(vec_ind1,vec_ind2[,2],vec_ind3[,2],vec_ind4[,2],vec_ind5[,2], vec_ind6[,2], vec_ind7[,2], vec_ind8[,2], vec_ind9[,2], vec_ind10[,2],vec_ind11[,2],vec_ind12[,2],vec_ind13[,2], vec_ind14[,2], vec_ind15[,2], vec_ind16[,2], vec_ind17[,2], vec_ind18[,2],vec_ind19[,2], vec_ind20[,2], vec_ind21[,2], vec_ind22[,2], vec_ind23[,2])
rm(list=objects(pattern="vec_ind[0-23]"))

# Cálculo da contribuicao:
# A função apply irá aplicar a função em cada coluna da base[,-1] (em cada série do bcb)
variacao=apply(base[,-1],2,function(x){
  variacao_YoY=rep(NA,12)
  for(i in 13:dim(base)[1]) variacao_YoY[i]=(x[i]/x[i-12])-1
  return(variacao_YoY)
})

peso=apply(base[,-1],2,function(x){
  peso=rep(NA,12)
  for(i in 13:dim(base)[1]) peso[i]=(x[i-12]/base$`20543`[i-12])
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

vec_ind1 = get_series(serie[1], start_date = data1)
vec_ind2 = get_series(serie[2], start_date = data1)
vec_ind3 = get_series(serie[3], start_date = data1)
vec_ind4 = get_series(serie[4], start_date = data1)
vec_ind5 = get_series(serie[5], start_date = data1)
vec_ind6 = get_series(serie[6], start_date = data1)
vec_ind7 = get_series(serie[7], start_date = data1)
vec_ind8 = get_series(serie[8], start_date = data1)
vec_ind9 = get_series(serie[9], start_date = data1)
vec_ind10 = get_series(serie[10], start_date = data1)
vec_ind11 = get_series(serie[11], start_date = data1)
vec_ind12 = get_series(serie[12], start_date = data1)
vec_ind13 = get_series(serie[13], start_date = data1)
vec_ind14 = get_series(serie[14], start_date = data1)
vec_ind15 = get_series(serie[15], start_date = data1)
vec_ind16 = get_series(serie[16], start_date = data1)

base2=cbind(vec_ind1,vec_ind2[,2],vec_ind3[,2],vec_ind4[,2],vec_ind5[,2], vec_ind6[,2], vec_ind7[,2], vec_ind8[,2], vec_ind9[,2], vec_ind10[,2],vec_ind11[,2],vec_ind12[,2],vec_ind13[,2], vec_ind14[,2], vec_ind15[,2], vec_ind16[,2])
rm(list=objects(pattern="vec_ind[0-16]"))

# Cálculo da contribuicao:
# A função apply irá aplicar a função em cada coluna da base[,-1] (em cada série do bcb)
variacao=apply(base2[,-1],2,function(x){
  variacao_YoY=rep(NA,12)
  for(i in 13:dim(base2)[1]) variacao_YoY[i]=(x[i]/x[i-12])-1
  return(variacao_YoY)
})

peso=apply(base2[,-1],2,function(x){
  peso=rep(NA,12)
  for(i in 13:dim(base2)[1]) peso[i]=(x[i-12]/base2$`20570`[i-12])
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

vec_ind1 = get_series(serie[1], start_date = data1)
vec_ind2 = get_series(serie[2], start_date = data1)
vec_ind3 = get_series(serie[3], start_date = data1)
vec_ind4 = get_series(serie[4], start_date = data1)
vec_ind5 = get_series(serie[5], start_date = data1)
vec_ind6 = get_series(serie[6], start_date = data1)
vec_ind7 = get_series(serie[7], start_date = data1)
vec_ind8 = get_series(serie[8], start_date = data1)
vec_ind9 = get_series(serie[9], start_date = data1)

base3=cbind(vec_ind1,vec_ind2[,2],vec_ind3[,2],vec_ind4[,2],vec_ind5[,2], vec_ind6[,2], vec_ind7[,2], vec_ind8[,2], vec_ind9[,2])
rm(list=objects(pattern="vec_ind[0-9]"))

# Cálculo da contribuicao:
# A função apply irá aplicar a função em cada coluna da base[,-1] (em cada série do bcb)
variacao=apply(base3[,-1],2,function(x){
  variacao_YoY=rep(NA,12)
  for(i in 13:dim(base3)[1]) variacao_YoY[i]=(x[i]/x[i-12])-1
  return(variacao_YoY)
})

peso=apply(base3[,-1],2,function(x){
  peso=rep(NA,12)
  for(i in 13:dim(base3)[1]) peso[i]=(x[i-12]/base3$`20594`[i-12])
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

vec_ind1 = get_series(serie[1], start_date = data1)
vec_ind2 = get_series(serie[2], start_date = data1)
vec_ind3 = get_series(serie[3], start_date = data1)
vec_ind4 = get_series(serie[4], start_date = data1)
vec_ind5 = get_series(serie[5], start_date = data1)
vec_ind6 = get_series(serie[6], start_date = data1)
vec_ind7 = get_series(serie[7], start_date = data1)
vec_ind8 = get_series(serie[8], start_date = data1)
vec_ind9 = get_series(serie[9], start_date = data1)
vec_ind10 = get_series(serie[10], start_date = data1)
vec_ind11 = get_series(serie[11], start_date = data1)

base4=cbind(vec_ind1,vec_ind2[,2],vec_ind3[,2],vec_ind4[,2],vec_ind5[,2], vec_ind6[,2], vec_ind7[,2], vec_ind8[,2], vec_ind9[,2], vec_ind10[,2], vec_ind11[,2])
rm(list=objects(pattern="vec_ind[0-11]"))

# Cálculo da contribuicao:
# A função apply irá aplicar a função em cada coluna da base[,-1] (em cada série do bcb)
variacao=apply(base4[,-1],2,function(x){
  variacao_YoY=rep(NA,12)
  for(i in 13:dim(base4)[1]) variacao_YoY[i]=(x[i]/x[i-12])-1
  return(variacao_YoY)
})

peso=apply(base4[,-1],2,function(x){
  peso=rep(NA,12)
  for(i in 13:dim(base4)[1]) peso[i]=(x[i-12]/base4$`20606`[i-12])
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