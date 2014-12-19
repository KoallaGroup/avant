#Include "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ESP1NOME � Autor � Fernando Nogueira  � Data � 23/09/13    ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada utilizado para troca do nome do modulo    ���
���          � especifico                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                   	                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ESP1NOME
Return ("Help-Desk")

// Checa Licenca de Uso do Modulo
User Function Licenciado()
Local aArea := GetArea()
Local cLicenca := GetMv("MV_HDLICE")

cLicenca := Embaralha(cLicenca,1) // Desembaralha Licenca

If AllTrim(SM0->M0_PSW) <> cLicenca
	MsgStop('Aten��o M�dulo Help-Desk N�o est� Liberado para Utiliza��o nesta Empresa!')
	RestArea(aArea)
	Return .f.
Endif     
RestArea(aArea)
Return .t.