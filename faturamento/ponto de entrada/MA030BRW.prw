#INCLUDE "Protheus.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA030BRW  � Autor �Rodrigo Leite       � Data �  30/11/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Verifica os clientes por vandedor.                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function MA030BRW()


Private cFiltro := ""

dbselectarea("SA3")
dbsetorder(7)
If dbseek(xFilial("SA3")+__CUSERID) 

    If !EMPTY(SA3->A3_GEREN)
		cFiltro :="A1_VEND = "+"'"+ALLTRIM(SA3->A3_COD)+"'"
     Else
       	cFiltro :="A1_REGIAO = "+"'"+ALLTRIM(SA3->A3_REGIAO)+"'"
     EndIf

EndIf


Return(cFiltro)