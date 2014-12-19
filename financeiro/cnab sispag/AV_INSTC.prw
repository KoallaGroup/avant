#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AV_INSTC � Autor � Amedeo D. P. Filho � Data �  02/04/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Retorna instrucoes de Protesto na geracao do arquivo CNAB  ���
���          � Conforme Banco / Cliente.                                  ���
���          �                                                            ���
���          � Parametros                                                 ���
���          � ExpC1 - 1 = Protesta ou Nao / 2 = Dias de Protesto         ���
�������������������������������������������������������������������������͹��
���Uso       � AVANT.                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AV_INSTC(cTipo)
    Local cRetorno	:= "00"
	Local lBrades	:= Alltrim(SE1->E1_PORTADO) == "237"
	Local lItau		:= Alltrim(SE1->E1_PORTADO) == "341"
	Local lBrasil	:= Alltrim(SE1->E1_PORTADO) == "001"
	
	DbSelectarea("SA1")
	SA1->(DbSetorder(1))
	SA1->(MsSeek(xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA))
	
	//�������������������������������������Ŀ
	//� Tipo 1 = Instrucao no Arquivo.    	�             
	//���������������������������������������
	If cTipo == "1"
		If SA1->A1_X_PROT == "S"
			If lBrades .Or. lBrasil
				cRetorno := "06"
			ElseIf lItau
				cRetorno := "09"
			EndIf
			
		EndIf

	//�������������������������������������Ŀ
	//� Tipo 2 = Dias para Protesto.      	�
	//���������������������������������������
	ElseIf cTipo == "2"
		If SA1->A1_X_DIASP > 0 .And. SA1->A1_X_PROT == "S"
			cRetorno := StrZero(SA1->A1_X_DIASP,2)
		EndIf
	EndIf
	
Return cRetorno