#INCLUDE "PROTHEUS.CH"         
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CredMKT  � Autor � Fernando Nogueira  � Data � 06/01/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Controle do Credito de Marketing                           ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CredMKT()

	Private cCadastro 	:= "Controle Credito Marketing"
	Private aRotina		:= {}
	Private aCores		:= {}

	aAdd( aRotina, { 'Pesquisar'  ,'AxPesqui'  , 0, 1 } )
	aAdd( aRotina, { 'Visualizar' ,'AxVisual'  , 0, 2 } )
	aAdd( aRotina, { 'Incluir'    ,'U_AtuMKT'  , 0, 3 } )
	aAdd( aRotina, { 'Legenda'    ,'U_LegMKT'  , 0, 4 } )
	aAdd( aRotina, { 'Excluir'    ,'U_AtuMKT'  , 0, 5 } )
	
	aAdd( aCores, { "ZZM_TIPO == '001'" , "BR_VERDE"    }) // Entrada NoMid
	aAdd( aCores, { "ZZM_TIPO == '002'" , "BR_VERMELHO" }) // Entrada Manual
	aAdd( aCores, { "ZZM_TIPO == '499'" , "BR_AZUL"     }) // Entrada Transferencia
	aAdd( aCores, { "ZZM_TIPO == '502'" , "BR_VERMELHO" }) // Saida Manual
	aAdd( aCores, { "ZZM_TIPO == '999'" , "BR_AZUL"     }) // Saida Transferencia

	MBrowse( 06, 01, 22, 75, "ZZM",,,,,, aCores) 
 
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LegMKT   � Autor � Fernando Nogueira  � Data � 06/01/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Legendas do Credito de Marketing                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LegMKT()

	aLegenda := {}
	aAdd( aLegenda, { "BR_VERDE" 	, "NoMid" } )
	aAdd( aLegenda, { "BR_VERMELHO"	, "Mov.Manual"    } )
	aAdd( aLegenda, { "BR_AZUL"  	, "Transferencia" } )

	BrwLegenda(cCadastro ,"Legenda" ,aLegenda) 
	                                    
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AtuMKT   � Autor � Fernando Nogueira  � Data � 07/01/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualizacao de Movimentacao do Credito de Marketing        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AtuMKT(cAlias,nReg,nOpc)

Local cVendedor := ""
Local cTipo     := ""
Local nValor    := 0

If nOpc == 3
	If AxInclui(cAlias,nReg,nOpc) == 1
		If SA3->(dbSeek(xFilial("SA3")+ZZM->ZZM_VEND))
			SA3->(RecLock("SA3",.F.))
		
			If ZZM->ZZM_TIPO < '500'
				SA3->A3_ACMMKT += ZZM->ZZM_VALOR
			Else
				SA3->A3_ACMMKT -= ZZM->ZZM_VALOR
			Endif
			
			SA3->(MsUnlock())
		EndIf
	Endif
	
ElseIf nOpc == 5
	cVendedor := ZZM->ZZM_VEND
	cTipo     := ZZM->ZZM_TIPO
	nValor    := ZZM->ZZM_VALOR
	
	If AxDeleta(cAlias,nReg,nOpc) == 2
		If SA3->(dbSeek(xFilial("SA3")+cVendedor))
			SA3->(RecLock("SA3",.F.))
		
			If cTipo < '500'
				SA3->A3_ACMMKT -= nValor
			Else
				SA3->A3_ACMMKT += nValor
			Endif
			
			SA3->(MsUnlock())
		EndIf
	Endif
Endif

Return