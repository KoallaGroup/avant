#INCLUDE "Protheus.CH"

/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � MT410CPY � Autor � Fernando Nogueira  � Data � 21/11/2014 ���
������������������������������������������������������������������������͹��
���Descricao � Alteracao do acols e de variaveis da enchoice antes da    ���
���          � copia do Pedido de Vendas.                                ���
������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                          ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/

User Function MT410CPY()

Local nPosTES  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"})
Local nPosCFOP := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_CF"})
Local cTamTES  := Space(TamSx3("C6_TES")[1])
Local cTamCFOP := Space(TamSx3("C6_CF")[1])

// Fernando Nogueira - Chamado 001857
For J := 1 To Len(aCols)
	aCols[J,nPosTES]  := cTamTES
	aCols[J,nPosCFOP] := cTamCFOP
Next J

M->C5_VOLUME1 := 0
M->C5_PEDWEB  := 0

Return