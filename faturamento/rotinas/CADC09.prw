#INCLUDE "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CADC09   � Autor � Fernando Nogueira   � Data � 29/09/2015 ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Unidades Federativas                           ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CADC09()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "C09"

dbSelectArea("C09")
dbSetOrder(1)

AxCadastro(cString,"Unidades Federativas",cVldExc,cVldAlt)

Return