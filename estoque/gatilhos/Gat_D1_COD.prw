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
User Function Gat_D1_COD()

Local _cProd    := M->D1_COD
Local _nPosTes  := ""
Local _nPosLote := ASCAN(aHeader,{|x|x[2] = 'D1_LOTECTL'})
Local _cTes     := ""
Local _cLote    := aCols[n][_nPosLote]
Local _cCtrLote := Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_RASTRO")
Local _cTesTipo := ""
Local _cTesEst  := ""

// Fernando Nogueira - Chamado 000463
If AllTrim(FUNNAME()) <> 'MATA140'
	_nPosTes  := ASCAN(aHeader,{|x|x[2] = 'D1_TES'})
	_cTes     := aCols[n][_nPosTes]
	_cTesTipo := Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_TIPO")
	_cTesEst  := SF4->F4_ESTOQUE
Endif

// Tipo da Nota de Devolucao e Produta controla lote
If cTipo = "D" .And. _cCtrLote = "L" .And. Empty(_cLote) .And. !Empty(_cTes)
   
	// Tes de Entrada que controla estoque
	If _cTesTipo = "E" .And. _cTesEst = "S"
		_cLote := Formula("018")
	Endif

EndIf

Return _cLote