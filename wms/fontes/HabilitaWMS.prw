#Include "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HabilitaWMS()� Autor � Fernando Nogueira  � Data �06/05/2014���
�������������������������������������������������������������������������͹��
���Descricao � Habilita inclusao automatica de servico WMS                ���
���          � Chamado 001172                                             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                                          ���
�������������������������������������������������������������������������͹��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������͹��
���              �  /  /  �                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HabilitaWMS()                                      

Local cMensHab := 'Inclus�o Autom�tica de Servi�o WMS Habilitada'
Local cMensDes := 'Inclus�o Autom�tica de Servi�o WMS Desabilitada'
Local bHabWMS  := {||SX5->(RecLock("SX5",.F.)),SX5->X5_DESCRI:=cValToChar(lCheckBoxWMS),SX5->(MsUnlock()),If(lCheckBoxWMS,MsgInfo(cMensHab),MsgInfo(cMensDes)),oDlgWMS:End()}

Static oDlgWMS
Static oButCancela
Static oButConfirma
Static lCheckBoxWMS := .F.
Static oCheckBoxWMS
Static oFont1 := TFont():New("Arial",,020,,.T.,,,,,.F.,.F.)
Static oFont2 := TFont():New("Arial",,017,,.T.,,,,,.F.,.F.)
Static oGroup1
Static oSayWMS

lCheckBoxWMS := U_VerServWMS()

  DEFINE MSDIALOG oDlgWMS TITLE "Habilita WMS" FROM 000, 000  TO 160, 600 COLORS 0, 16777215 PIXEL

    @ 005, 005 GROUP oGroup1 TO 056, 295 PROMPT "Habilita WMS" OF oDlgWMS COLOR 0, 16777215 PIXEL
    @ 017, 010 SAY oSayWMS PROMPT "Habilita inclus�o autom�tica de servi�o WMS nos Pedidos de Vendas" SIZE 275, 014 OF oDlgWMS FONT oFont1 COLORS 0, 16777215 PIXEL
    @ 035, 010 CHECKBOX oCheckBoxWMS VAR lCheckBoxWMS PROMPT "Habilitado" SIZE 050, 008 OF oDlgWMS COLORS 0, 16777215 FONT oFont2 PIXEL
    @ 063, 200 BUTTON oButConfirma PROMPT "Confirma" SIZE 037, 012 ACTION(Eval(bHabWMS)) OF oDlgWMS FONT oFont2 PIXEL
    @ 063, 250 BUTTON oButCancela PROMPT "Cancela" SIZE 037, 012 ACTION(oDlgWMS:End()) OF oDlgWMS FONT oFont2 PIXEL
  ACTIVATE MSDIALOG oDlgWMS CENTERED

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VerServWMS()� Autor � Fernando Nogueira  � Data �16/12/2013���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica se a Inclusao de Servico WMS esta ativa           ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                   	                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VerServWMS()

Local lCheckBoxWMS := .F.
Local aArea:= GetArea()

DbSelectArea('SX5')
DbSetOrder(1)
DbGotop()

lCheckBoxWMS := &(Posicione("SX5",1,xFilial("SX5")+"ZA0001","X5_DESCRI"))

RestArea(aArea)

Return lCheckBoxWMS