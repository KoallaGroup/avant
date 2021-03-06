#Include "Totvs.ch"
#Include "FwMvcDef.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PedidoWeb � Autor � Fernando Nogueira  � Data � 19/09/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro do Pedido Web no Protheus                         ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PedidoWeb()

Private oBrowse := FwMBrowse():New() 

//Alias do Browse
oBrowse:SetAlias('SZ3')

//Descri��o da Parte Superior Esquerda do Browse
oBrowse:SetDescripton("Pedido Web") 

//Habilita os Bot�es Ambiente e WalkThru
oBrowse:SetAmbiente(.T.)
oBrowse:SetWalkThru(.T.)

//Desabilita os Detalhes da parte inferior do Browse
oBrowse:DisableDetails()

//Ativa o Browse
oBrowse:Activate()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MenuDef  � Autor � Fernando Nogueira  � Data � 19/09/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Menu do Browse                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MenuDef()

Local aMenu :=	{}
	
	ADD OPTION aMenu TITLE 'Pesquisar'  ACTION 'PesqBrw'       		OPERATION 1 ACCESS 0
	ADD OPTION aMenu TITLE 'Visualizar' ACTION 'VIEWDEF.PedidoWeb'	OPERATION 2 ACCESS 0
	ADD OPTION aMenu TITLE 'Incluir'    ACTION 'VIEWDEF.PedidoWeb' 	OPERATION 3 ACCESS 0
	ADD OPTION aMenu TITLE 'Alterar'    ACTION 'VIEWDEF.PedidoWeb' 	OPERATION 4 ACCESS 0
	ADD OPTION aMenu TITLE 'Excluir'    ACTION 'VIEWDEF.PedidoWeb' 	OPERATION 5 ACCESS 0
	ADD OPTION aMenu TITLE 'Imprimir'   ACTION 'VIEWDEF.PedidoWeb'	OPERATION 8 ACCESS 0
	ADD OPTION aMenu TITLE 'Copiar'     ACTION 'VIEWDEF.PedidoWeb'	OPERATION 9 ACCESS 0
	
Return(aMenu)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ModelDef � Autor � Fernando Nogueira  � Data � 19/09/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de Modelo de Dados.                                 ���
���          � Onde � definido a estrutura de dados                       ���
���          � Regra de Negocio.                                          ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ModelDef()

Local oStruSZ3 := FWFormStruct(1,'SZ3', /*bAvalCampo*/, /*lViewUsado*/) //Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
Local oStruSZ4 := FWFormStruct(1,'SZ4', /*bAvalCampo*/, /*lViewUsado*/) //Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
Local oModel

oStruSZ3:SetProperty('Z3_NPEDWEB',MODEL_FIELD_INIT,{||ProxWeb()})

//Instancia do Objeto de Modelo de Dados
oModel := MpFormModel():New('MDPEDWEB',/*Pre-Validacao*/,/*Pos-Validacao*/,/*Commit*/,/*Cancel*/)

//Adiciona um modelo de Formulario de Cadastro Similar � Enchoice ou Msmget
oModel:AddFields('ID_MODEL_FLD_PedidoWeb', /*cOwner*/, oStruSZ3, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/)

//Setando a chave primaria da rotina
oModel:SetPrimaryKey({'Z3_FILIAL','Z3_NPEDWEB'})
                               		
//Adiciona um Modelo de Grid somilar � MsNewGetDados, BrGetDb
oModel:AddGrid('ID_MODEL_GRD_PedidoWeb', 'ID_MODEL_FLD_PedidoWeb', oStruSZ4, /*bLinePre*/, {|oModel| PosValid(oModel)}, /*bPreVal*/, /*bPosVal*/, /*BLoad*/)

// Faz relaciomaneto entre os compomentes do model
oModel:SetRelation('ID_MODEL_GRD_PedidoWeb', {{'Z4_FILIAL', 'xFilial("SZ4")'}, {'Z4_NUMPEDW', 'Z3_NPEDWEB'}}, 'Z4_FILIAL + Z4_NUMPEDW')

//Liga o controle de n�o repeti��o de Linha
oModel:GetModel('ID_MODEL_GRD_PedidoWeb'):SetUniqueLine({'Z4_ITEMPED'})

// Indica que � opcional ter dados informados na Grid
//oModel:GetModel( 'ID_MODEL_FLD_PedidoWeb' ):SetOptional(.T.)

//Adiciona Descricao do Modelo de Dados
oModel:SetDescription('Modelo de Dados do Pedido Web')

//Adiciona Descricao dos Componentes do Modelo de Dados
oModel:GetModel('ID_MODEL_FLD_PedidoWeb'):SetDescription('Formulario do Pedido Web')
oModel:GetModel('ID_MODEL_GRD_PedidoWeb'):SetDescription('Grid do Pedido Web')

Return(oModel)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ViewDef  � Autor � Fernando Nogueira  � Data � 19/09/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao de Visualizacao.                                    ���
���          � Onde � definido a visualizacao da Regra de Negocio.        ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ViewDef()

Local oStruSZ3	:=	FWFormStruct(2,'SZ3') 	 //Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
Local oStruSZ4	:=	FWFormStruct(2,'SZ4') 	 //Retorna a Estrutura do Alias passado como Parametro (1=Model,2=View)
Local oModel	:=	FwLoadModel('PedidoWeb') //Retorna o Objeto do Modelo de Dados 
Local oView		:=	FwFormView():New()       //Instancia do Objeto de Visualiza��o

//Define o Modelo sobre qual a Visualizacao sera utilizada
oView:SetModel(oModel)

//Retira um campo da Estrutura da View
oStruSZ4:RemoveField('Z4_NUMPEDW')
oStruSZ4:RemoveField('Z4_VALEPRE')

//Vincula o Objeto visual de Cadastro com o modelo 
oView:AddField('ID_VIEW_FLD_PedidoWeb', oStruSZ3, 'ID_MODEL_FLD_PedidoWeb')

//Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
oView:AddGrid('ID_VIEW_GRD_PedidoWeb', oStruSZ4, 'ID_MODEL_GRD_PedidoWeb')

//Define o Preenchimento da Janela
oView:CreateHorizontalBox('ID_HBOX_SUPERIOR', 40)
oView:CreateHorizontalBox('ID_HBOX_INFERIOR', 60)

// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView('ID_VIEW_FLD_PedidoWeb', 'ID_HBOX_SUPERIOR')
oView:SetOwnerView('ID_VIEW_GRD_PedidoWeb', 'ID_HBOX_INFERIOR')

// Define campos que terao Auto Incremento
oView:AddIncrementField('ID_VIEW_GRD_PedidoWeb', 'Z4_ITEMPED')

// Executa acao no cancelamento
oView:SetViewAction('BUTTONCANCEL', {|oView| If(Inclui,VoltaNum(M->Z3_NPEDWEB),Nil)})

Return(oView)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PosValid � Autor � Fernando Nogueira  � Data � 19/09/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Pos validacao da linha do Grid                             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PosValid(oModel)

Local lRet    := .T.
Local nLine   := 0
Local cTpOper := ""

nLine   := oModel:GetLine()
cTpOper := oModel:GetValue("Z4_TPOPERW")

If Empty(cTpOper)
	Help(,,'HELP',,"� preciso definir o Tipo de Opera��o no Cabe�alho."+CHR(13)+CHR(10)+"Depois confirmar o c�digo do produto.",1,0,)
	lRet := .F.
Endif

oModel:GoLine(nLine)

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ProxWeb  � Autor � Fernando Nogueira  � Data � 20/09/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � Proximo numero Web                                         ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ProxWeb()

Local nNumProx  := 0
Local nNumProx1 := 0
Local nNumProx2 := 0
Local nNumProx3 := 0
Local cAliasTRB := GetNextAlias()

BeginSQL Alias cAliasTRB
	SELECT MAX(Z3_NPEDWEB)+1 NUMPROX FROM %Table:SZ3%
	WHERE Z3_FILIAL = %Exp:xFilial("SZ3")%
EndSQL

nNumProx1 := (cAliasTRB)->NUMPROX
nNumProx2 := Val(Posicione("SX5",1,xFilial("SX5")+"ZA0007","X5_DESCRI"))
nNumProx3 := Val(Posicione("SX5",1,xFilial("SX5")+"ZA0008","X5_DESCRI"))

If nNumProx1 >= nNumProx2
	nNumProx := nNumProx1
Else
	nNumProx := nNumProx2
Endif

If SX5->(dbSeek(xFilial("SX5")+"ZA0008"))
	SX5->(RecLock("SX5",.F.))
		SX5->X5_DESCRI := STRZERO(nNumProx+2,10)
	SX5->(MsUnlock())
Endif	

If nNumProx > nNumProx3 .And. !SZ3->(dbSeek(xFilial("SZ3")+PadL(Alltrim(cValToChar(nNumProx3)),TamSx3("Z3_NPEDWEB")[01])))
	nNumProx := nNumProx3
Else
	If SX5->(dbSeek(xFilial("SX5")+"ZA0007"))
		SX5->(RecLock("SX5",.F.))
			SX5->X5_DESCRI := STRZERO(nNumProx+1,10)
		SX5->(MsUnlock())
	Endif
Endif

(cAliasTRB)->(DbCloseArea())

Return nNumProx

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � VoltaNum � Autor � Fernando Nogueira     � Data � 20/09/2016  ���
����������������������������������������������������������������������������͹��
���Desc.     � Disponibiliza o numero web para ser utilizado em outro Pedido ���
����������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                              ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function VoltaNum(_nNum)


If SX5->(dbSeek(xFilial("SX5")+"ZA0008"))
	If Val(SX5->X5_DESCRI) > _nNum
		SX5->(RecLock("SX5",.F.))
			SX5->X5_DESCRI := STRZERO(_nNum,10)
		SX5->(MsUnlock())
	Endif
Endif

Return