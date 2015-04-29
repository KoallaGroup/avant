#Include "Protheus.Ch"
#Define ENTER 	Chr(13)+Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � UsrMenu()   � Autor � Fernando Nogueira  � Data �23/10/2013���
�������������������������������������������������������������������������͹��
���Descri��o � Menu do Tecnico... Baseado nos fontes da TOTVS...	   	  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                   	                      ���
�������������������������������������������������������������������������͹��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������͹��
���              �  /  /  �                                               ���
���              �  /  /  �                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function UsrMenu()

	Local nRet	:= 0
	Local aArea := GetArea()
	Local aInd  := {}
	Local cCond := "ZU_CODUSR == '"+Alltrim(RetCodUsr())+"' .OR. ZU_CODSUP == '"+Alltrim(RetCodUsr())+"'"

	Private cString
	Private cAlias	  := "SZU"
	Private cCadastro := "Atendimento Continuado - Chamados"
	Private aRotina   := { {"Pesquisar" ,"AxPesqui"    ,0,1} ,;
	             	       {"Visualizar","u_WEB270EDIT",0,2} ,;
	             		   {"Incluir"   ,"u_WEB270EDIT",0,3} ,;
	             		   {"Editar"    ,"u_WEB270EDIT",0,4} ,;
	             		   {"Legenda"   ,"u_acr_Legnda",0,5} ,;
	             		   {"Hist�rico" ,"u_LJVERHIST" ,0,5} ,;
	             		   {"Reabertura","u_RejeitaCHM",0,5} }

	Private cDelFunc 	:= ".T." 
	Private cString 	:= "SZU"

	aCores := {}

	aAdd( aCores, { "ZU_STATUS == 'A'" , "BR_VERDE" })
	aAdd( aCores, { "ZU_STATUS == 'F'" , "BR_AMARELO" })
	aAdd( aCores, { "ZU_STATUS == 'C'" , "BR_CINZA" })
	aAdd( aCores, { "ZU_STATUS == 'E'" , "BR_AZUL" })
	aAdd( aCores, { "ZU_STATUS == 'T'" , "BR_PINK" })

//	ChkFile("SZU")
	
	DbSelectArea("SZU")
	DbSetOrder(2)

	bFiltraBrw := {|| FilBrowse("SZU",@aInd,@cCond) }
	Eval(bFiltraBrw)

	mBrowse(6,1,22,75,"SZU",,,,,,aCores,)

	DbSelectArea("SZU")
	RetIndex("SZU")
	DbClearFilter()
	aEval(aInd,{|x| FErase(x[1]+OrdBagExt())})
	RestArea(aArea)

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RejeitaCHM()� Autor � Fernando Nogueira  � Data �23/10/2013���
�������������������������������������������������������������������������͹��
���Descri��o � Efetua gravacao do complemento e informa status p\ usuario.���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                   	                      ���
�������������������������������������������������������������������������͹��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������͹��
���              �  /  /  �                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RejeitaCHM()

	Local oButton1
	Local oGroup1
	Local nOpc      := 0
	Local c_Memo_Ok := ''
	Static oDlg
	
	If SZU->ZU_STATUS == 'A'//Chamado aberto
		msgStop('O Status atual do chamado � "Em Aberto". N�o � poss�vel reabertura deste chamado.')
	ElseIf SZU->ZU_STATUS == 'E'//Chamado em an�lise
		msgStop('O Status atual do chamado � "Em Analise". N�o � poss�vel reabertura deste chamado.')
	ElseIf SZU->ZU_STATUS == 'T'//Chamado transferido
		msgStop('O Status atual do chamado � "Trasferido". N�o � poss�vel reabertura deste chamado.')
	ElseIf RetCodUsr() <> SZU->ZU_CODUSR
		msgStop('Este Chamado pertence a outro usuario. N�o � poss�vel reabertura deste chamado.')
	Else

		DEFINE MSDIALOG oDlg TITLE "Reabertura do Chamado" FROM 000, 000  TO 125, 670 PIXEL

			@ 002, 003 SAY "Motivo" SIZE 076,07 OF oDlg PIXEL		
//			@ 008, 004 GROUP oGroup1 TO 042, 332 OF oDlg PIXEL
			@ 010, 005 GET oMemo VAR c_Memo_Ok MEMO SIZE 326,031 OF oDlg PIXEL
		    @ 047, 292 BUTTON oButton1 PROMPT "&Confirmar" SIZE 037, 012 PIXEL OF oDlg ACTION(If(!Empty(c_Memo_Ok),(nOpc :=1,oDlg:End()),msgStop("Informe o Motivo!")))//Action((nOpc :=1,oDlg:End()))
		
		ACTIVATE MSDIALOG oDlg CENTERED   
	    
		If nOpc == 1

			Begin Transaction
				DbSelectArea("SZU")
				RecLock("SZU",.F.)
					SZU->ZU_STATUS	:= "E"
					SZU->ZU_DATAOK	:= CTOD("")
					SZU->ZU_HROK	:= ""
					SZU->ZU_DTCONF	:= CTOD("")
					SZU->ZU_HRCONF	:= ""
				MsUnLock()
				
				DbSelectArea("SZV")
				RecLock( "SZV" , .T. )
					SZV->ZV_FILIAL	:= xFilial("SZV")
					SZV->ZV_CHAMADO	:= SZU->ZU_CHAMADO
					SZV->ZV_DATA	:= ddatabase
					SZV->ZV_TIPO	:= '010'
					SZV->ZV_CODSYP	:= u_GrvMemo( c_Memo_Ok+ENTER+'Rejei��o do chamado em '+dToc(Date())+ ' (retorno negativo da solu��o)          '+ENTER+ENTER+'[Contato: '+alltrim(SZU->ZU_NOMEUSR)+']' , "ZV_CODSYP" )
					SZV->ZV_NUMSEQ	:= u_RetZVNum( SZU->ZU_CHAMADO )
					SZV->ZV_HORA	:= Time()
					SZV->ZV_TECNICO	:= "AUTO"
				MsUnLock()
			End Transaction
		
			u_OpenProc(SZU->ZU_CHAMADO,'C')

		EndIf
					
	EndIf		

Return(.T.)