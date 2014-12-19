#INCLUDE "Protheus.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA410   � Autor � Fernando Nogueira  � Data �  16/09/2014 ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada na validacao da confirmacao do Pedido de  ���
���          � Vendas                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MTA410()

Local nPosTot    := aScan(aHeader,{|x|Trim(x[2])=="C6_VALOR"})
Local nPosProd   := aScan(aHeader,{|x|Trim(x[2])=="C6_PRODUTO"})
Local nPosCF     := aScan(aHeader,{|x|Trim(x[2])=="C6_CF"})
Local nSomaTot   := 0
Local cEstFrete  := Posicione("SX5",1,xFilial("SX5")+"ZA"+"0002","X5_DESCRI")
Local nVlrFrete  := 0
Local aAreaSA1   := SA1->(GetArea())
Local cEstado    := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_EST")
Local cPessoa    := SA1->A1_PESSOA
Local cHabFrete  := SA1->A1_X_HBFRT
Local lFlag      := .F.

If Inclui .Or. Altera	
	For nI := 1 to Len(aCols)
		If !aCols[nI,Len(aHeader)+1]
			If nI == 1
				If Posicione("SB1",1,xFilial("SB1")+aCols[nI][nPosProd],"B1_UTLCOMS") == "N"
					lFlag := .T.
				Endif
			Else 
				If Posicione("SB1",1,xFilial("SB1")+aCols[nI][nPosProd],"B1_UTLCOMS") <> Posicione("SB1",1,xFilial("SB1")+aCols[nI-1][nPosProd],"B1_UTLCOMS")
					MsgAlert('Existe conflito de produtos que geram comiss�o com produtos que n�o geram! Ser� necess�rio fazer pedidos separados.', 'Aten��o')
					Return .F.
				Endif
			EndIf
			// Bonificacao (910) e Troca (949) nao entram na regra
			If !(Right(AllTrim(aCols[nI,nPosCF]),3) $ "910.949")
				nSomaTot += aCols[nI,nPosTot]
			EndIf
		Endif
	Next nI
	
	If lFlag
		M->C5_VEND1  := Space(6)
		M->C5_VEND2  := Space(6)
		M->C5_COMIS1 := 0
		M->C5_COMIS2 := 0
	Endif
	
	If nSomaTot > 0 .And. nSomaTot < 1500 .And. cEstado $ cEstFrete .And. M->C5_TPFRETE == "C" .And. cPessoa <> "F"
		nVlrFrete := Val(Substr(cEstFrete,At(cEstado,cEstFrete)+2,6))/100
	Endif
	
	// Definir o Valor do Frete
	If cHabFrete == "S"
		M->C5_FRETE := nVlrFrete
	Else
		M->C5_FRETE := 0
	Endif	
Endif

SA1->(RestArea(aAreaSA1))

Return .T.
