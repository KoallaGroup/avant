#Include "PROTHEUS.CH"   
#Include "Totvs.ch"
//--------------------------------------------------------------
/*/{Protheus.doc} Avant - PROJETO EDI TRANSPORTE
DOCUMENTO DE COBRAN�A
Description

@param xParam Parameter Description
@return xRet Return Description
@author  - cristian_werneck@hotmail.com
@since 23/05/2011
/*/
//--------------------------------------------------------------

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AV_EDI01  �Autor  �Cristian Werneck    � Data �  12-20-11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina MBrowse para o controle EDI de Transporte - documento���
���          �de cobran�a                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Avant                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AV_EDI01()
Local oBrowse
Local bLegenda		:= { || NIL }
Private aMksColor	:= {}

/*/
��������������������������������������������������������������Ŀ
� Definindo os Resources                  					   �
����������������������������������������������������������������/*/
aMksColor	:= Array( 03 , 03 )
aMksColor[ 1 , 1 ]	:= "BR_VERDE"		; aMksColor[ 1 , 2 ] := "em Analise"
aMksColor[ 2 , 1 ]	:= "BR_VERMELHO"	; aMksColor[ 2 , 2 ] := "Gerado"
aMksColor[ 3 , 1 ]	:= "BR_PRETO"		; aMksColor[ 3 , 2 ] := "Outros"

/*/
��������������������������������������������������������������Ŀ
� Obtendo os Resources                  					   �
����������������������������������������������������������������/*/
aMksColor[ 1 , 3 ]	:= LoadBitmap( GetResources() , aMksColor[ 1 , 1 ] )
aMksColor[ 2 , 3 ]	:= LoadBitmap( GetResources() , aMksColor[ 2 , 1 ] )
aMksColor[ 3 , 3 ]	:= LoadBitmap( GetResources() , aMksColor[ 2 , 1 ] )
aBmpLeg				:= Array( 3 )
aBmpLeg[1] 			:= aMksColor
aBmpLeg[2] 			:= NIL
bBmpLeg			 	:= { | lLegend | U_InGdBmpExec( "BmpLeg" , @aBmpLeg ) }

// Instanciamento da Classe de Browse
oBrowse := FWMBrowse():New()

// Defini��o da tabela do Browse
oBrowse:SetAlias('ZZ4')

// Defini��o da legenda
oBrowse:AddLegend( "ZZ4_STATUS == 'A'"		,'GREEN' 	, "em Analise"	)
oBrowse:AddLegend( "ZZ4_STATUS == 'G'"		,'RED'   	, "Gerado"		)
oBrowse:AddLegend( "!ZZ4_STATUS $ 'G|A'"	,'BLACK'	, "Outros"			)

// Titulo da Browse
oBrowse:SetDescription(OemToAnsi("Documento de Cobranca -  EDI de Transporte"))
oBrowse:Activate()

Return NIL

Static Function MenuDef()

Local aRotina := {}
//aAdd( aRotina, { 'Imp Docto cobran'	, 'U_AV_EDIIMP'						, 0, 3, 0, NIL } )	//Amedeo (Rotina antiga de Importacao arquivo por arquivo)
//aAdd( aRotina, { 'Imp Docto cobran'	, 'U_AV_EDMPCOB'					, 0, 3, 0, NIL } )	//Amedeo (Nova rotina - Importacao da pasta completa)
aAdd( aRotina, { 'Docto cobran�a'	, 'U_AV_EDICOB'						, 0, 2, 0, NIL } )
aAdd( aRotina, { 'Legenda' 			, 'U_MPBmpLeg( aMksColor , .T. )'	, 0, 8, 0, NIL } )

Return aRotina