#Include "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SUBSTITUI � Autor �ROGERIO MACHADO     � Data �  28/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �SUBSTITUI CARACTERES DE UMA STRING                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESPECIFICO AVANT                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Substitui(cTexto,cStrAtual,cStrNova)

Local ni
Local cNovoTexto := ""

cTexto := AllTrim(cTexto)

For ni := 1 To Len(cTexto)
 If Substr(cTexto,ni,1) == cStrAtual
  cNovoTexto += cStrNova
 Else
  cNovoTexto += Substr(cTexto,ni,1)
 EndIf
Next ni

Return(cNovoTexto)