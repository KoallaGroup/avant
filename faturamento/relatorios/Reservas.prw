#include "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Reservas()  � Autor � Fernando Nogueira  � Data �07/10/2014���
�������������������������������������������������������������������������͹��
���Descri��o � Reservas de Pedidos Faturados                              ���
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
User Function Reservas()

Local oReport

oReport := ReportDef()
oReport:PrintDialog()	

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ReportDef() � Autor � Fernando Nogueira  � Data �07/10/2014���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                   	                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReportDef()
Local oReport
Local oSection1
Local oBreak

oReport := TReport():New("RESERVAS","Reservas Pendentes de Pedidos Faturados - Avant",,{|oReport| PrintReport(oReport)},"Reservas Pendentes de Pedidos Faturados - Avant")

oSection1 := TRSection():New(oReport,"RESERVAS",{"TRB"})

TRCell():New(oSection1,"C0_PRODUTO","TRB","Produto")
TRCell():New(oSection1,"B1_DESC"   ,"TRB",,,TamSx3("B1_DESC")[1])
TRCell():New(oSection1,"C0_LOCAL"  ,"TRB","Armazem")
TRCell():New(oSection1,"C0_DOCRES" ,"TRB","Documento"  ,,15)
TRCell():New(oSection1,"C0_QTDORIG","TRB","Quant.Orig.","99999999")
TRCell():New(oSection1,"C0_QUANT"  ,"TRB","Quant."     ,"99999999")
TRCell():New(oSection1,"CONSUMO"   ,"TRB","Consumo"    ,/*Picture*/,10,/*lPixel*/,/*CodeBlock*/)

oBreak := TRBreak():New(oSection1,{|| TRB->C0_PRODUTO},"Quant.Total")
TRFunction():New(oSection1:Cell("C0_QUANT"),"Quant.Total","SUM",oBreak,,/*Picture*/,/*CodeBlock*/,.F.,.T.,.F.,oSection1)

Return oReport

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PrintReport � Autor � Fernando Nogueira  � Data �07/10/2014���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de tratamento das informacoes do Relatorio	   	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
Static Function PrintReport(oReport)

Local oSection1 := oReport:Section(1)

LjMsgRun("Montando massa de dados ...",,{|| CursorWait(),GeraArqTRB(),CursorArrow()})
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
	DbSkip()
	oReport:IncMeter()
	
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
���Programa  �GeraArqTRB�Autor  � Fernando Nogueira  � Data � 07/10/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao Auxiliar                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GeraArqTRB()

	Local cCampo := "%%"
	Local cWhere := "%%"
	Local cOrder := "%%"
	
	BeginSql alias 'TRB'
	
		SELECT C0_PRODUTO,B1_DESC,C0_LOCAL,C0_DOCRES,C0_QTDORIG,C0_QUANT, CASE WHEN C0_QTDORIG = C0_QUANT THEN 'SEM BAIXA' ELSE 'PARCIAL' END CONSUMO, C5_NUM PEDIDO FROM %table:SC5% SC5
		INNER JOIN %table:SC0% SC0 ON C5_FILIAL = C0_FILIAL AND C5_NUM = C0_DOCRES AND C0_QUANT > 0 AND SC0.%notDel%
		INNER JOIN %table:SB1% SB1 ON B1_COD = C0_PRODUTO AND SB1.%notDel%
		WHERE SC5.%notDel% AND C5_FILIAL = %xfilial:SC5% AND C5_NOTA <> ' '
		UNION
		SELECT * FROM
		(SELECT C0_PRODUTO,B1_DESC,C0_LOCAL,C0_DOCRES,C0_QTDORIG,C0_QUANT, 'EXCLUIDO' CONSUMO, ISNULL(C5_NUM,'000000') PEDIDO FROM %table:SC0% SC0
		LEFT JOIN %table:SC5% SC5 ON C0_FILIAL = C5_FILIAL AND C0_DOCRES = C5_NUM AND SC5.%notDel%
		INNER JOIN %table:SB1% SB1 ON B1_COD = C0_PRODUTO AND SB1.%notDel%
		WHERE SC0.%notDel% AND C0_FILIAL = %xfilial:SC0% AND C0_QUANT > 0 AND C0_DOCRES <> ' ') NULOS
		WHERE PEDIDO = '000000'
		ORDER BY C0_PRODUTO

	EndSql
	
Return()