#include "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Gat_D1_COD() � Autor � Fernando Nogueira  � Data �12/12/2013���
�������������������������������������������������������������������������͹��
���Descri��o � Gatilho do Campo D1_COD                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                   	                      ���
�������������������������������������������������������������������������͹��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������͹��
���              �  /  /  �                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Gat_D1_COD(_cCampo)

Local _cProd       := M->D1_COD
Local _nPosTes     := ASCAN(aHeader,{|x|Trim(x[2])=='D1_TES'})
Local _nPosLote    := ASCAN(aHeader,{|x|Trim(x[2])=='D1_LOTECTL'})
Local _nPosNfOri   := ASCAN(aHeader,{|x|Trim(x[2])=='D1_NFORI'})
Local _nPosItemOri := ASCAN(aHeader,{|x|Trim(x[2])=='D1_ITEMORI'})
Local _nPosSeriOri := ASCAN(aHeader,{|x|Trim(x[2])=='D1_SERIORI'})
Local _nPosTotal   := aScan(aHeader,{|x|Trim(x[2])=='D1_TOTAL'} )
Local _cTes        := aCols[n][_nPosTes]
Local _cLote       := aCols[n][_nPosLote]
Local _cCtrLote    := Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_RASTRO")
Local _cTesTipo    := ""
Local _cTesEst     := ""
Local _cTesOri     := ""
Local _nTipoDev    := 2
Local _cReturn     := ""
Local _cTesDev     := ""

// Fernando Nogueira - Chamado 000463
If AllTrim(FUNNAME()) <> 'MATA140'
	_nPosTes  := ASCAN(aHeader,{|x|x[2] = 'D1_TES'})
	_cTes     := aCols[n][_nPosTes]
	_cTesTipo := Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_TIPO")
	_cTesEst  := SF4->F4_ESTOQUE
Endif

// Tipo da Nota de Devolucao e Produto controla lote
If cTipo = "D" .And. _cCtrLote = "L" .And. Empty(_cLote) .And. !Empty(_cTes)
   
	// Tes de Entrada que controla estoque
	If _cTesTipo = "E" .And. _cTesEst = "S"
		_cLote := Formula("018")
	Endif

EndIf

If !IsBlind() .And. cTipo = "D" .And. !Empty(aCols[n][_nPosNfOri]) .And. !Empty(aCols[n][_nPosItemOri]) .And. !Empty(aCols[n][_nPosSeriOri])
	_nTipoDev := MV_PAR26
	_cTesOri  := Posicione("SD2",3,xFilial("SD2")+aCols[n][_nPosNfOri]+aCols[n][_nPosSeriOri]+cA100For+cLoja+M->D1_COD+aCols[n][_nPosItemOri],"D2_TES")
	_cTesDev  := If(_nTipoDev==1,Posicione("SF4",1,xFilial("SF4")+_cTesOri,"F4_TESDV"),Posicione("SF4",1,xFilial("SF4")+_cTesOri,"F4_TESTRC"))
	If !Empty(_cTesDev)
		_cTes := _cTesDev
	Endif
Endif

If AllTrim (_cCampo) == "D1_LOTECTL"
	_cReturn := _cLote
ElseIf AllTrim (_cCampo) == "D1_TES"
	
	If !IsBlind()
		// Alimenta o campo com a Tes
		aCols[n][_nPosTes] := _cTes
		
		// Dispara gatilhos
		RunTrigger(2,n,nil,,'D1_TES')
		
		// Refaz o calculo dos impostos
		If MaFisFound("IT",n)
			If !Empty(aCols[n][_nPosTes])
				MaFisAlt("IT_TES",aCols[n][_nPosTes],n)
			EndIf
			If aCOLS[n][_nPosTotal]<>0
				MaFisToCols(aHeader,aCols,N,"MT100")
			EndIf
		EndIf
	Endif
	
	_cReturn := _cTes
Endif

Return _cReturn