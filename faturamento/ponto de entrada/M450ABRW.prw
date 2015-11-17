#INCLUDE "Protheus.ch"
/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � M450ABRW � Autor � Fernando Nogueira  � Data � 10/11/2015 ���
������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada no Filtro da Rotina de Analise de        ���
���          � Credito do Cliente                                        ���
���          � Chamado 001777                                            ���
������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                          ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function M450ABRW()

Local cQuery := ParamIXB[1]

cQuery += " AND SC9.C9_BLOQUEI <> '01' AND SC5.C5_X_BLQ <> 'S' " + ;
		  " AND SC5.C5_CLIENTE+SC5.C5_LOJACLI NOT IN " + ;
	      " (SELECT C5_CLIENTE+C5_LOJACLI FROM SC5010 SC5 " + ;
		  "    WHERE D_E_L_E_T_ = ' ' AND C5_FILIAL = '"+xFilial("SC5")+"' AND C5_X_BLQ = 'S' AND C5_LIBEROK = 'S' " + ;
		  "    GROUP BY C5_CLIENTE+C5_LOJACLI) "
	
ConOut(cQuery)

Return cQuery