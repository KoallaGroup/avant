#include "TOTVS.ch"
#include "rwmake.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: M440STTS  | Autor: Kley Gon�alves          | Data: Julho/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao: Ponto de entrada para apagar os registros de Al�ada de 
|				Aprova��o, se existir registros na SCR.
|				Se tipo do pedido (C5_TIPO) = 'N' e gerou registro na SC9 
|				cria alcada de aprovacao. 
+---------------------------------------------------------------------------+
|    Projeto: AVANT
+--------------------------------------------------------------------------*/

User Function M440STTS

Local _lBloqueia	:= .F.
Local aAreaSC9	:= GetArea("SC9")
Local aAreaSC5	:= GetArea("SC5")
Local aAreaSC6	:= GetArea("SC6")
Local aAreaSA1	:= GetArea("SA1")
Local aAreaSE4	:= GetArea("SE4")
Local cAlias 		:= GetNextAlias()
Local cExecSQL	:= ""
Local cGrpAprov	:= Alltrim(GetMV("MV_XGRAPPV"))
Local cGrpAprCR	:= Alltrim(GetMV("MV_XGRAPCR"))

cExecSQL := " DELETE FROM "+RetSqlName('SCR')
cExecSQL += " WHERE CR_FILIAL = '"+xFilial('SCR')+"' "
cExecSQL += " AND   CR_TIPO   = 'PV' "
cExecSQL += " AND   CR_NUM    = '"+SC5->C5_NUM+"' "
cExecSQL += " AND   D_E_L_E_T_ = ' ' "
TcSqlExec(cExecSQL)

SC5->( RecLock('SC5',.f.) ) 
	SC5->C5_X_WF := ' '
SC5->( MsUnLock() )
	
/*-------------------------------------------------------------------------+
|  Gerar aprovacao de PV somente para pedidos Normais.                     |                                            
+--------------------------------------------------------------------------*/
If IsInCallStack("A410DELETA") .Or. SC5->C5_TIPO <> 'N'
	Return
EndIf

SA1->(DbSetOrder(1),DbSeek(xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI)))
SE4->(DbSetOrder(1),DbSeek(xFilial("SE4")+SC5->C5_CONDPAG))

If "ANTECIPADO" $ Upper(SE4->E4_DESCRI)
	If !Empty(cGrpAprCR)
		// Comentado temporariamente para teste, pedidos de bonificacao com pgto antecipado estao entrando em aberto - Fernando Nogueira
		//cGrpAprov	:= cGrpAprCR
		If !IsBlind()
			MsgInfo("A Condi��o de Pagamento do Pedido � de recebimento 'Antecipado'."+CRLF+;
					 "Por isso a Al�ada de Aprova��o ser� gerada para o Grupo de Aprova��o do Contas a Receber: " + cGrpAprov,"Al�ada de Aprova��o")
		EndIf
	Else
		If !IsBlind()
			MsgAlert("A Condi��o de Pagamento do Pedido � de recebimento 'Antecipado', mas " + ;
					  "o Grupo de Aprova��o do Contas a Receber n�o est� parametrizado."+CRLF+;
					 "Por isso a Al�ada de Aprova��o ser� gerada para o Grupo de Aprova��o padr�o do sistema: " + cGrpAprov,"Al�ada de Aprova��o")
		EndIf	
	EndIf
Else
	If Empty(SA1->A1_X_GRAPV)
		If !IsBlind()
			MsgAlert("N�o existe Grupo de Aprova��o de libera��o de cr�dito do Pedido de Venda relacionado ao Cliente."+CRLF+;
					 "Por isso a Al�ada de Aprova��o ser� gerada para o Grupo de Aprova��o padr�o do sistema: " + cGrpAprov,"Al�ada de Aprova��o")
		EndIf
	Else
		cGrpAprov	:= SA1->A1_X_GRAPV
	EndIf
EndIf

If Select(cAlias) > 0
	(cAlias)->(dbCloseArea())
Endif
BeginSQL Alias cAlias
	select sum( (C6_QTDVEN - C6_QTDENT)*C6_PRCVEN ) as TOTPED, count(SC9.C9_ITEM+SC9.C9_SEQUEN) as REGS
	from %Table:SC6% SC6
	left join SC9010 SC9 on C9_FILIAL = C6_FILIAL 
	  and C9_CLIENTE = C6_CLI and C9_LOJA = C6_LOJA and C9_PEDIDO = C6_NUM and C9_ITEM = C6_ITEM and SC9.%NotDel%
	where SC6.C6_FILIAL = %xFilial:SC6% and SC6.C6_NUM = %Exp:SC5->C5_NUM% and SC6.%NotDel%
	group by C6_FILIAL, C6_NUM
EndSQL
(cAlias)->(DbGoTop())

/*--------------------------------------------------------------------------+
| Verificar se houve a geracao do SC9. Se nao foi gerado, nao deve-se utili-|
| zar a geracao de alcadas. Caso contrario, prosseguir com as alcadas.      |
| Caso o PV entrou sem bloqueio de Cr�dito, gerar o SCR com status que sina-|
| lize liberacao automatica:                                                |
|  Gerar aprovacao de PV somente para pedidos Normais.                      |                                            
+---------------------------------------------------------------------------*/

If Empty(cGrpAprov) .and. !IsBlind()
	MsgStop("N�o gerada Al�ada de Aprova��o, porque o Grupo de Aprova��o n�o est� parametrizado corretamente.","Al�ada de Aprova��o")
EndIf

If (cAlias)->REGS > 0
	U_MaAlcDoc( {SC5->C5_NUM,"PV",(cAlias)->TOTPED,,,cGrpAprov,,,,,},Date(),1, "" )
	If !IsBlind()
		MsgInfo("Al�ada de Aprova��o gerada.","Al�ada de Aprova��o")	&&Kley
	EndIf
Else
	If !IsBlind()
		MsgInfo("N�o gerada Al�ada de Aprova��o.","Al�ada de Aprova��o")	&&Kley
	EndIf
EndIf

SE4->( RestArea(aAreaSE4) )
SA1->( RestArea(aAreaSA1) )
SA1->( RestArea(aAreaSC6) )
SA1->( RestArea(aAreaSC5) )
SA1->( RestArea(aAreaSC9) )

Return
