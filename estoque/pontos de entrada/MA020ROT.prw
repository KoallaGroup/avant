#Include "Protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MA020ROT � Autor � Fernando Nogueira   � Data � 03/11/2015 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Ponto de Entrada para adicionar itens no menu do cadastro  ���
���          � de fornecedores                                            ���
�������������������������������������������������������������������������Ĵ��
���Utilizacao� AVANT                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MA020ROT()

Local aRotUser := {}

AAdd(aRotUser, {"Alt.Avant", "U_TelaForn" , 0, 4, 0, nil})

Return aRotUser

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � TelaForn � Autor � Fernando Nogueira   � Data � 03/11/2015 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Funcao para a tela da alteracao do Fornecedor              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function TelaForn()

Static oDlgForn
Static oButCancel
Static oButton1
Static oFont1   := TFont():New("MS Sans Serif",,020,,.T.,,,,,.F.,.F.)
Static oFont2   := TFont():New("Arial Narrow",,020,,.F.,,,,,.F.,.F.)
Static oGet1
Static cGrpTrib := Space(03)
Static oGroup1
Static oSay1
Static oSay2

dbSelectArea("SA2")
dbSetOrder(01)
If msSeek(xFilial("SA2")+SA2->A2_COD+SA2->A2_LOJA)
	cGrpTrib := SA2->A2_GRPTRIB

	DEFINE MSDIALOG oDlgForn TITLE "Fornecedor" FROM 000, 000  TO 170, 430 COLORS 0, 16777215 PIXEL

		@ 005, 005 GROUP oGroup1 TO 060, 210 OF oDlgForn COLOR 0, 16777215 PIXEL
		@ 012, 060 SAY oSay1 PROMPT "Altera��o Fornecedor" SIZE 105, 015 OF oDlgForn FONT oFont1 COLORS 0, 16777215 PIXEL
		@ 035, 020 SAY oSay2 PROMPT "Grp.Trib.:" SIZE 030, 010 OF oDlgForn FONT oFont2 COLORS 0, 16777215 PIXEL
		@ 035, 060 MSGET oGet1 VAR cGrpTrib SIZE 020, 010 OF oDlgForn COLORS 0, 16777215 PIXEL
		@ 067, 120 BUTTON oButton1 PROMPT "OK" SIZE 037, 012 OF oDlgForn ACTION (U_AltForn(cGrpTrib),oDlgForn:End()) PIXEL
		@ 067, 170 BUTTON oButCancel PROMPT "Cancelar" SIZE 037, 012 OF oDlgForn ACTION oDlgForn:End() PIXEL

	ACTIVATE MSDIALOG oDlgForn CENTERED
Endif

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � AltForn  � Autor � Fernando Nogueira   � Data � 03/11/2015 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Funcao para a alteracao do Fornecedor                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function AltForn(cGrpTrib)

If SA2->A2_GRPTRIB <> cGrpTrib 
	If SA2->(RecLock("SA2",.F.))
		SA2->A2_GRPTRIB := cGrpTrib
		SA2->(MsUnlock())
		ApMsgInfo("Fornecedor "+AllTrim(SA2->A2_NOME)+", alterado com sucesso!")
	Else
		ApMsgInfo("Registro Bloqueado")
	Endif
Endif

Return