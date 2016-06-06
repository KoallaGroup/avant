#INCLUDE "Protheus.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M410PVNF � Autor � Fernando Nogueira  � Data � 25/05/2016  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada que valida o usuario que pode acessar a   ���
���          � geracao de Nota Fiscal na Tela do Pedido de Vendas.        ���
���          � Chamado 003084.                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function M410PVNF()

If aScan(PswRet(1)[1][10],'000000') <> 0 ;											// Acesso Administradores
	.Or. (aScan(PswRet(1)[1][10],'000040') <> 0 .And. SC5->C5_FILIAL == '010101') ;	// Acesso Fiscal
    .Or. (aScan(PswRet(1)[1][10],'000053') <> 0 .And. SC5->C5_FILIAL == '040401')  	// Acesso Faturamento
	Return .T.
Endif

ApMsgInfo('Somente usu�rios autorizados.')

Return .F.
