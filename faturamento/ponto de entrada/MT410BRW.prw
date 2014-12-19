#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT410BRW �Autor  �Rodrigo Leite       � Data �  30/11/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa que filtra os clientes por vendedor no pedido de  ���
���          � vendas                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AVANT                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT410BRW()

	Local aAreaAT	:= GetArea()
	Local aAreaC5	:= SC5->(GetArea())
	Local aIndex	:= {}
	Local oConsVend	:= ConsVend():New()
	Local bFltBrw	:= NIL
	Local cFiltro	:= ""
	Local cVendedor	:= "" 
	
	If Alltrim(Upper(Substr(cUsuario,7,15)))<> "ADMINISTRADOR"
		
		If oConsVend:ChkVend()						
			cVendedor := oConsVend:GetVend()
			cFiltro	  += "SC5->C5_VEND1 == '" + cVendedor + "'" 
			CursorWait()
			bFltBrw := {|| FilBrowse("SC5", @aIndex, @cFiltro)}
			Eval(bFltBrw)
			CursorArrow()
	
	   	ElseIf !Empty(oConsVend:GetVend())	   	       			
			cVendedor := oConsVend:GetVend()
			cFiltro	  += "SC5->C5_REGIAO == '" + cVendedor + "'"
			CursorWait()
			bFltBrw := {|| FilBrowse("SC5", @aIndex, @cFiltro)}
			Eval(bFltBrw)
			CursorArrow()	
		EndIf
    EndIf
	RestArea(aAreaAT)
	RestArea(aAreaC5)

Return Nil