#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FISVALNFE() � Autor � Fernando Nogueira  � Data �01/03/2016���
�������������������������������������������������������������������������͹��
���Descri��o � Ponto de Entrada na Validacao da Nota para Transmissao     ���
���          � Chamado 002640                                             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT                    	                      ���
�������������������������������������������������������������������������͹��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������͹��
���              �  /  /  �                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FISVALNFE()

Local aAreaSF2 	:= SF2->(GetArea())
Local cTipoMov	:= PARAMIXB[1]
Local cNota		:= PARAMIXB[4]
Local cSerie	:= PARAMIXB[5]
Local cCliente	:= PARAMIXB[6]
Local cLoja		:= PARAMIXB[7]
Local cPedido	:= ""

SF2->(dbSetOrder(01))

If cTipoMov == 'S' .And. SF2->(dbSeek(xFilial("SF2")+cNota+cSerie+cCliente+cLoja)) .And. SF2->F2_TIPO == 'N' .And. SF2->F2_VOLUME1 == 0 .And. SF2->F2_FILIAL = '010104'
	ConOut("Nota "+SF2->F2_DOC+", falta definir o volume.")
	SF2->(RestArea(aAreaSF2))
	Return .F.
Endif

SF2->(RestArea(aAreaSF2))

Return .T.
