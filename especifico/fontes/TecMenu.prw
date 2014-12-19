#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TecMenu()   � Autor � Fernando Nogueira  � Data �23/10/2013���
�������������������������������������������������������������������������͹��
���Descri��o � Menu do Tecnico... Baseado nos fontes da TOTVS...	      ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                   	                      ���
�������������������������������������������������������������������������͹��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������͹��
���              �  /  /  �                                               ���
���              �  /  /  �                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TecMenu()

	Local __lVai      :=	RetCodUsr() == '000000'
	Local cExprFilTop := ""
	
	Private cCadastro 	:= "Atendimento Continuado - Chamados"
	Private aRotina 	:= MenuDef()

	If __lVai
		Final('Usuario sem acesso...')
	Else
		
		// Usuarios que nao sao Administradores
		If aScan(PswRet(1)[1][10],'000000') == 0
			cExprFilTop := "(ZU_CODUSR = '"+RetCodUsr()+"' OR ZU_CODSUP = '"+RetCodUsr()+"')"
		Endif
	
		aCores := {}
	
		aAdd( aCores, { "ZU_STATUS == 'A'" , "BR_VERDE" })
		aAdd( aCores, { "ZU_STATUS == 'F'" , "BR_AMARELO" })
		aAdd( aCores, { "ZU_STATUS == 'C'" , "BR_CINZA" })	
		aAdd( aCores, { "ZU_STATUS == 'E'" , "BR_AZUL" })		
		aAdd( aCores, { "ZU_STATUS == 'T'" , "BR_PINK" })		
	
		mBrowse(6,1,22,75,"SZU",,,,,,aCores,,,,,,,,cExprFilTop)

	EndIf	
	
Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � acr_Legnda()�Autor  � Fernando Nogueira  � Data �23/10/2013���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao auxiliar										   	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function acr_Legnda()

	aLegenda := {}
	aAdd( aLegenda, { "BR_VERDE" 	, "Chamado aberto" } )
	aAdd( aLegenda, { "BR_AMARELO"	, "Chamado aguardando confirmacao" } )
	aAdd( aLegenda, { "BR_CINZA"  	, "Chamado encerrado" } )
	aAdd( aLegenda, { "BR_AZUL"  	, "Chamado em an�lise" } )
	aAdd( aLegenda, { "BR_PINK"  	, "Chamado transferido" } )

	BrwLegenda(cCadastro,"Legenda" ,aLegenda) 

Return()
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MenuDef()   �Autor  � Fernando Nogueira  � Data �23/10/2013���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao auxiliar									     	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MenuDef()
						
	Local aRotina := { {"Pesquisar" ,"AxPesqui",0,1} ,;
	             		 {"Visualizar","u_WEB270EDIT",0,2} ,;
	             		 {"Incluir"   ,"u_WEB270EDIT",0,3} ,;
	             		 {"Editar"	  ,"u_WEB270EDIT",0,4} ,;
	             		 {"Legenda"   ,"u_acr_Legnda",0,5} ,;
	             		 {"Hist�rico" ,"u_LJVERHIST",0,5} ,;
 	             		 {"Enviar" 	  ,"u_TECREENV",0,5} ,;
	             		 {"Reabertura","u_LJREABRE",0,5} }
	             		 
	// Usuarios que pertencem ao grupo de Administradores
	If aScan(PswRet(1)[1][10],'000000') <> 0
		aAdd(aRotina,{"Avan�ado"  ,"u_SUPMANAGER",0,4})
		aAdd(aRotina,{"Imprimir"  ,"u_EXPHTML(SZU->ZU_CHAMADO)",0,5})
		aAdd(aRotina,{"Alocar"    ,"u_RetAlocID(SZU->ZU_ROTINA)",0,5})
	Endif
						
Return(aRotina)