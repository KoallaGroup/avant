#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT461VCT � Autor � Fernando Nogueira  � Data � 15/10/2014  ���
�������������������������������������������������������������������������͹��
���Descricao � Atualiza valor das parcelas quando tiver valor de frete,   ���
���          � que eh mantido integralmente na primeira parcela.          ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MT461VCT()

Local aParcelas := ParamIXB[1]
Local nParcelas := Len(aParcelas)
Local nFrete    := SF2->F2_FRETE
Local nVlrParc  := 0

If nFrete > 0

	nVlrParc  := nFrete / nParcelas

	For _nI := 1 to nParcelas	
		If _nI == 1
			aParcelas[_nI][2] += NoRound((nParcelas - 1) * nVlrParc, 2) 	
		Else
			aParcelas[_nI][2] -= NoRound(nVlrParc, 2)
		Endif 	
	Next _nI

Endif

Return aParcelas