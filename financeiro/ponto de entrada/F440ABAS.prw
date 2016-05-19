#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F440ABAS � Autor � Fernando Nogueira  � Data � 16/10/2014  ���
�������������������������������������������������������������������������͹��
���Descricao � Atualiza valor das bases de comissao quando tiver valor de ���
���          � frete que eh mantido integralmente na primeira parcela.    ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function F440ABAS()

/* ParamIXB
 [1][Codigo do Vendedor]  
 [2][Base da Comissao]                             
 [3][Base na Emissao ]                              
 [4][Base na Baixa   ]                             
 [5][Vlr  na Emissao ]                              
 [6][Vlr  na Baixa   ]                              
 [7][% da Comissao/Se "Zero" diversos %'s]
*/

Local aAreaSF2  := SF2->(GetArea())
Local cAliasSE1 := GetNextAlias()
Local aBases    := ParamIXB
Local cNota     := SE1->E1_NUM
Local cSerie    := SE1->E1_PREFIXO
Local cCliente  := SE1->E1_CLIENTE
Local cLoja     := SE1->E1_LOJA
Local cParcela  := SE1->E1_PARCELA
Local nParcela  := Val(SE1->E1_PARCELA)
Local nFrete    := Posicione("SF2",1,xFilial("SF2")+cNota+cSerie+cCliente+cLoja,"F2_FRETE")
Local _dEmisNF  := SF2->F2_EMISSAO
Local nQtdParc  := 0
Local nVlrParc  := 0
Local nVlrTit   := 0

If !Empty(cParcela) .And. nFrete > 0 .And. _dEmisNF >= CTOD("16/10/2014")   // Data que comecou a separar o frete na primeira parcela

	// Numero de Parcelas
	BeginSQL Alias cAliasSE1
		SELECT COUNT(*) QUANT_PARC FROM %table:SE1% SE1
		WHERE SE1.%notDel% 
			AND E1_FILIAL  = %Exp:xFilial("SE1")% 
			AND E1_NUM     = %Exp:cNota%
			AND E1_PREFIXO = %Exp:cSerie%
			AND E1_CLIENTE = %Exp:cCliente%
			AND E1_LOJA    = %Exp:cLoja%
	EndSQL
	
	(cAliasSE1)->(dbGoTop())
	
	nQtdParc := (cAliasSE1)->QUANT_PARC
	
	nVlrParc  := nFrete / nQtdParc

	If nParcela == 1
		aBases[1][2] -= NoRound((nQtdParc - 1) * nVlrParc, 3)
		aBases[1][4] -= NoRound((nQtdParc - 1) * nVlrParc, 3)		
	Else
		aBases[1][2] += NoRound(nVlrParc, 3)
		aBases[1][4] += NoRound(nVlrParc, 3)		
	Endif
	
	aBases[1][6] := NoRound((aBases[1][2] * aBases[1][7]) / 100, 3)
	
Endif
	
SF2->(RestArea(aAreaSF2))

Return aBases