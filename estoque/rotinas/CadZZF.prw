#Include "Totvs.ch"
#Include "FwMvcDef.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CadZZF   � Autor � Fernando Nogueira  � Data � 02/09/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de Familia de Produtos                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CadZZF()

Private oBrowse := FwMBrowse():New() 

oBrowse:SetAlias('ZZF')
oBrowse:SetDescripton("Cadastro de Familia de Produtos") 
oBrowse:Activate()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MenuDef  � Autor � Fernando Nogueira  � Data � 02/09/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Menu do Browse                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Definicoes de Menu                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MenuDef()
Local aMenu :=	{}
	
ADD OPTION aMenu TITLE 'Pesquisar'  ACTION 'PesqBrw'       	OPERATION 1 ACCESS 0
ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.CadZZF'	OPERATION 2 ACCESS 0
ADD OPTION aMenu TITLE 'Incluir'    ACTION 'VIEWDEF.CadZZF'	OPERATION 3 ACCESS 0
ADD OPTION aMenu TITLE 'Alterar'    ACTION 'VIEWDEF.CadZZF'	OPERATION 4 ACCESS 0
ADD OPTION aMenu TITLE 'Excluir'    ACTION 'VIEWDEF.CadZZF'	OPERATION 5 ACCESS 0
ADD OPTION aMenu TITLE 'Imprimir'   ACTION 'VIEWDEF.CadZZF'	OPERATION 8 ACCESS 0
ADD OPTION aMenu TITLE 'Copiar'     ACTION 'VIEWDEF.CadZZF'	OPERATION 9 ACCESS 0
	
Return(aMenu)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ModelDef � Autor � Fernando Nogueira  � Data � 02/09/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Definicao do Modelo de Dados                               ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ModelDef()

Local oStruZZF := FWFormStruct(1,"ZZF") 
Local oModel

oStruZZF:SetProperty('ZZF_CODIGO',MODEL_FIELD_INIT,{||GETSXENUM("ZZF","ZZF_CODIGO")})

oModel := MpFormModel():New('MdCadZZF',/*Pre-Validacao*/,/*Pos-Validacao*/,/*Commit*/,/*Cancel*/)
oModel:AddFields('ID_FLD_CadZZF', /*cOwner*/, oStruZZF, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
oModel:SetPrimaryKey({"ZZF_FILIAL", "ZZF_CODIGO"})
oModel:SetDescription('Modelo de Dados do Cadastro de Familia de Produtos')     
oModel:GetModel('ID_FLD_CadZZF'):SetDescription('Formulario de  Cadastro dos Dados de Familia de Produtos')

Return(oModel)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ViewDef  � Autor � Fernando Nogueira  � Data � 02/09/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de Visualizacao                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ViewDef()

Local oStruZZF := FWFormStruct(2,"ZZF")
Local oModel   := FwLoadModel('CadZZF') 
Local oView    := FwFormView():New()

oView:SetModel(oModel)	 
oView:AddField('ID_VIEW_CadZZF', oStruZZF, 'ID_FLD_CadZZF')

Return(oView)    