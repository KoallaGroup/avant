#INCLUDE "Protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F070ACONT� Autor � Fernando Nogueira  � Data � 12/03/2015  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada anterior a contabilizacao da rotina de    ���
���          � Baixas a Receber                                           ���
�������������������������������������������������������������������������͹��
���Uso       � AVANT.                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function F070ACONT()

// Altera a Database, igualando a Data de Credito
dDataBase := SE5->E5_DTDISPO

Return