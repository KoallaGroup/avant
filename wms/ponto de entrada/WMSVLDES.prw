#Include "Protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � WMSVLDES � Autor � Fernando Nogueira   � Data � 09/10/2015 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Ponto de Entrada - Armazens sem controle de WMS            ���
���          � Chamado 002016                                             ���
�������������������������������������������������������������������������Ĵ��
���Utilizacao� AVANT                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function WMSVLDES()
Return AllTrim(GetMV("ES_ARMWMS"))