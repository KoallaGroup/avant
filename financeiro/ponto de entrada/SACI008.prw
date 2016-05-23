#INCLUDE "Protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � SACI008  � Autor � Fernando Nogueira  � Data � 12/03/2015  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada posterior a contabilizacao da rotina de   ���
���          � Baixas a Receber                                           ���
�������������������������������������������������������������������������͹��
���Uso       � AVANT.                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function SACI008()

	Local aArea     := GetArea()
	Local aAreaSA6  := SA6->(GetArea())
	Local lComiss   := .T.
	
	dbSelectArea('SA6')
	dbSetOrder(01)
	dbGoTop()	
	dbSeek(xFilial('SA6')+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA)

	lComiss := SA6->A6_COMISS == 'S'	

	dbSelectArea("SE5")
	
	CONOUT(lComiss)
	CONOUT()
	
	//Modificando para DEV para nao gerar comissao na execucao do Recalculo  
	If !lComiss
		RECLOCK("SE5",.F.)
		SE5->E5_MOTBX := "DEV"
		MSUNLOCK()
	EndIf
	
	SA6->(RestArea(aAreaSA6))
	RestArea(aArea)

Return