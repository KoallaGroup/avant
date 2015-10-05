#INCLUDE "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT100CLA � Autor � Fernando Nogueira   � Data � 30/09/2015 ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada na Classificacao da NF                    ���
���          � Chamado 002007                                             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MT100CLA()

Local cUsrCod := PswRet()[1][1]
Local nBlqMov := MV_PAR17

If Left(DtoS(dDataBase),6) <> Left(DtoS(SF1->F1_DTDIGIT),6)
	Final('Classifica��o deve ser no mesmo m�s da entrada.')
ElseIf cUsrCod == "000405" .And. nBlqMov == 2
	Final('O Usu�rio de Importa��o deve classificar a nota com Bloqueio de','Movimento.')
ElseIf cUsrCod <> "000405" .And. nBlqMov == 1
	Final('A Classifica��o com Bloqueio de Movimento s� pode ser utilizada pelo','usu�rio de importa��o.')
Endif 

Return .T.