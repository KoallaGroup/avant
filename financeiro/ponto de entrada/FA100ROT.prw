#Include "rwmake.ch"
#Include "Protheus.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA100ROT()  � Autor � Fernando Nogueira  � Data �18/12/2014���
�������������������������������������������������������������������������͹��
���Descri��o � Ponto de Entrada localizado na rotina FINA100-Movimento    ���
���          � Bancario													  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA100ROT()

	Local aRotina := ParamIXB[1]
	
	// Opcoes do aRotina
	/*aRotina
       { "Pesquisar"  , "PesqBrw"  , 0 , 1 },;
       { "Visualizar" , "AxVisual" , 0 , 2 },;
       { "Incluir"    , "AxInclui" , 0 , 3 },;
       { "Alterar"    , "AxAltera" , 0 , 4 },;
       { "Excluir"    , "AxDeleta" , 0 , 5 };*/

	aadd(aRotina,{'Tirar Flag', "U_FlagE5"     , 0, 4, 0, nil})
    
Return(aRotina)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FlagE5()    � Autor � Fernando Nogueira  � Data �18/12/2014���
�������������������������������������������������������������������������͹��
���Descricao � Retira o Flag da Movimentacao Financeira                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FlagE5()

If Empty(SE5->E5_LA)
	ApMsgInfo("J� est� sem o Flag de Contabiliza��o!")
ElseIf MsgNoYes("Retirar o Flag da Mov. Financeira: "+AllTrim(SE5->E5_NUMERO)+"-"+AllTrim(SE5->E5_PREFIXO)+"-"+AllTrim(SE5->E5_PARCELA)+"-"+AllTrim(SE5->E5_SEQ)+" ?")
	If SE5->(RecLock("SF1",.F.))
		SE5->E5_LA := ' '
		SE5->(MsUnlock())
		ApMsgInfo("Flag Retirado")
	Endif
Endif

Return