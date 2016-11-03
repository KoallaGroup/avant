#Include "Totvs.ch"
#Include "FwMvcDef.ch"
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Programa  � Perm_Interna� Autor � Fernando Nogueira    � Data �07/04/2015���
���������������������������������������������������������������������������͹��
���Descricao � Permissao para as Regras Internas                            ���
���������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                 	                        ���
���������������������������������������������������������������������������͹��
���Analista Resp.   �   Data   � Manutencao Efetuada                        ���
���������������������������������������������������������������������������͹��
���Fernando Nogueira�01/11/2016� Incluindo a Opcao de Responsavel por Area. ���
���                 �  /  /    � Alteracao do Cadastro para o MVC           ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
User Function Perm_Interna()

Private oBrowse := FwMBrowse():New()				//Variavel de Browse 

//Alias do Browse
oBrowse:SetAlias('ZZL')
//Descri��o da Parte Superior Esquerda do Browse
oBrowse:SetDescripton("Permissao Regras Internas") 

//Legendas do Browse
oBrowse:AddLegend( "ZZL_PERMIS=='1'", "ENABLE" , "Liberado" )
oBrowse:AddLegend( "ZZL_PERMIS=='2'", "DISABLE", "Bloqueado")

// Usuarios que nao sao Administradores terao filtro
If aScan(PswRet(1)[1][10],'000000') == 0
	oBrowse:SetFilterDefault("ZZL_CODRES == "+RetCodUsr()+" .And. ZZL_CODUSR <> "+RetCodUsr())
Endif
	
//Ativa o Browse
oBrowse:Activate()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MenuDef  � Autor � Fernando Nogueira  � Data � 01/11/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Menu do Browse                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MenuDef()

Local aMenu :=	{}
	
ADD OPTION aMenu TITLE 'Pesquisar'  ACTION 'PesqBrw'       		    OPERATION 1 ACCESS 0
ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.Perm_Interna'	OPERATION 2 ACCESS 0
ADD OPTION aMenu TITLE 'Incluir'    ACTION 'VIEWDEF.Perm_Interna' 	OPERATION 3 ACCESS 0
ADD OPTION aMenu TITLE 'Alterar'    ACTION 'VIEWDEF.Perm_Interna' 	OPERATION 4 ACCESS 0
ADD OPTION aMenu TITLE 'Excluir'    ACTION 'VIEWDEF.Perm_Interna' 	OPERATION 5 ACCESS 0
ADD OPTION aMenu TITLE 'Imprimir'   ACTION 'VIEWDEF.Perm_Interna'	OPERATION 8 ACCESS 0
ADD OPTION aMenu TITLE 'Copiar'     ACTION 'VIEWDEF.Perm_Interna'	OPERATION 9 ACCESS 0
	
Return(aMenu)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ModelDef � Autor � Fernando Nogueira  � Data � 01/11/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de Modelo de Dados.                                 ���
���          � Onde eh definido a estrutura de dados.                     ���
���          � Regra de Negocio.                                          ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ModelDef()
//Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
Local oStruct := FWFormStruct(1,"ZZL") 
Local oModel

//Instancia do Objeto de Modelo de Dados
oModel := MpFormModel():New('MDPerm',/*Pre-Validacao*/,/*Pos-Validacao*/,/*Commit*/,/*Cancel*/)

//Adiciona um modelo de Formulario de Cadastro Similar ao Enchoice ou Msmget
oModel:AddFields('ID_FLD_Perm', /*cOwner*/, oStruct, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

//Definicao da Chave Primaria
oModel:SetPrimaryKey({"ZZL_FILIAL", "ZZL_AREA"})

//Adiciona Descricao do Modelo de Dados
oModel:SetDescription( 'Modelo de Dados das Permissoes Internas' )

//Adiciona Descricao do Componente do Modelo de Dados      
oModel:GetModel( 'ID_FLD_Perm' ):SetDescription('Formulario dos Dados das Permissoes Internas')

Return(oModel)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ViewDef  � Autor � Fernando Nogueira  � Data � 01/11/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de Visualizacao.                                    ���
���          � Onde eh definido a visualizacao da Regra de Negocio.       ���
�������������������������������������������������������������������������͹��
���Uso       � Aula de MVC                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ViewDef()

Local oStruct	:=	FWFormStruct(2,"ZZL") 	    //Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
Local oModel	:=	FwLoadModel('Perm_Interna')	//Retorna o Objeto do Modelo de Dados 
Local oView		:=	FwFormView():New()          //Instancia do Objeto de Visualiza��o

//Define o Modelo sobre qual a Visualizacao sera utilizada
oView:SetModel(oModel)	

//Vincula o Objeto visual de Cadastro com o modelo 
oView:AddField( 'ID_VIEW_Perm', oStruct, 'ID_FLD_Perm')

Return(oView)  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Internos()  � Autor � Fernando Nogueira  � Data �07/04/2015���
�������������������������������������������������������������������������͹��
���Descri��o � Validacao para chamada dos Movimentos Internos             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                   	                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Internos()

Local cEOL := Chr(13)+Chr(10)

dbSelectArea("ZZL")
dbSetOrder(1)

If (dbSeek(xFilial("ZZL")+"1"+RetCodUsr()) .And. ZZL->ZZL_PERMIS == '1') .Or. aScan(PswRet(1)[1][10],'000000') <> 0
	MATA240()
Else
	ApMsgInfo("Usu�rio n�o Autorizado!"+cEOL+"Entrar em contato com o gerente da Log�stica.")
Endif

Return
