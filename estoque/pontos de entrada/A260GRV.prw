#Include "Protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � A260GRV  � Autor � Fernando Nogueira   � Data � 20/08/2014 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Ponto de Entrada - Validacao da Transferencia              ���
�������������������������������������������������������������������������Ĵ��
���Utilizacao� AVANT                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function A260GRV()

Local _lReturn    := .T.
Local aAreaSB1    := SB1->(GetArea())
Local cCtrEndDest := Posicione("SB1",1,xFilial("SB1")+cCodDest,"B1_LOCALIZ")

If !Empty(cLoclzOrig) .And. Empty(cLoclzDest) .And. cCtrEndDest == 'S'
	ApMsgAlert('Obrigat�rio o preenchimento do endere�o destino')
	_lReturn := .F.
ElseIf cLocOrig <> cLocDest .And. !(cLocOrig $ AllTrim(GetMV("ES_LOCORIG")) .And. cLocDest $ AllTrim(GetMV("ES_LOCDEST")))
	ApMsgAlert('Transfer�ncia entre Armaz�ns est� proibida')
	_lReturn := .F.
Endif

SB1->(RestArea(aAreaSB1))

Return _lReturn