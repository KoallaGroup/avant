#INCLUDE "Protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA070TIT � Autor � Fernando Nogueira  � Data � 10/09/2015  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para confirmacao da baixa a receber.      ���
�������������������������������������������������������������������������͹��
���Uso       � AVANT.                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function FA070TIT()

If Month(dDtCredito) <> Month(Date())
	ApMsgInfo("A data de cr�dito deve estar no mesmo m�s da data da baixa.")
	Return .F.
Endif

Return .T. 