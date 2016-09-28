#include "protheus.ch"        
#define cBmp1 "BMPGROUP.BMP" 	//"PMSDOC"  //"FOLDER5" //"PMSMAIS"  //"SHORTCUTPLUS"
#define cBmp2 "BMPUSER.BMP" 	//"PMSEDT3" //"FOLDER6" //"PMSMENOS" //"SHORTCUTMINUS"
#include "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AXSZC()     � Autor � Fernando Nogueira  � Data �23/10/2013���
�������������������������������������������������������������������������͹��
���Descri��o � CADASTRO DE GRUPOS DE ATENDIMENTO...	  (Copy TOTVS)  	  ���
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
User Function AXSZD()

	Local nRet	:= 0
	
	Private cString
	Private cAlias		:= "SZD"
	Private cCadastro 	:= "Grupos de Atendimento"
	Private aRotina := { {"Pesquisar" 	,"AxPesqui" ,0,1} ,;
	             		 {"Visualizar"	,"AxVisual" ,0,2} ,;
	             		 {"Incluir"   	,"AxInclui" ,0,3} ,;
	             		 {"Alterar"    	,"AxAltera" ,0,4} ,;
	             		 {"Excluir"		,"AxDeleta" ,0,4} ,;
	             		 {"T�cnicos"   	,"u_GrpVincula()" ,0,5} }
	             		 
	Private cDelFunc 	:= ".T." 
	Private cString 	:= "SZU"

	DbSelectArea("SZE")
	DbSelectArea("SZD")
	DbSetOrder(1)
	
	mBrowse(6,1,22,75,"SZD",,,,,,,)

Return()
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � GrpVincula()� Autor � TOTVS SA           � Data �27/10/2011���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao que faz a vinculacao dos grupos de atendimento e os ���
���          � tecnicos                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GrpVincula()

	Local cGrpAtend	:= RTRIM(SZD->ZD_DESC)
	Local lSalvar	:= .F.
	
	Private oTree1
	Private aTree	:= {}

	DEFINE MSDIALOG oDlg TITLE "Grupos de Atendimento" FROM 301,336 TO 662,857 PIXEL
	
		@ 000,000 BITMAP oBmp FILE "BMP-TOP-PROTHEUS.BMP" Size 290,060 PIXEL OF oDlg WHEN .F. NOBORDER
		@ 065,007 TO 150,255 LABEL " Insira os T�cnicos que ir�o fazer parte deste grupo de atendimento " PIXEL OF oDlg			

		oTree1 := dbTree():New(075,010,145,252, oDlg,,,.T.)		
		oTree1:AddTree( cGrpAtend + Space(24),.T.,cBmp2,cBmp1,,,"XXXXXX") 
		oTree1:EndTree()
		LoadTree(SZD->ZD_COD)	// Carrega os itens ja salvos
		
		@ 162,087 Button "Incluir" 	ACTION ( adItens(SZD->ZD_COD) ) 		Size 037,012 PIXEL OF oDlg
		@ 162,128 Button "Excluir" 	ACTION ( ExItens(oTree1:GetCargo() )) Size 037,012 PIXEL OF oDlg
		@ 162,170 Button "Salvar" 	ACTION ( lSalvar := .T. , oDlg:End() ) 	Size 037,012 PIXEL OF oDlg
		@ 162,211 Button "Cancelar" ACTION ( oDlg:End() ) 					Size 037,012 PIXEL OF oDlg
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	IF lSalvar
		
		For u := 1 To Len(aTree)
		               	
			If aTree[u,3] == "*"
				SZE->( DbSetOrder(1) )
				If SZE->( DbSeek( xFilial("SZE") + SZD->ZD_COD + aTree[u,2] ) )
					RecLock("SZE",.F.)
						DbDelete()
					MsUnLock()
				Endif			
			Else
				SZE->( DbSetOrder(1) )
				If !SZE->( DbSeek( xFilial("SZE") + SZD->ZD_COD + aTree[u,2] ) )
					RecLock("SZE",.T.)
						SZE->ZE_FILIAL	:= xFilial("SZE")
						SZE->ZE_CODGRP	:= SZD->ZD_COD
						SZE->ZE_CODTEC	:= aTree[u,2]
						SZE->ZE_MARK	:= ""
					MsUnLock()
				Endif										
			Endif	
		
		Next		
	
	Endif


Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � AdItens()   � Autor � TOTVS SA           � Data �27/10/2011���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna os Tecnicos                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AdItens( cGrupo )

	Local cCodTec	:= ""
	Local aRet		:= {}
	Local aTecnicos	:= {}
	Local oDlgTec
		
	SZC->( DbSetOrder(1) )
	SZC->( DbGoTop() )

	While SZC->( !Eof() )
		IF SZC->ZC_STATUS == "A"
			aAdd( aTecnicos , SZC->ZC_TECID + " " + RTRIM(SZC->ZC_NOME) )						
		Endif
		SZC->( DbSkip() )
	End	

	If Len(aTecnicos) == 0
		MsgInfo("Verifique o cadastro de t�cnicos ativos para esta opera��o.",,"NO-TEC")
		Return
	Endif
	
	DEFINE MSDIALOG oDlgTec TITLE "T�cnicos" FROM 422,534 TO 573,733 PIXEL
			
		@ 002,003 LISTBOX oTecnicos Var cCodTec ITEMS aTecnicos SIZE 094,053 PIXEL OF oDlgTec		
		@ 060,018 Button "Inserir" 	ACTION ( oDlgTec:End(), AtuAddItens(cCodTec) ) Size 037,012 PIXEL OF oDlgTec
		@ 060,058 Button "Cancelar" ACTION ( oDlgTec:End() ) Size 037,012 PIXEL OF oDlgTec
	
	ACTIVATE MSDIALOG oDlgTec CENTERED 
	
Return( aRet )
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � AtuAddIten()� Autor � TOTVS SA           � Data �27/10/2011���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza Tree com o item inserido                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AtuAddItens( cTreeItem  )

	nPos := AScan(aTree,{|x| AllTrim(x[2]) == Substr(cTreeItem,1,6) })
	IF nPos > 0 .And. aTree[nPos,3] != "*"
		MsgInfo("T�cnico j� cadastrado !",,"INFO")	
		Return
	Endif

	oTree1:TreeSeek("XXXXXX")
	oTree1:AddItem(cTreeItem,Substr(cTreeItem,1,6),cBmp2,cBmp2,,,2)
	oTree1:EndTree()
	
	If nPos > 0
		aTree[nPos,3] := ""
	Else
		aAdd( aTree , { cTreeItem , Substr(cTreeItem,1,6) , "" } )
	Endif
	
Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � ExItens()   � Autor � TOTVS SA           � Data �27/10/2011���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao Auxiliar				                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ExItens( cTreeItem  )

	IF cTreeItem == "XXXXXX"
		MsgInfo("N�o � permitido excluir o grupo de atendimento principal.",,"INFO")
		Return
	Endif

	oTree1:TreeSeek(cTreeItem)
	oTree1:DelItem()
	oTree1:EndTree()
	oTree1:Refresh()
	
	nPos := AScan(aTree,{|x| x[2] == cTreeItem })
	If nPos != 0
		aTree[nPos,3] := "*"
	Endif

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � LoadTree()  � Autor � TOTVS SA           � Data �27/10/2011���
�������������������������������������������������������������������������͹��
���Desc.     � Carrega os itens ja salvos do grupo em questao             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function LoadTree( cGrupo )

	SZC->( DbSetOrder(1) )
	SZE->( DbSetOrder(1) )	
	
	IF SZE->( DbSeek( xFilial("SZE") + cGrupo ) )   	
		While SZE->( !Eof() ) .And. SZE->ZE_CODGRP == cGrupo		
			IF SZC->( DbSeek( xFilial("SZC") + SZE->ZE_CODTEC ) )
				oTree1:TreeSeek("XXXXXX")
				oTree1:AddItem( SZC->ZC_TECID + " " + RTRIM(SZC->ZC_NOME) , SZC->ZC_TECID ,cBmp2,cBmp2,,,2)
				oTree1:EndTree()				
				aAdd( aTree , { SZC->ZC_TECID + " " + RTRIM(SZC->ZC_NOME) , SZC->ZC_TECID , "" } )
			Endif		
			SZE->( DbSkip() )			
		End			
		oTree1:Refresh()		
	Endif

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RetAlocId() � Autor � TOTVS SA           � Data �27/10/2011���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao que faz a alocacao automatica de acordo com os grupos���
���          �de atendimento cadastrados                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RetAlocID( cCodMotivo )
                                                
	Local cProxTec	:= "AUTOMA"
	Local lAlocado	:= .F.
	Local aGetAli	:= GetArea()
	
	SZB->( DbSetOrder(1) )
	IF SZB->( DbSeek( xFilial("SZB") + cCodMotivo ) )
			
		//�����������������������������������������������������������������Ŀ
		//� Caso a ocorrencia nao possua um grupo de atendimento associado  �
		//� retorna a alocadao padrao                                       �
		//�������������������������������������������������������������������
		IF EMPTY(SZB->ZB_CODGRP)
			RestArea( aGetAli )
			Return( cProxTec )
		Else
			cCodGrp	:= SZB->ZB_CODGRP
		Endif		
		
		//������������������������������������������������������Ŀ
		//� Primeiro verifica a ordem e se existe alguem na fila �
		//��������������������������������������������������������
		SZE->( DbSetOrder(2) )
		IF SZE->( !DbSeek( xFilial("SZE") + cCodGrp + "*" ) )
				
			//������������������������������������������Ŀ
			//� Fila Zerada - Inicio do primeiro tecnico �
			//��������������������������������������������
			SZE->( DbSetOrder(1) )
			IF SZE->( DbSeek( xFilial("SZE") + cCodGrp ) )
				While SZE->( !Eof() ) .And. SZE->ZE_CODGRP == cCodGrp .And. !lAlocado
					lAlocado	:= .T.
					cProxTec 	:= SZE->ZE_CODTEC
					RecLock("SZE",.F.)
						SZE->ZE_MARK := "*"
					MsUnLock()
					SZE->( DbSkip() )
				End
			Endif
		
		Else
				
			//���������������������������������������������8�
			//� Fila em curso - Verifica o Proximo Tecnico �
			//���������������������������������������������8�
			nRecSZE := SZE->( Recno() )
			RecLock("SZE",.F.)
				SZE->ZE_MARK := ""
			MsUnLock()
			
			SZE->( DbSetOrder(1) )
			SZE->( DbGoTo( nRecSZE ) )

			While SZE->( !Eof() ) .And. SZE->ZE_CODGRP == cCodGrp .And. !lAlocado			
			
				SZC->( DbSetOrder(1) )
 				SZC->( DbSeek( xFilial("SZC") + SZE->ZE_CODTEC ) )				
			
				IF SZE->( Recno() ) != nRecSZE .And. !lAlocado .And. SZC->ZC_STATUS == "A"
					lAlocado	:= .T.
					cProxTec	:= SZE->ZE_CODTEC
					RecLock("SZE",.F.)
						SZE->ZE_MARK := "*"
					MsUnLock()
				Endif				
				SZE->( DbSkip() )
				
				// Volta para o inicio da Lista
				IF !lAlocado .And. SZE->ZE_CODGRP != cCodGrp
					nRecSZE := 9999999999999999999
					SZE->( DbGoTop() )
					Loop
				Endif
				
			End
			
		
		Endif
		
	Endif
	
	IF !lAlocado
		CONOUT( "Alocacao automatica nao realizada" )
	Else
		CONOUT( "Alocacao realizada para o Tecnico" + cProxTec )
	Endif

Return( cProxTec )