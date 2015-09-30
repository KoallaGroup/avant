#INCLUDE "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � A265NACD � Autor � Fernando Nogueira   � Data � 30/09/2015 ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada para permitir ou nao enderecamento        ���
���          � Chamado 002007                                             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function A265NACD()

If Left(DtoS(dDataBase),6) <> Left(DtoS(SDA->DA_DATA),6)
	If FunName() == "MATA265"
		Final('Enderecamento deve ser no mesmo m�s da entrada.')
	Else
		VtAlert('Enderecamento deve ser no mesmo m�s da entrada.','Aviso',.T.,4000,3)
		Final()
	Endif
Endif 

Return .T.