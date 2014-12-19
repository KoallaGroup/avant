#INCLUDE "Protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TotPedCred� Autor � Fernando Nogueira  � Data �  18/07/2014 ���
�������������������������������������������������������������������������͹��
���Descricao � Retorna o Total de Pedidos em Aberto Bloqueados no Credito ���
���          � do Cliente Especificado                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function TotPedCred(cCliente,cLoja)

_aArea    := GetArea()
_nTotal   := 0
_cCliente := cCliente
_cLoja    := cLoja

GeraArqTRB()

TRB->(DbSelectArea('TRB'))
TRB->(DbGotop())

While TRB->(!Eof())
	_nTotal += TRB->TOTAL
	TRB->(dbSkip())
End

TRB->(DbCloseArea())

RestArea(_aArea)

Return _nTotal

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GeraArqTRB�Autor  � Fernando Nogueira  � Data � 18/07/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao Auxiliar                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GeraArqTRB()
	
	BeginSql alias 'TRB'
			
		SELECT CLIENTE,LOJA,SUM(TOTAL)TOTAL FROM
		(SELECT C5_NUM NUMERO,C5_CLIENTE CLIENTE,C5_LOJACLI LOJA,C5_XTOTPED TOTAL FROM %table:SC5% SC5
			INNER JOIN %table:SC9% SC9 ON C5_FILIAL = C9_FILIAL AND C5_NUM = C9_PEDIDO AND C9_BLCRED <> ' ' AND SC9.%notDel%
			WHERE C5_FILIAL = '010104' AND C5_NOTA = ' ' AND C5_BLQ = ' ' AND SC5.%notDel%
			GROUP BY C5_NUM,C5_CLIENTE,C5_LOJACLI,C5_XTOTPED) PED_BLQ_CRED
		WHERE CLIENTE = %exp:_cCliente% AND LOJA = %exp:_cLoja%
		GROUP BY CLIENTE,LOJA

	EndSql
	
Return()