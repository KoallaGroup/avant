#Include "rwmake.ch"
#Include "Protheus.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA103OPC()  � Autor � Fernando Nogueira  � Data �21/03/2014���
�������������������������������������������������������������������������͹��
���Descri��o � Ponto de Entrada localizado na rotina MATA103-Documento de ���
���          � Entrada													  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA103OPC()

	Local aRotina := {}
	Local aRotina2:= {}
	
	// Opcoes do aRotina
	/*aRotina
       { "Pesquisar"  , "PesqBrw"  , 0 , 1 },;
       { "Visualizar" , "AxVisual" , 0 , 2 },;
       { "Incluir"    , "AxInclui" , 0 , 3 },;
       { "Alterar"    , "AxAltera" , 0 , 4 },;
       { "Excluir"    , "AxDeleta" , 0 , 5 };*/

	aadd(aRotina2,{"Controle Trocas", "U_CtrlTrocas" , 0, 4, 0, nil})
	aadd(aRotina2,{"Laudo"          , "U_Laudo_Troca", 0, 4, 0, nil})
	aadd(aRotina2,{"Grv.Laudo Mod." , "U_GrvLaudo   ", 0, 4, 0, nil})
	aadd(aRotina2,{"Enviar Laudo"   , "ApMsgAlert('Em desenvolvimento')", 0, 4, 0, nil})
	aadd(aRotina2,{"Gera Financ."   , "ApMsgAlert('Em desenvolvimento')", 0, 4, 0, nil})
	aadd(aRotina2,{"Gera Pedido"    , "ApMsgAlert('Em desenvolvimento')", 0, 4, 0, nil})
	
	aadd(aRotina,{'Trocas'    , aRotina2       , 0, 4, 0, nil})
	aadd(aRotina,{'Tirar Flag', "U_FlagF1"     , 0, 4, 0, nil})
    
Return(aRotina)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ConfPedTr() � Autor � Fernando Nogueira  � Data �26/03/2014���
�������������������������������������������������������������������������͹��
���Descricao � Confirmacao para criacao do Pedido de Trocas               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ConfPedTr()

If MsgYesNo("Deseja criar Pedido de Venda para troca dos produtos da NF: "+SF1->F1_DOC+"?", "NF Devolu��o")
	U_PedTroca()
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FlagF1()    � Autor � Fernando Nogueira  � Data �14/11/2014���
�������������������������������������������������������������������������͹��
���Descricao � Retira o Flag da Nota de Entrada Posicionada               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FlagF1()

If Empty(SF1->F1_DTLANC)
	ApMsgInfo("J� est� sem o Flag de Contabiliza��o!")
ElseIf MsgNoYes("Retirar o Flag de Contabiliza��o da Nota: "+AllTrim(F1_DOC)+"-"+AllTrim(F1_SERIE)+" ?")
	If SF1->(RecLock("SF1",.F.))
		SF1->F1_DTLANC := CTOD("  /  /  ")
		SF1->(MsUnlock())
		ApMsgInfo("Flag Retirado")
	Endif
Endif

Return