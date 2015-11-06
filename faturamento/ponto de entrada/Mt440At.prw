#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Mt440At  �Autor  �Andre Cruz          � Data �  01/10/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o dos pedidos de Venda , para que os mesmos        ���
���          � sejam liberados a partir de um valor definido por parametro���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Mt440At()

Local aArea      := GetArea()
Local cSql       := " SELECT C6_TES,SUM(C6_VALOR)TOTAL FROM " + RetSqlName("SC6") + " SC6 WHERE SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND SC6.C6_NUM = '" + M->C5_NUM + "'    GROUP BY C6_TES "
Local lRet       := .T.
Local nValMin    := GetMV("AV_VALMINF")
Local nRfret     := GetMV("AV_VALMIFR")
Local nTesBon    := GetMV("AV_TESBONI")
Local nTotal     := 0
Local cTes       := ""

DbUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery(cSql)),"TMPSC6",.F.,.T.)

TMPSC6->(dbgotop())

cTes   := TMPSC6->C6_TES  

While TMPSC6->(!Eof())

	nTotal += TMPSC6->TOTAL

	dbskip()
Enddo	
	
If (lRet := nTotal >= nRfret)
	M->C5_TPFRETE := "C"
EndIf

//Removido Amedeo (17-07-12) - Solicitado por T.I.
/*
If !(lRet := cTes $ nTesBon)
	
	If !(lRet := nTotal >= nValMin)
		Alert("Pedido Inferior a " + Transform(nValMin, "@E 999,999.99") + ". N�o � poss�vel liberar.","PEDMIN")
	EndIf
	
EndIf
*/


DbCloseArea()

RestArea(aArea)

Return lRet