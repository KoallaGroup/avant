#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F200VAR  � Autor � Fernando Nogueira  � Data � 05/12/2014  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada do Arquivo de Retorno do CNAB             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function F200VAR()

/*
���������������������������������Ŀ
�   	 Posicoes do Array        �
�---------------------------------�
� [01] - Numero do titulo         � <<<<
� [02] - Data da Baixa            �
� [03] - Tipo do Titulo           �
� [04] - Nosso Numero             �
� [05] - Valor da Despesa         �
� [06] - Valor do Desconto        � 
� [07] - Valor do Abatimento      �
� [08] - Valor Recebido           �
� [09] - Juros                    �
� [10] - Multa                    �
� [11] - Outras Despesas          �
� [12] - Valor do Credito         �
� [13] - Data do Credito          �
� [14] - Ocorrencia               � <<<<
� [15] - Motivo da Baixa      	  �
� [16] - Linha Inteira            � <<<<
� [17] - Data de Vencimento       �
�����������������������������������
*/    

Local aAreaSE1  := SE1->(GetArea())
Local aValores	:= ParamIXB[01]
Local cOcorCnab := aValores[14]
Local cCartBanc	:= Substr(aValores[16],58,01)
Local cNumTit	:= AllTrim(Substr(aValores[16],059,15))
Local cIdCnab   := AllTrim(aValores[01])

// Posiciona na Amarracao Cart. Banco x Cart. Sistema
SZF->(dbSelectArea("SZF"))
SZF->(dbSetOrder(01))
SZF->(dbGoTop())

If SZF->(dbSeek(xFilial("SZF")+cBanco+cCartBanc))
	SE1->(dbSelectArea("SE1"))
	SE1->(dbSetOrder(19))      //IDCNAB
	SE1->(dbGoTop())
 
	If !Empty(cIdCnab) .And. SE1->(dbSeek(cIdCnab)) .And. SE1->E1_SITUACA <> SZF->ZF_CRTSIST
		SE1->(RecLock("SE1",.F.))
		SE1->E1_SITUACA := SZF->ZF_CRTSIST
		SE1->(MsUnLock())
	Else
		SE1->(dbSetOrder(01))      //Numero do Titulo
		SE1->(dbGoTop())
		
		If !Empty(cIdCnab) .And. SE1->(dbSeek(xFilial("SE1")+cNumTit)) .And. SE1->E1_SITUACA <> SZF->ZF_CRTSIST
			SE1->(RecLock("SE1",.F.))
			SE1->E1_SITUACA := SZF->ZF_CRTSIST
			SE1->(MsUnLock())
		Endif
	Endif
Endif

SE1->(RestArea(aAreaSE1))

Return