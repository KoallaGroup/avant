#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA440C9()   � Autor � Rogerio Machado   � Data � 28/08/14 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada Executado apos liberacao do Pedido sem    ���
���          � bloqeuio de credito e estoque.                             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA440C9()

Local aArea    := GetArea()
//Local cCliente := SC9->C9_CLIENTE
//Local cLojaCli := SC9->C9_LOJA


SC9->(DBSetOrder(1))
SC9->(DbGoTop())
SC9->(DBSeek(xFilial("SC9")+SC5->C5_NUM+SC6->C6_ITEM))

//Grava horario da liberacao do Pedido
SC9->(RecLock("SC9",.F.))
	SC9->C9_HORA := LEFT(time(),5)
SC9->(MsUnlock())

//�����������������������������������Ŀ
//�  Retorna a situacao inicial       �
//�������������������������������������
RestArea(aArea)

Return