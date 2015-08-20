#INCLUDE "PROTHEUS.CH"         

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CADSZ5   � Autor � Amedeo D. P. Filho � Data �  09/04/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de Pre-Clientes (AVANT)                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Avant                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CADSZ5()

	Local aFiltro		:= {"1-Processados","2-N�o Processados","3-Todas"}
	Local aIndArqu  	:= {}
	Local aPerg    		:= {}
	Private cCadastro 	:= "Cadastro de Pr�-Cliente (AVANT)"
	Private aRotina		:= {}
	Private aCores		:= {}

	Private cCondicao 	:= ""
	Private bFiltraBrow
	
	Private aRotina	:=	{ 	{"Pesquisar","AxPesqui"		,0	,1} ,;
								{"Visualizar"	,"AxVisual"		,0	,2} ,;
								{"Alterar"		,"AxAltera"		,0 ,4} ,;
								{"Excluir"		,"AxDeleta"		,0 ,5} ,;
			             	{"Importa Cad.","U_CADSZ5IMP"	,0	,3} ,;
			             	{"Legenda"		,"U_CADSZ5LEG"	,0	,5} }

	aCores := {	{"Z5_STATUS == 'S'"	,'ENABLE'      },;	//Verde Importado
				{"Z5_STATUS == 'N'"	,'DISABLE'     }}	//Vermelho Pendente para Importacao

	//������������������������������������������Ŀ
	//�Define as Perguntas na Abertura do Browse �
	//��������������������������������������������
	Aadd(aPerg,{2,"Filtro"		,"",aFiltro	,120,".T.",.T.,".T."})

	//������������������������������������������Ŀ
	//�Chama tela de Parametros                  �
	//��������������������������������������������
	If ParamBox(aPerg,"",,,,,,,,"CADSZ5",.T.,.T.)

		cCondicao += " Z5_FILIAL == '"+xFilial("SZ5")+"' "

		If SubStr(MV_PAR01,1,1) == "1"
			cCondicao += " .AND. Alltrim(Z5_STATUS) == 'S' "
		ElseIf SubStr(MV_PAR01,1,1) == "2"
			cCondicao += " .AND. Alltrim(Z5_STATUS) == 'N' "
		EndIf

		bFiltraBrow := {|| FilBrowse("SZ5",@aIndArqu,@cCondicao) }
		Eval(bFiltraBrow)				

		 MBrowse( 6, 1,22,75,"SZ5",,,,,,aCores) 

		DbSelectArea("SZ5")
		RetIndex("SZ5")
		DbClearFilter()
		aEval(aIndArqu,{|x| Ferase(x[1]+OrdBagExt())})			
    
    EndIF
    
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADSZ5LEG � Autor � Amedeo D. P. Filho � Data �  09/04/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Legenda do Cadastro de Pre-Clientes (AVANT)               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Avant                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CADSZ5LEG()

	BrwLegenda(cCadastro,"Legenda",{	{"ENABLE"	,"Cadastro Importado"},; 	
	                                    {'DISABLE' 	,"Cadastro Pendente para Importa��o" }})

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADSZ5IMP � Autor � Amedeo D. P. Filho � Data �  09/04/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Importa Clientes Web                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Avant                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CADSZ5IMP(cAlias, nRecno, nOpc)
	Local lACAtivo  	:= GetNewPar("MV_ACATIVO", .F.)
	Local aButtons  	:= {}
	Local aValues		:= {}
    Local cTipoCli		:= "F"
    Local cAliasA1		:= ""
    Local cCgcCad		:= ""
    Local cCodCli		:= ""
    Local cLojaCli		:= ""
    Local cEndCli		:= ""
    Local cEndCob		:= ""
    Local cEndEnt		:= ""
    Local cCodPa		:= ""
	Local lAchou		:= .F.
	Local nOpc			:= 3
	
	Local _cTipo	    := ""
	Local _cGRPTRIB	    := ""
	    
	Private aRotAuto 	:= Nil
	Private lMsErroAuto := .F.

	DbSelectarea("SZ5")
	SZ5->(DbGoto(nRecno))
	If SZ5->Z5_STATUS <> "N"
		Aviso("Aviso","Esse cadastro n�o est� com Status para ser Importado",{"Abandona"},1,"Verifique")
		Return Nil
	EndIf
	
	//�����������������������������������������������������Ŀ
	//� Verifica se ja Existe no Cadastro de Clientes		�
	//�������������������������������������������������������
	DbSelectarea("SA1")
	SA1->(DbSetorder(3))
	If SA1->(DbSeek(xFilial("SA1") + SZ5->Z5_CGC))
		Aviso("Aviso",	"Cliente do CNPJ/CPF: " + SZ5->Z5_CGC + CRLF +;
						"J� encontrado no cadastro de Clientes, C�digo / Loja: " + SA1->A1_COD + " / " + SA1->A1_LOJA + CRLF +;
						"N�o poder� ser importado", {"Abandona"},3)
		Return Nil
	EndIf
	
	//�����������������������������������������������������Ŀ
	//� Verifica se ja Existe no Cadastro de Clientes		�
	//� Cliente com a mensma Base do CNPJ.            		�
	//�������������������������������������������������������
	If Len(Alltrim(SZ5->Z5_CGC)) == 14

		cCgcCad	 := SubStr(SZ5->Z5_CGC,1,9)
		cAliasA1 := GetNextAlias()
		cTipoCli := "J"
		
		BeginSQL Alias cAliasA1
			SELECT	A1_COD	AS CODIGO
			,		A1_LOJA	AS LOJA
			FROM	%Table:SA1%
			WHERE	%NotDel%
			AND		SUBSTRING(A1_CGC,1,9) = %Exp:cCgcCad%
			ORDER	BY A1_COD, A1_LOJA
		EndSQL
	
		If !(cAliasA1)->(Eof())
			cCodCli	:= (cAliasA1)->CODIGO
			lAchou	:= .T.
			
			While !(cAliasA1)->(Eof())
				cCodCli	:= (cAliasA1)->CODIGO  // Fernando Nogueira - Chamado 000086
				cLojaCli := (cAliasA1)->LOJA
				(cAliasA1)->(DbSkip())
			Enddo
			
			(cAliasA1)->(DbCloseArea())
			cLojaCli := Soma1(cLojaCli)
			
		EndIf
	EndIf
	
	If !lAchou
		cCodCli	 := GetSx8Num("SA1","A1_COD")
		cLojaCli := StrZero(1,TamSx3("A1_LOJA")[1])
	EndIf
	
	If Aviso("Aviso","Confirma Importa��o do Cliente para o cadastro de Clientes?",{"Sim","N�o"}) == 2
		Return Nil
	EndIf
	
	cEndCli	:= Alltrim(SZ5->Z5_ENDEREC) + " ," + IIF(!Empty(SZ5->Z5_ENDERNR), SZ5->Z5_ENDERNR, "SN")
	cEndCob	:= Alltrim(SZ5->Z5_ENDPAG)  + " ," + IIF(!Empty(SZ5->Z5_ENDNRPG), SZ5->Z5_ENDNRPG, "SN") + IIF(!Empty(SZ5->Z5_COMPPAG), " - " + SZ5->Z5_COMPPAG, "")
	cEndEnt	:= Alltrim(SZ5->Z5_ENDENT)  + " ," + IIF(!Empty(SZ5->Z5_ENDNREN), SZ5->Z5_ENDNREN, "SN") + IIF(!Empty(SZ5->Z5_COMPEN), " - " + SZ5->Z5_COMPEN, "")
	cCodPa	:= Posicione("SYA",2,xFilial("SYA") + Upper(SZ5->Z5_PAIS), "SYA->YA_CODGI")
	

	If SZ5->Z5_XREGESP = "S"
		_cTipo    := "R"
		_cGRPTRIB := "060"
	Else
		_cTipo    := "S"
		_cGRPTRIB := SZ5->Z5_GRPTRIB
	EndIf
	
	
	aValues	:= {	{"A1_LOJA"		,cLojaCli			   , Nil},;
					{"A1_COD"		,cCodCli			   , Nil},;
					{"A1_NOME"		,UPPER(SZ5->Z5_RAZASOC), Nil},;
					{"A1_NREDUZ"	,UPPER(SZ5->Z5_NOMEABR), Nil},;
					{"A1_PESSOA"  	,cTipoCli			   , Nil},;
					{"A1_CGC"		,SZ5->Z5_CGC		   , Nil},;
					{"A1_TIPO"  	,"S"				   , Nil},;
					{"A1_END"   	,UPPER(cEndCli)		   , Nil},;
					{"A1_EST"   	,UPPER(SZ5->Z5_UF)     , Nil},;
					{"A1_COD_MUN"	,SZ5->Z5_CDMUNIC	   , Nil},;
					{"A1_MUN"   	,UPPER(SZ5->Z5_CIDADE) , Nil},;
					{"A1_COND"		,SZ5->Z5_CONDPAG	   , Nil},;
					{"A1_INSCR"		,SZ5->Z5_INSCEST	   , Nil},;
					{"A1_CEP"		,SZ5->Z5_CEP		   , Nil},;
					{"A1_DDD"		,SZ5->Z5_TELEFDD	   , Nil},;
					{"A1_TEL"		,SZ5->Z5_TELEFON	   , Nil},;
					{"A1_VEND"		,SZ5->Z5_CODVEND	   , Nil},;
					{"A1_BAIRRO"	,UPPER(SZ5->Z5_BAIRRO) , Nil},;
					{"A1_CEL"		,SZ5->Z5_CELULAR	   , Nil},;
					{"A1_FAX"		,SZ5->Z5_FAX		   , Nil},;
					{"A1_CONTATO"	,UPPER(SZ5->Z5_CONTATO), Nil},;
					{"A1_COMPLEM"	,UPPER(SZ5->Z5_ENDCOMP), Nil},;
					{"A1_DTINCLU"	,SZ5->Z5_DTCADAS	   , Nil},;
					{"A1_ENDCOB"	,UPPER(cEndCob)		   , Nil},;
					{"A1_BAIRROC"	,UPPER(SZ5->Z5_BAIRROP), Nil},;
					{"A1_CEPC"		,SZ5->Z5_CEPPG		   , Nil},;
					{"A1_MUNC"		,UPPER(SZ5->Z5_CIDADEP), Nil},;
					{"A1_ESTC"		,UPPER(SZ5->Z5_UFPG)   , Nil},;
					{"A1_ENDENT"	,UPPER(cEndEnt)		   , Nil},;
					{"A1_BAIRROE"	,UPPER(SZ5->Z5_BAIRROE), Nil},;
					{"A1_CEPE"		,SZ5->Z5_CEPEN		   , Nil},;
					{"A1_EMAIL"		,SZ5->Z5_EMAIL		   , Nil},;
					{"A1_X_MAIL2"	,SZ5->Z5_EMAIL1		   , Nil},;
					{"A1_PRF_OBS"	,SZ5->Z5_OBSERV		   , Nil},;
					{"A1_SUFRAMA"	,SZ5->Z5_SUFRAMA	   , Nil},;
					{"A1_NMGER"		,UPPER(SZ5->Z5_NMGEREN), Nil},;
					{"A1_NMPRO"		,UPPER(SZ5->Z5_NMCOMPR), Nil},;
					{"A1_DTGER"		,SZ5->Z5_ANIVGER	   , Nil},;
					{"A1_DTPROR"	,SZ5->Z5_ANIVPRO	   , Nil},;
					{"A1_DTCOMP"	,SZ5->Z5_ANIVCOM	   , Nil},;
					{"A1_NMCOMP"	,UPPER(SZ5->Z5_PROPRIE), Nil},; 
					{"A1_DESCWEB"	,SZ5->Z5_DESCWEB	   , Nil},;   
					{"A1_CNAE"		,SZ5->Z5_CNAE		   , Nil},;
					{"A1_X_HORA"	,SZ5->Z5_X_HORA	       , Nil},;
					{"A1_SATIV1"	,SZ5->Z5_X_CANAL       , Nil},;
					{"A1_SATIV2"	,SZ5->Z5_X_SEGME       , Nil},;
					{"A1_SATIV4"	,SZ5->Z5_X_PERFI       , Nil},;		
					{"A1_XREGESP"	,SZ5->Z5_XREGESP       , Nil},;
					{"A1_TIPO"	    ,_cTipo                , Nil},;
					{"A1_GRPTRIB"	,_cGRPTRIB             , Nil}}					

	MSExecAuto({|x,y| MATA030(x,y)}, aValues, nOpc)			

	If lMsErroAuto
		RollBackSX8()
		MostraErro()
	Else
		ConfirmSX8()
		MsgInfo("Cliente: " + SA1->A1_COD + " Loja: " + SA1->A1_LOJA + " Cadastrado com Sucesso")
		DbSelectarea("SZ5")
		RecLock("SZ5",.F.)
			SZ5->Z5_STATUS	:= "S"
		MsUnlock()
		If MsgYesNo("Deseja abrir tela de Cadastro")
			AxAltera("SA1", SA1->(Recno()) ,3,/*aAcho*/,/*aCpos*/,/*nColMens*/,/*cMensagem*/,	IIF(!lAcativo, "MA030TudOk()", "MA030TudOk() .And. AC700ALTALU()"),/*cTransact*/,/*cFunc*/,aButtons,/*aParam*/,aRotAuto,/*lVirtual*/)
		EndIf
	EndIf
	
Return Nil