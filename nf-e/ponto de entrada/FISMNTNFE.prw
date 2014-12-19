#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FISMNTNFE() � Autor � Fernando Nogueira  � Data �14/01/2014���
�������������������������������������������������������������������������͹��
���Descri��o � Ponto de Entrada no Monitor Faixa da NF-e                  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT                    	                    ���
���          � Chamado 000355                      	                    ���
�������������������������������������������������������������������������͹��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������͹��
���              �  /  /  �                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FISMNTNFE()

Local cIdNfe	:= PARAMIXB[1]
Local aNfeInf	:= PARAMIXB[2]
Local _cRec		:= SF3->(Recno())

// Altera o codigo 563 nos Livros Fiscais para 102
If SF3->(MsSeek(xFilial("SF3")+cIdNfe,.T.)) .And. AllTrim(SF3->F3_CODRSEF) == '563' .And. AllTrim(SF3->F3_OBSERV) == 'NF CANCELADA'
	While !SF3->(Eof()) .And. AllTrim(SF3->(F3_SERIE+F3_NFISCAL))==cIdNfe .And. AllTrim(SF3->F3_CODRSEF) == '563' .And. AllTrim(SF3->F3_OBSERV) == 'NF CANCELADA'
		If SF3->( (Left(F3_CFO,1)>="5" .Or. (Left(F3_CFO,1)<"5" .And. F3_FORMUL=="S")) .And. FieldPos("F3_CODRSEF")<>0)
			RecLock("SF3")
			SF3->F3_CODRSEF:= '102'
			MsUnlock()
		EndIf
		SF3->(dbSkip())
	End
EndIf

SF3->(DbGoTo(_cRec))

Return Nil