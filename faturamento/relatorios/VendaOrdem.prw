#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FWBROWSE.CH"
/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � VendaOrdem � Autor � Fernando Nogueira  � Data � 08/12/2016 ���
��������������������������������������������������������������������������͹��
���Desc.     � Relatorio em Browse para relacionar as notas de venda ordem ���
���          � e suas referentes remessas                                  ���
���          � Obs: Query suscetivel a falha humana, sendo que o numero    ���
���          � da nf de venda eh indicada manualmente no Pedido de Vendas  ���
��������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                            ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function VendaOrdem()

Local oBrowse
Local oColumn
Local oDlgQry
Local cQuery    := ""
Local aIndex    := {}
Local aSeek     := {}
Local oBtnCan
Local cTrab     := GetNextAlias()
Local bAtualiza := {|| oBrowse:Refresh(.T.) }

Private aSize    := MsAdvSize(.T.)
Private aInfo    := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Private aPosObj  := {}
Private aObjects := {}
Private cPerg    := PadR("VENDAORDEM",Len(SX1->X1_GRUPO))
Private lEnd     := .T.

AjustaSX1(cPerg)

If Pergunte(cPerg,.T.)

	AAdd( aObjects, { 100, 100, .t., .t. } )
	aPosObj	:= MsObjSize(aInfo,aObjects)
	
	//-------------------------------------------------------------------
	// Abertura da tabela
	//-------------------------------------------------------------------
	Connect(,.T.,"01","01",,.T.)
	cQuery := DefQry()

	//-------------------------------------------------------------------
	// Indica os �ndices da tabela tempor�ria
	//-------------------------------------------------------------------
	Aadd( aIndex, "VENDA"  )
	
	//-------------------------------------------------------------------
	// Indica as chaves de Pesquisa
	//-------------------------------------------------------------------
	Aadd(aSeek,{"Nf Venda",{{"","C",TamSX3("F2_DOC")[1],0,"Nf Venda",,}}}) 
	
	SetKey(VK_F5 ,{||cQuery:=DefQry(),oBrowse:SetQuery(cQuery),LjMsgRun("Processando...","Atualiza Filtro",bAtualiza),oBrowse:GoTop(.T.)})
	SetKey(VK_F12,{||Pergunte(cPerg,.T.),cQuery:=DefQry(),oBrowse:SetQuery(cQuery),LjMsgRun("Processando...","Atualiza Filtro",bAtualiza),oBrowse:GoTop(.T.)})
	
	//-------------------------------------------------------------------
	// Define a janela do Browse
	//-------------------------------------------------------------------
	DEFINE MSDIALOG oDlgQry TITLE "Notas de Venda Ordem " FROM 0,0 TO aSize[6],aSize[5] PIXEL
	
		//-------------------------------------------------------------------
		// Define o Browse
		//-------------------------------------------------------------------
		DEFINE FWBROWSE oBrowse DATA QUERY ALIAS cTrab QUERY cQuery DOUBLECLICK {||NotaVis(@oDlgQry,@oBrowse,@cTrab)} FILTER SEEK ORDER aSeek INDEXQUERY aIndex OF oDlgQry
			//-------------------------------------------------------------------
			// Adiciona as colunas do Browse
			//-------------------------------------------------------------------
	
			ADD COLUMN oColumn DATA {|| VENDA         } TITLE "Nf Venda"                     SIZE TamSX3("F2_DOC")[1]                                      OF oBrowse
			ADD COLUMN oColumn DATA {|| VENDAORDEM    } TITLE "Vnd.Ord"                      SIZE 03                                                       OF oBrowse
			ADD COLUMN oColumn DATA {|| StoD(EMISSAO) } TITLE AllTrim(AvSx3("F2_EMISSAO",5)) SIZE TamSX3("F2_EMISSAO")[1]                                  OF oBrowse
			ADD COLUMN oColumn DATA {|| NOME          } TITLE AllTrim(AvSx3("A1_NOME",5))    SIZE TamSX3("A1_NOME")[1]                                     OF oBrowse
			ADD COLUMN oColumn DATA {|| CNPJ          } TITLE AllTrim(AvSx3("A1_CGC",5))     SIZE TamSX3("A1_CGC")[1]     PICTURE PesqPict("SA1","A1_CGC") OF oBrowse
			ADD COLUMN oColumn DATA {|| ENDERECO      } TITLE AllTrim(AvSx3("A1_END",5))     SIZE TamSX3("A1_END")[1]                                      OF oBrowse
			ADD COLUMN oColumn DATA {|| CIDADE        } TITLE AllTrim(AvSx3("A1_MUN",5))     SIZE TamSX3("A1_MUN")[1]                                      OF oBrowse
			ADD COLUMN oColumn DATA {|| UF            } TITLE AllTrim(AvSx3("A1_EST",5))     SIZE TamSX3("A1_EST")[1]                                      OF oBrowse
			ADD COLUMN oColumn DATA {|| CEP           } TITLE AllTrim(AvSx3("A1_CEP",5))     SIZE TamSX3("A1_CEP")[1]     PICTURE PesqPict("SA1","A1_CEP") OF oBrowse
			ADD COLUMN oColumn DATA {|| REMESSA       } TITLE "Nf Remessa"                   SIZE TamSX3("D2_DOC")[1]                                      OF oBrowse
			
		//-------------------------------------------------------------------
		// Ativa��o do Browse
		//-------------------------------------------------------------------
		ACTIVATE FWBROWSE oBrowse
		
		@ 01,aPosObj[1][4]-320 BUTTON "&Sair" SIZE 34,11 ACTION ( nOpca := 1, oDlgQry:End() ) OF oDlg PIXEL
	//-------------------------------------------------------------------
	// Ativa��o do janela
	//-------------------------------------------------------------------
	ACTIVATE MSDIALOG oDlgQry CENTERED
	
	SetKey(VK_F5 ,Nil)
	SetKey(VK_F12,Nil)
		
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AjustaSX1 �Autor  � Fernando Nogueira  � Data � 08/12/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria as perguntas do programa no dicionario de perguntas    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1(cPerg)

	Local aAreaAnt := GetArea()
	Local aRegs    := {}
	Local aHelpPor := {}
	Local aHelpEng := {}
	Local aHelpSpa := {}

	aHelpPor := {"Data Inicial"}
	PutSX1(cPerg,"01","Data de ?"  ,"","","mv_ch1","D",8,0,0,"G","NaoVazio","","","","mv_par01","","","","DTOS(dDataBase)","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Data Final"}
	PutSX1(cPerg,"02","Data Ate ?" ,"","","mv_ch2","D",8,0,0,"G","NaoVazio","","","","mv_par02","","","","DTOS(dDataBase)","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Amarracao:","- Com Amarracao","- Sem Amarracao"}
	PutSX1(cPerg,"03","Amarracao ?","","","mv_ch3","N",1,0,1,"C","NaoVazio","","","","mv_par03","Com","Com","Com","1","Sem","Sem","Sem","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

		
	RestArea(aAreaAnt)

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NotaVis  �Autor  � Fernando Nogueira  � Data � 08/12/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Nota a Visualizar                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function NotaVis(oDlgQry,oBrowse,cTrab)

Local bAction1 := {||SF2->(dbSeek(xFilial("SF2")+(cTrab)->(FieldGet(01)))),MC090Visual(),oDlg:End()} 
Local bAction2 := {||If(SF2->(dbSeek(xFilial("SF2")+(cTrab)->(FieldGet(10)))),MC090Visual(),ApMsgAlert("Nota Sem Amarra��o com a Remessa!")),oDlg:End()}
Local bAction3 := {||oDlg:End()}
                                      
Static oDlg
Static oButton1
Static oButton2
Static oButton3
Static oFont1 := TFont():New("Arial Black",,020,,.T.,,,,,.F.,.F.)
Static oFont2 := TFont():New("Arial Narrow",,018,,.F.,,,,,.F.,.F.)
Static oSay1

  DEFINE MSDIALOG oDlg TITLE "Nota a Visualizar" FROM 000, 000  TO 090, 320 COLORS 0, 16777215 PIXEL

    @ 005, 015 SAY oSay1 PROMPT "Qual nota deseja visualizar?" SIZE 129, 013 OF oDlg FONT oFont1 COLORS 0, 16777215 PIXEL
    @ 022, 010 BUTTON oButton1 PROMPT "Venda" SIZE 037, 012 OF oDlg FONT oFont2 ACTION Eval(bAction1) PIXEL
    @ 022, 060 BUTTON oButton2 PROMPT "Remessa" SIZE 037, 012 OF oDlg FONT oFont2 ACTION Eval(bAction2) PIXEL
    @ 022, 110 BUTTON oButton3 PROMPT "Cancelar" SIZE 037, 012 OF oDlg FONT oFont2 ACTION Eval(bAction3) PIXEL
  ACTIVATE MSDIALOG oDlg CENTERED

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DefQry   �Autor  � Fernando Nogueira  � Data � 12/12/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Define Query                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function DefQry()

If MV_PAR03 == 1
	cQuery := "SELECT SF2.F2_DOC VENDA,CASE WHEN ISNULL(DOCSERIE,'NAO') = 'NAO' THEN 'NAO' ELSE 'OK' END VENDAORDEM,F2_EMISSAO EMISSAO,A1_NOME NOME,A1_CGC CNPJ,A1_END ENDERECO,A1_MUN CIDADE,A1_EST UF,A1_CEP CEP,VDO.D2_DOC REMESSA FROM "+RetSqlName('SF2')+" SF2 "
	cQuery += "INNER JOIN "
	cQuery += "(SELECT DISTINCT D2_DOC,C5_MENNOTA FROM "+RetSqlName('SD2')+" SD2 "
	cQuery += "INNER JOIN "+RetSqlName('SC5')+" SC5 ON D2_FILIAL = C5_FILIAL AND D2_PEDIDO = C5_NUM AND SC5.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE SD2.D_E_L_E_T_ = ' ' AND D2_FILIAL = '"+xFilial('SD2')+"' AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND D2_TES = '529') VDO ON "
	cQuery += "CHARINDEX(RIGHT(SF2.F2_DOC,06),VDO.C5_MENNOTA) > 0 "
	cQuery += "INNER JOIN "+RetSqlName('SA1')+" SA1 ON F2_CLIENTE+F2_LOJA = A1_COD+A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "LEFT JOIN "
	cQuery += "(SELECT D2_DOC+D2_SERIE DOCSERIE FROM "+RetSqlName('SD2')+" SD2 "
	cQuery += "INNER JOIN "+RetSqlName('SF4')+" SF4 ON F4_FILIAL = D2_FILIAL AND D2_TES = F4_CODIGO AND F4_TEXTO LIKE '%ORD%' AND F4_TEXTO LIKE '%VEND%' AND SF4.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE SD2.D_E_L_E_T_ = ' ' AND D2_FILIAL = '"+xFilial('SD2')+"' AND D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	cQuery += "GROUP BY D2_DOC+D2_SERIE) TD2 ON F2_DOC+F2_SERIE = DOCSERIE "
	cQuery += "WHERE SF2.D_E_L_E_T_ = ' ' AND SF2.F2_FILIAL = '"+xFilial('SF2')+"' AND SF2.F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	cQuery += "AND SUBSTRING(C5_MENNOTA,CHARINDEX(RIGHT(SF2.F2_DOC,06),VDO.C5_MENNOTA)+6,01) NOT IN ('0','1','2','3','4','5','6','7','8','9') "
	cQuery += "ORDER BY VENDA "
Else
	cQuery := "SELECT DISTINCT SF2.F2_DOC VENDA,'SEM' VENDAORDEM,F2_EMISSAO EMISSAO,A1_NOME NOME,A1_CGC CNPJ,A1_END ENDERECO,A1_MUN CIDADE,A1_EST UF,A1_CEP CEP,'SEM' REMESSA FROM "+RetSqlName('SF2')+" SF2 "
	cQuery += "INNER JOIN "+RetSqlName('SD2')+" SD2 ON F2_FILIAL+F2_DOC+F2_SERIE = D2_FILIAL+D2_DOC+D2_SERIE AND SD2.D_E_L_E_T_ = ' ' "
	cQuery += "INNER JOIN "+RetSqlName('SA1')+" SA1 ON F2_CLIENTE+F2_LOJA = A1_COD+A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "INNER JOIN "+RetSqlName('SF4')+" SF4 ON F4_FILIAL = D2_FILIAL AND D2_TES = F4_CODIGO AND F4_TEXTO LIKE '%ORD%' AND F4_TEXTO LIKE '%VEND%' AND SF4.D_E_L_E_T_ = ' ' "
	cQuery += "LEFT JOIN "
	cQuery += "(SELECT TF2.F2_DOC,TF2.F2_SERIE,VDO.D2_DOC REMESSA FROM "+RetSqlName('SF2')+" TF2 "
	cQuery += "INNER JOIN "
	cQuery += "(SELECT DISTINCT D2_DOC,C5_MENNOTA FROM "+RetSqlName('SD2')+" TD2 "
	cQuery += "INNER JOIN "+RetSqlName('SC5')+" SC5 ON TD2.D2_FILIAL = C5_FILIAL AND TD2.D2_PEDIDO = C5_NUM AND SC5.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE TD2.D_E_L_E_T_ = ' ' AND TD2.D2_FILIAL = '"+xFilial('SD2')+"' AND TD2.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND TD2.D2_TES = '529') VDO ON "
	cQuery += "CHARINDEX(RIGHT(TF2.F2_DOC,06),VDO.C5_MENNOTA) > 0 "
	cQuery += "WHERE TF2.D_E_L_E_T_ = ' ' AND TF2.F2_FILIAL = '"+xFilial('SF2')+"' AND TF2.F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	cQuery += "	AND SUBSTRING(C5_MENNOTA,CHARINDEX(RIGHT(TF2.F2_DOC,06),VDO.C5_MENNOTA)+6,01) NOT IN ('0','1','2','3','4','5','6','7','8','9')) TF2 "
	cQuery += "ON SF2.F2_DOC+SF2.F2_SERIE = TF2.F2_DOC+TF2.F2_SERIE "
	cQuery += "WHERE SD2.D_E_L_E_T_ = ' ' AND SD2.D2_FILIAL = '"+xFilial('SD2')+"' AND SD2.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND TF2.F2_DOC IS NULL "
	cQuery += "ORDER BY VENDA "
Endif

Return cQuery