#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSOBJECT.CH"

User Function ERWVLD01()
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Classe   � ConsVend �Autor  � Guilherme Santos   � Data �  30/11/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Classe que valida se o Usuario tambem e Vendedor.          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Class ConsVend
	Data lVendedor		//Determina se o Usuario e Vendedor
	Data cVendedor		//Codigo do Vendedor
	Data lMDI			//Verifica se eh MDI
	
	Method New()		//Inicializa o Objeto
	Method ChkVend()	//Retorna se o Usuario e' Vendedor
	Method GetVend()	//Retorna o Codigo do Vendedor
EndClass

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Metodo   � New      �Autor  � Guilherme Santos   � Data �  02/09/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Inicializa o Objeto                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Erwin Guth                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Method New() Class ConsVend
	Local aArea		:= NIL
	Local aAreaSA3	:= NIL
	Local cQuery	:= ""
	
	::lMDI		:= 	oApp:lMDI
    ::lVendedor := .F.
    ::cVendedor := ""

	If !::lMDI
		aArea		:= GetArea()
		aAreaSA3	:= SA3->(GetArea())
		cQuery		:= ""

		DbSelectArea("SA3")
		DbSetOrder(7)	//A3_FILIAL, A3_CODUSR
	
		If DbSeek(xFilial("SA3") + __cUserID)
			
			If !EMPTY(SA3->A3_GEREN)
				::lVendedor	:= .T.
				::cVendedor	:= SA3->A3_COD
		    else
			    ::lVendedor	:= .F.
				::cVendedor	:= SA3->A3_REGIAO	   
		    EndIf
		
		EndIf		
	
		RestArea(aAreaSA3)
		RestArea(aArea)

	 Else
	
		aArea		:= GetArea()
		aAreaSA3	:= SA3->(GetArea())
		cQuery		:= ""

		DbSelectArea("SA3")
		DbSetOrder(7)	//A3_FILIAL, A3_CODUSR
	
		If DbSeek(xFilial("SA3") + __cUserID)
			
			If !EMPTY(SA3->A3_GEREN)
				::lVendedor	:= .T.
				::cVendedor	:= SA3->A3_COD
		    else
			    ::lVendedor	:= .F.
				::cVendedor	:= SA3->A3_REGIAO	   
		    EndIf
		
		EndIf		
	
		RestArea(aAreaSA3)
		RestArea(aArea)
	
	EndIf

Return Self
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Metodo   � ChkVend  �Autor  � Guilherme Santos   � Data �  02/09/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna se o Usuario e' Vendedor                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Erwin Guth                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Method ChkVend() Class ConsVend
Return ::lVendedor
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Metodo   � ChkVend  �Autor  � Guilherme Santos   � Data �  02/09/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna o Codigo do Vendedor                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Erwin Guth                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Method GetVend() Class ConsVend
Return ::cVendedor
