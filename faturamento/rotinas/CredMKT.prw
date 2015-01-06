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
	aAdd( aRotina, { 'Incluir'    ,'AxInclui'  , 0, 3 } )
	aAdd( aRotina, { 'Excluir'    ,'AxDeleta'  , 0, 5 } )
	aAdd( aRotina, { 'Legenda'    ,'U_LegMKT'  , 0, 6 } )
	
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