#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ERWCLI01 �Autor  � Guilherme Santos   � Data �  02/09/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Consulta Especifica de Clientes                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Erwin Guth                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ERWCLI01()
	
	Local oConsVend	:= ConsVend():New()// valida cliente por vendedor
	Local oDlg		:= NIL
	Local oBrowse	:= NIL
	Local oBusca	:= NIL
	Local oBtnP		:= NIL
	Local oCombo	:= NIL

	Local cBusca	:= Space(100)
	Local cDlgTit	:= "Cadastro de Clientes"
	Local cDlgTab	:= "SA1"
	Local cVendedor	:= ""
	Local cIndice	:= "1"

	Local aCpoTit	:= {"Codigo", "Loja" ,"Nome", "N Fantasia", "CNPJ/CPF"}
	Local aCpoCols	:= {30, 20, 70, 40, 40}
	Local aCampos	:= {SA1->A1_COD, SA1->A1_LOJA, SA1->A1_NOME, SA1->A1_NREDUZ, SA1->A1_CGC}
	Local aIndices	:= {"Codigo", "Nome", "CNPJ/CPF", "N Fantasia"}

	Local lRetorno	:= .T.

	Local cBloco	:= ""
	Local cCondicao	:= ""

	Local bBlocoOk	:= {|| (lRetorno := .T., oDlg:End())}

	DbSelectArea("SA1")
	DbSetOrder(1)		//A1_FILIAL, A1_COD, A1_LOJA
	DbGoTop()
	
	If oConsVend:ChkVend()
		cCondicao += "SA1->A1_FILIAL == xFilial('SA1') .AND. (SA1->A1_VEND == '" + oConsVend:GetVend() + "')" //.OR. "
//		cCondicao += " SA1->A1_VEND2 == '" + oConsVend:GetVend() + "' .OR. "
//		cCondicao += " SA1->A1_VEND3 == '" + oConsVend:GetVend() + "' .OR. "
//		cCondicao += " SA1->A1_VEND4 == '" + oConsVend:GetVend() + "' .OR. "
//		cCondicao += " SA1->A1_VEND5 == '" + oConsVend:GetVend() + "') "
        
        cBloco := "{ || " + cCondicao + " }"
		dbSetFilter( &cBloco,  cCondicao )

       	ElseIf !Empty(oConsVend:GetVend())	   	       			
	    cCondicao += "SA1->A1_FILIAL == xFilial('SA1') .AND. (SA1->A1_REGIAO == '" + oConsVend:GetVend() + "')"
        cBloco := "{ || " + cCondicao + " }"
		dbSetFilter( &cBloco,  cCondicao )
	EndIf

	//������������Ŀ
	//�Monta a Tela�
	//��������������
	
	DEFINE MSDIALOG oDlg TITLE cDlgTit From C(001), C(001) To C(025), C(060) OF oMainWnd
	
	@ C(005), C(005) MSCOMBOBOX oCombo VAR cIndice ITEMS aIndices SIZE C(160), C(007) PIXEL OF oDlg ON CHANGE CliRefr(oBrowse, oCombo)
	@ C(020), C(005) MSGET oBusca VAR cBusca SIZE C(160), C(007) PIXEL OF oDlg
	@ C(005), C(170) BUTTON oBtnP PROMPT "&Pesquisar" SIZE C(050), C(009) PIXEL ACTION CliPesq(oCombo, cBusca) MESSAGE "Pesquisar" OF oDlg

	oBrowse := TWBrowse():New(C(035), C(005), C(220), C(120), {|| {aCampos}}, aCpoTit, aCpoCols, oDlg,,,,,,,,,,,,, cDlgTab, .T.)
	
	oBrowse:bLine := {|| {SA1->A1_COD, SA1->A1_LOJA, SA1->A1_NOME, SA1->A1_NREDUZ, SA1->A1_CGC}}
	
	oBrowse:Refresh()
	
	oBrowse:bLDblClick := bBlocoOk
	
	DEFINE SBUTTON FROM C(160), C(010) TYPE 01 ACTION (lRetorno := .T., oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM C(160), C(040) TYPE 02 ACTION (lRetorno := .F., oDlg:End()) ENABLE OF oDlg

	//Verifica se o Usuario pode Incluir dados via F3(24) e se pode Alterar o Cliente(143)
	If Substr(cAcesso, 24, 1) == "S" .AND. Substr(cAcesso, 143, 1) == "S"
		DEFINE SBUTTON FROM C(160), C(070) TYPE 04 ACTION CliIncl() ENABLE OF oDlg
	EndIf

	DEFINE SBUTTON FROM C(160), C(100) TYPE 15 ACTION CliVisu() ENABLE OF oDlg
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
Return lRetorno
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CliIncl  �Autor  � Guilherme Santos   � Data �  02/09/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Inclui um novo Cliente                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Erwin Guth                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CliIncl()
	AxInclui("SA1", 0, 3)
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CliIncl  �Autor  � Guilherme Santos   � Data �  02/09/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Visualiza o Cliente                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Erwin Guth                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CliVisu()
	AxVisual("SA1", SA1->(Recno()), 2)
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CliPesq  �Autor  � Guilherme Santos   � Data �  02/09/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Realiza a Pesquisa da Consulta Especifica                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Erwin Guth                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CliPesq(oCombo, cBusca)
	Local nIndice := oCombo:nAt
	Local nRecno  := 0
	
	If oCombo:nAt == 4
		nIndice := 5
	EndIf

	DbSelectArea("SA1")
	DbSetOrder(nIndice)
	If DbSeek(xFilial("SA1") + AllTrim(cBusca))
		nRecno := SA1->(Recno())
		DbSetOrder(1)
		DbGoTo(nRecno)
	EndIf

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CliRefr  �Autor  � Guilherme Santos   � Data �  02/09/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza a tela da consulta conforme o Indice Selecionado  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Erwin Guth                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CliRefr(oBrowse, oCombo)
	Local nIndice := oCombo:nAt
	
	If oCombo:nAt == 4
		nIndice := 5
	EndIf

	DbSelectArea("SA1")
	DbSetOrder(nIndice)

	oBrowse:Refresh()
Return Nil
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   C()      � Autor � Norbert Waage Junior  � Data �10/05/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolu��o horizontal do Monitor do Usuario.                  ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function C(nTam)
	Local nHRes	:=	GetScreenRes()[1]	//Resolucao horizontal do monitor
	
	Do Case
	Case nHRes == 640	//Resolucao 640x480
		nTam *= 0.8
	Case nHRes == 800	//Resolucao 800x600
		nTam *= 1
	OtherWise			//Resolucao 1024x768 e acima
		nTam *= 1.28
	End Case
	
	//���������������������������Ŀ
	//�Tratamento para tema "Flat"�
	//�����������������������������
	If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()
		nTam *= 0.90
	EndIf
Return Int(nTam)