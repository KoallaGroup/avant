#INCLUDE "Protheus.ch"
/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � M450TMAN � Autor � Fernando Nogueira  � Data � 19/11/2015 ���
������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada Para Liberacao Manual da Analise de      ���
���          � Credito por Cliente                                       ���
������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                          ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function M450TMAN()
Return CliLib(SA1->A1_COD,SA1->A1_LOJA)

/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � CliLib    � Autor � Fernando Nogueira � Data � 19/11/2015 ���
������������������������������������������������������������������������͹��
���Descricao � Verifica se o Cliente esta liberado                       ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
Static Function CliLib(cCliente,cLoja)

Local cAliasSC5 := GetNextAlias()
Local lReturn   := .T.

BeginSql alias cAliasSC5

	SELECT C5_NUM FROM %table:SC5% SC5
	WHERE SC5.%notDel% AND C5_FILIAL = %xfilial:SC5% AND C5_X_BLQ IN ('S','C') AND C5_LIBEROK = 'S' AND C5_CLIENTE+C5_LOJACLI = %exp:cCliente+cLoja%
	ORDER BY C5_NUM

EndSql

(cAliasSC5)->(dbGoTop())

If (cAliasSC5)->(!Eof())
	ApMsgInfo("Cliente tem Pedido com Bloqueio Avant!")
	lReturn := .F.
Endif

(cAliasSC5)->(dbCloseArea())

Return lReturn