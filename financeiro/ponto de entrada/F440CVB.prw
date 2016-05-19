#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F440CVB  � Autor � Fernando Nogueira  � Data � 19/05/2016  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada antes da Geracao das Comissoes            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function F440CVB()

Local aAreaSA6  := SA6->(GetArea())
Local lComiss   := Posicione("SA6",1,xFilial("SA6")+SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA,"A6_COMISS") == "S"

// Se a Conta Bancaria nao gerar comissao
// Fernando Nogueira - Chamado 002505
If !lComiss
	Return .F.
Endif

SA6->(RestArea(aAreaSA6))

Return .T.