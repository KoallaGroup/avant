#Include "PROTHEUS.CH"
#Include "Totvs.ch"

/*/
�����������������������������������������������������������������������Ŀ
�Fun��o    �BmpLeg    	 �Autor�Marinaldo de Jesus    � Data �26/10/2005�
�����������������������������������������������������������������������Ĵ
�Descri��o �Retorna informacoes de Legenda para a GetDads do SRA        �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �<vide parametros formais>									�
�����������������������������������������������������������������������Ĵ
�Parametros�<vide parametros formais>									�
�����������������������������������������������������������������������Ĵ
�Uso       �GdBmp()	                                                	�
�������������������������������������������������������������������������/*/
User Function MPBmpLeg( aMksColor , lLegend )

Local aSvKeys
Local aBmpLegend

Local cResourceName

Local nLoop
Local nLoops

Begin Sequence

DEFAULT lLegend := .F.
IF ( lLegend )
	aSvKeys 	:= GetKeys()
EndIF

nLoops		:= Len( aMksColor )
aBmpLegend	:= Array( nLoops , 2 )
For nLoop := 1 To nLoops
	aBmpLegend[ nLoop , 1 ] := aMksColor[ nLoop , 1 ]
	aBmpLegend[ nLoop , 2 ] := aMksColor[ nLoop , 2 ]
Next nLoop

IF ( lLegend )
	BrwLegenda( OemToAnsi( 'Legenda' ) , 'Status' , aBmpLegend )
Else
	cResourceName := GetResource( aBmpLegend )
EndIF

End Sequence

IF ( lLegend )
	RestKeys( aSvKeys , .T. )
EndIF

Return( cResourceName )
