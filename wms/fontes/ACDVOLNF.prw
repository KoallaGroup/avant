#INCLUDE "PROTHEUS.CH"
#INCLUDE "APVT100.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ACDVOLNF � Autor � Fernando Nogueira  � Data � 02/03/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Alteracao de Volume da Nota Fiscal Via Coletor.            ���
���          � Chamado 002640                                             ���
�������������������������������������������������������������������������͹��
���Uso       � AVANT                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ACDVOLNF()

	Private nVolumes := 0
	Private nVolAtu	  := 0
	Private cNota  := Space(09)
	
	VtClear()
	
	@ 01,00 VTSay "Numero da NF"
	@ 02,00 VTGet cNota Valid(ValidNF(cNota))
	
	VTRead
	
	If VTLastKey() == 27
		Return Nil
	EndIf
	
	VtClear()
	
	@ 01,00 VTSay "NF:" + SF2->F2_DOC		
	@ 02,00 VTSay "Qtd Volumes Atual"
	@ 03,00 VTGet nVolAtu When .F.
	@ 04,00 VTSay "Qtd Volumes Novo"
	@ 05,00 VTGet nVolumes Valid(nVolumes > 0)
	
	VTRead
	
	If VTLastKey() == 27
		Return Nil
	EndIf
	
	If SF2->(RecLock("SF2",.F.))
		If SF2->F2_VOLUME1 == nVolumes
			VtAlert("A quantidade de volumes eh igual, nao foi preciso alterar","Aviso",.T.,4000,3)
		Else
			SF2->F2_VOLUME1	:= nVolumes
			VtAlert("Qtd de Volumes da NF "+SF2->F2_DOC+" Alterada","Aviso",.T.,4000,3)
		Endif
		SF2->(MsUnlock())
	Else
		VtAlert("Registro Bloqueado","Aviso",.T.,4000,3)
	Endif
	
Return Nil

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  � ValidNF   � Autor � Fernando Nogueira  � Data  � 02/03/2016 ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Valida Nota Fiscal                                          ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function ValidNF(cNota)
	Local lRetorno := .T.

	DbSelectarea("SF2")
	SF2->(DbSetorder(01))
	If !SF2->(DbSeek(xFilial("SF2") + cNota))
		VtAlert("NF " + cNota + "N�o Encontrada","Aviso",.T.,4000,3)
		lRetorno := .F.
	Else
		If !Empty(SF2->F2_CHVNFE)
			VtAlert("NF " + cNota + " ja foi transmitida","Aviso",.T.,4000,3)
			lRetorno := .F.
		Else
			nVolAtu := SF2->F2_VOLUME1
		Endif
	EndIf
	
Return lRetorno