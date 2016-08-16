#include "PROTHEUS.CH"
#include "TopConn.ch"
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � ContDupCred    � Autor � Fernando Nogueira  � Data �12/08/2016���
����������������������������������������������������������������������������͹��
���Descri��o � Avalia Contabilizacao do Credito de Duplicatas a Receber      ���
����������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                   	                         ���
����������������������������������������������������������������������������͹��
���Analista Resp.�  Data  � Manutencao Efetuada                              ���
����������������������������������������������������������������������������͹��
���              �  /  /  �                                                  ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function ContDupCred()

Local oReport

Private cPerg    := PadR("CONTDPCRD",Len(SX1->X1_GRUPO))

AjustaSX1(cPerg)
Pergunte(cPerg,.T.)

If mv_par03 == 1
	oReport := RepDef1()
	oReport:PrintDialog()
ElseIf mv_par03 == 2
	oReport := RepDef2()
	oReport:PrintDialog()
Else
	ApMsgInfo("Em desenvolvimento")
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RepDef1()   � Autor � Fernando Nogueira  � Data �12/08/2016���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                   	                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RepDef1()
Local oReport
Local oSection1
Local oBreak

Private aCtbDup   := {}

oReport := TReport():New("CONTDPCRD","Cont. Cr�dito a Mais","CONTDPCRD",{|oReport| PrintRep1(oReport)},"Cont. Cr�dito a Mais")
oReport:lParamReadOnly := .T.
oReport:SetLandScape()

oSection1 := TRSection():New(oReport,"CONTDPCRD",{"TRB"},, .F., .F. )

TRCell():New(oSection1,"EMISSAO"   ,"TRB","Emissao"   ,                           ,12,,{||STOD(TRB->EMISSAO)})
TRCell():New(oSection1,"HISTORICO" ,"TRB","Hist�rico" ,                           ,TamSx3("CT2_HIST")[1])
TRCell():New(oSection1,"VALOR"     ,"TRB","Valor  "   ,PesqPict("CT2","CT2_VALOR"),TamSx3("CT2_VALOR")[1])

TRFunction():New(oSection1:Cell("EMISSAO"),"Quant. Itens","COUNT",,"Quant. Itens",/*Picture*/,/*CodeBlock*/,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("VALOR"),"Valor Total","SUM",,"Valor Total",PesqPict("CT2","CT2_VALOR"),/*CodeBlock*/,.F.,.T.,.F.,oSection1)
	

Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RepDef2()   � Autor � Fernando Nogueira  � Data �12/08/2016���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                   	                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RepDef2()
Local oReport
Local oSection1
Local oBreak

Private aCtbDup   := {}

oReport := TReport():New("CONTDPCRD","Cont. Cr�dito a Mais","CONTDPCRD",{|oReport| PrintRep2(oReport)},"Cont. Cr�dito a Mais")
oReport:lParamReadOnly := .T.
oReport:SetLandScape()

oSection1 := TRSection():New(oReport,"CONTDPCRD",{"TRB"},, .F., .F. )

TRCell():New(oSection1,"EMISSAO"   ,,"Emissao"   ,                           ,12                    )
TRCell():New(oSection1,"HISTORICO" ,,"Hist�rico" ,                           ,TamSx3("CT2_HIST")[1] )
TRCell():New(oSection1,"VALOR"     ,,"Valor  "   ,PesqPict("CT2","CT2_VALOR"),TamSx3("CT2_VALOR")[1])

TRFunction():New(oSection1:Cell("EMISSAO"),"Quant. Itens","COUNT",,"Quant. Itens",/*Picture*/,/*CodeBlock*/,.F.,.T.,.F.,oSection1)
TRFunction():New(oSection1:Cell("VALOR"),"Valor Total","SUM",,"Valor Total",PesqPict("CT2","CT2_VALOR"),/*CodeBlock*/,.F.,.T.,.F.,oSection1)

Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PrintRep1   � Autor � Fernando Nogueira  � Data �12/08/2016���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de tratamento das informacoes do Relatorio	   	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
Static Function PrintRep1(oReport)

Local oSection1 := oReport:Section(1)

LjMsgRun("Montando massa de dados ...",,{|| CursorWait(),GerArqTRB1(),CursorArrow()})
DbSelectArea('TRB')
DbGotop()
Count To nRegua
DbGotop()

oReport:SetMeter(nRegua)

oSection1:Init()

While (!Eof())
	
	If oReport:Cancel()
		Exit
	EndIf
	
	oSection1:PrintLine()	
	
	oReport:IncMeter()
	
	DbSkip()
End

oSection1:Finish()

TRB->(DbCloseArea())

oReport:SetTotalInLine(.F.)
oReport:SetTotalText("T O T A L ")

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PrintRep2   � Autor � Fernando Nogueira  � Data �12/08/2016���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de tratamento das informacoes do Relatorio	   	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
Static Function PrintRep2(oReport)

Local oSection1 := oReport:Section(1)

Private cAliasCT2 := GetNextAlias()

LjMsgRun("Montando massa de dados ...",,{|| CursorWait(),GerArqCT2(),CursorArrow()})
DbSelectArea(cAliasCT2)
DbGotop()

aCtbDup := {}

While !(cAliasCT2)->(Eof())

	Private cAliasDup := GetNextAlias()
	
	BeginSql alias cAliasDup
	
		SELECT CT2_DATA EMISSAO,CT2_HIST HISTORICO,CT2_VALOR VALOR FROM %table:CT2% CT2
		INNER JOIN %table:CV3% CV3 ON CT2_FILIAL = CV3_FILIAL AND CT2_DATA = CV3_DTSEQ AND CT2.R_E_C_N_O_ = CV3_RECDES AND CV3.%notDel%
		INNER JOIN %table:SE5% SE5 ON CT2_FILIAL = E5_FILIAL AND E5_RECPAG = 'R' AND CV3_RECORI = SE5.R_E_C_N_O_ AND SE5.%notDel%
		WHERE CT2.%notDel% 
			AND CT2_FILIAL = %xfilial:CT2% 
			AND CT2_DATA BETWEEN %Exp:DtoS(mv_par01)% AND %Exp:DtoS(mv_par02)% 
			AND CT2_CREDIT = '110503002'
			AND SE5.R_E_C_N_O_ = %Exp:(cAliasCT2)->SE5RECNO% 
			AND CT2_ORIGEM = %Exp:(cAliasCT2)->ORIGEM%
	
	EndSql
	
	(cAliasDup)->(dbGoTop())
	
	While !(cAliasDup)->(Eof())
		aAdd(aCtbDup,{(cAliasDup)->EMISSAO,(cAliasDup)->HISTORICO,(cAliasDup)->VALOR})
		(cAliasDup)->(dbSkip())
	End
	
	(cAliasDup)->(DbCloseArea())
	
	(cAliasCT2)->(dbSkip())
End

(cAliasCT2)->(DbCloseArea())


oReport:SetMeter(len(aCtbDup))

oSection1:Init()

For i:= 1 to len(aCtbDup)
	
	If oReport:Cancel()
		Exit
	EndIf

    oSection1:Cell("EMISSAO"):SetValue(STOD(aCtbDup[i,01]))
    oSection1:Cell("HISTORICO"):SetValue(aCtbDup[i,02])
    oSection1:Cell("VALOR"):SetValue(aCtbDup[i,03])
	
	oSection1:PrintLine()	
	
	oReport:IncMeter()
	
	DbSkip()
Next

oSection1:Finish()




oReport:SetTotalInLine(.F.)
oReport:SetTotalText("T O T A L ")

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GerArqTRB1�Autor  � Fernando Nogueira  � Data � 12/08/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao Auxiliar                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GerArqTRB1()

	BeginSql alias 'TRB'
	
		SELECT CT2_DATA EMISSAO,CT2_HIST HISTORICO, CT2_VALOR VALOR FROM %table:CT2% CT2
		INNER JOIN %table:CV3% CV3 ON CT2_FILIAL = CV3_FILIAL AND CV3_DTSEQ BETWEEN %Exp:DtoS(mv_par01-60)% AND %Exp:DtoS(mv_par02+60)%  AND CT2.R_E_C_N_O_ = CV3_RECDES AND CV3.%notDel%
		LEFT  JOIN %table:SE5% SE5 ON CT2_FILIAL = E5_FILIAL AND E5_RECPAG = 'R' AND E5_DTDISPO BETWEEN %Exp:DtoS(mv_par01)% AND %Exp:DtoS(mv_par02)% AND CV3_RECORI = SE5.R_E_C_N_O_ AND SE5.%notDel%
		WHERE CT2.%notDel% 
			AND CT2_FILIAL = %xfilial:CT2% 
			AND CT2_DATA BETWEEN %Exp:DtoS(mv_par01)% AND %Exp:DtoS(mv_par02)% 
			AND CT2_CREDIT = '110503002' 
			AND SE5.R_E_C_N_O_ IS NULL
		ORDER BY CT2.R_E_C_N_O_

	EndSql
	
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GerArqCT2 �Autor  � Fernando Nogueira  � Data � 15/08/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao Auxiliar                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GerArqCT2()

	BeginSql alias cAliasCT2
	
	
		SELECT SE5.R_E_C_N_O_ SE5RECNO,CT2_ORIGEM ORIGEM FROM %table:CT2% CT2
		INNER JOIN CV3010 CV3 ON CT2_FILIAL = CV3_FILIAL AND CV3_DTSEQ BETWEEN %Exp:DtoS(mv_par01-60)% AND %Exp:DtoS(mv_par02+60)% AND CT2.R_E_C_N_O_ = CV3_RECDES AND CV3.%notDel%
		INNER JOIN SE5010 SE5 ON CT2_FILIAL = E5_FILIAL AND E5_RECPAG = 'R' AND E5_DTDISPO BETWEEN %Exp:DtoS(mv_par01)% AND %Exp:DtoS(mv_par02)% AND CV3_RECORI = SE5.R_E_C_N_O_ AND SE5.%notDel%
		WHERE CT2.%notDel% 
			AND CT2_FILIAL = %xfilial:CT2%
			AND CT2_DATA BETWEEN %Exp:DtoS(mv_par01)% AND %Exp:DtoS(mv_par02)%
			AND CT2_CREDIT = '110503002'
		GROUP BY SE5.R_E_C_N_O_,CT2_ORIGEM HAVING COUNT(*) > 1

	EndSql
	
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AjustaSX1 �Autor  � Fernando Nogueira  � Data � 12/08/2016  ���
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
	PutSX1(cPerg,"01","Data de ?" ,"","","mv_ch1","D",8,0,0,"G","NaoVazio","","","","mv_par01","","","","DTOS(dDataBase)","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Data Final"}
	PutSX1(cPerg,"02","Data Ate ?","","","mv_ch2","D",8,0,0,"G","NaoVazio","","","","mv_par02","","","","DTOS(dDataBase)","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	aHelpPor := {"Relat�rio:","- Cr�dito a Mais","- Cr�dito Duplicado","- Em Desenvolvimento","- Em Desenvolvimento"}
	PutSX1(cPerg,"03","Relat�rio ?"    ,"","","mv_ch3","N",1,0,1,"C","NaoVazio","","","","mv_par03","Cred A Mais","Cred A Mais","Cred A Mais","","Cred Duplicado","Cred Duplicado","Cred Duplicado","Desenvolvimento","Desenvolvimento","Desenvolvimento","Desenvolvimento","Desenvolvimento","Desenvolvimento","","","",aHelpPor,aHelpEng,aHelpSpa)

		
	RestArea(aAreaAnt)

Return Nil