#INCLUDE "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA020ALT � Autor � Fernando Nogueira   � Data � 08/06/2016 ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para Validar Alteracao de Fornecedor      ���
���          � Chamado 003232                                             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MA020ALT()

If M->A2_EST <> 'EX'
	If Empty(M->A2_COD_MUN)
		ApMsgInfo('Informar o C�digo do Munic�pio')
		Return .F.
	ElseIf Empty(M->A2_CEP)
		ApMsgInfo('Informar o CEP')
		Return .F.
	ElseIf Empty(M->A2_DDD)
		ApMsgInfo('Informar o DDD')
		Return .F.
	ElseIf Empty(M->A2_TEL)
		ApMsgInfo('Informar o Telefone')
		Return .F.
	ElseIf Empty(M->A2_EMAIL)
		ApMsgInfo('Informar o E-mail')
		Return .F.
	EndIf
Endif

Return .T.