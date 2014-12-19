#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MBRWBTN  � Autor � Amedeo D. P. Filho � Data �  24/07/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada nos Botoes das MBrowses.                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MBRWBTN()
	Local cAlias	:= PARAMIXB[1] // Alias
	Local nRec		:= PARAMIXB[2] // Recno
	Local nBotao	:= PARAMIXB[3] // Qual botao ou opcao foi selecionada
	Local aAreaAT	:= GetArea()
	Local lRetorno	:= .T.

	//�����������������������������������Ŀ
	//� Rotina de Compensacao             �
	//�������������������������������������
	If AllTrim(FunName()) == "MATA410"
		If nBotao == 9	// Botao Prepara DOC. de Saida
			If Alltrim(Upper(cUserName)) $ "ADMINISTRADOR" .or. Alltrim(Upper(cUserName)) $ "wms"
				lRetorno := .F.
				Alert("Voc� n�o tem permiss�o para acessar essa Rotina, Contate Suporte")
			EndIf
		EndIf
	EndIf
	
	RestArea(aAreaAT)
	
Return lRetorno