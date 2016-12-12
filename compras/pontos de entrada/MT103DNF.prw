#Include "Protheus.Ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT103DNF()  � Autor � Fernando Nogueira  � Data �08/12/2016���
�������������������������������������������������������������������������͹��
���Descri��o � Ponto de Entrada na Confirmacao da Nota de Entrada         ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
���          � Chamado 004483                                             ���
�������������������������������������������������������������������������͹��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������͹��
���              �  /  /  �                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT103DNF()

Local lReturn   := .T.
Local cNFe      := Paramixb[1][13]
Local cTabEst   := "AC12AL27AM13AP16BA29CE23DF53ES32GO52MA21MG31MS50MT51PA15PB25PE26PI22PR41RJ33RN24RO11RR14RS43SC42SE28SP35TO17"  // Tabela de Estados
Local cCNPJ     := ""
Local aAreaSA1  := SA1->(GetArea())
Local aAreaSA2  := SA2->(GetArea())
Local aAreaSF1  := SF1->(GetArea())

If !(AllTrim(cEspecie) $ "SPED") .Or. cFormul == "S"
	Return lReturn
Endif

// Estado do Forn/Cliente
If cTipo $ 'NCIP'
	cEstForn := Posicione("SA2",1,xFilial("SA2")+cA100For+cLoja,"A2_EST")
	cCNPJ    := SA2->A2_CGC
Else
	cEstForn := Posicione("SA1",1,xFilial("SA1")+cA100For+cLoja,"A1_EST")
	cCNPJ    := SA1->A1_CGC
Endif

// Codigo do Estado
cCodEst := Subs(cTabEst,AT(cEstForn,cTabEst)+2,2)

SF1->(dbSetOrder(08))

If Empty(cNFe)                                               	// Campo em branco
	Alert("Obrigat�rio o preenchimento da Chave da NF-e!")      
	lReturn  := .F.
ElseIf Len(AllTrim(cNFe)) <> 44                           		// Chave com menos de 44 caracteres
	Alert("Faltando n�meros na Chave da NF-e!")
	lReturn  := .F.
ElseIf SF1->(dbSeek(xFilial("SF1")+cNFe))                    	// Chave jah Utilizada
	Alert("Chave j� utilizada em outra nota fiscal!")           
	lReturn  := .F.
ElseIf SubStr(cNFe,01,02) <> cCodEst                         	// Estado
	Alert("C�digo do Estado na Chave NF-e est� errado!")
	lReturn  := .F.
ElseIf SubStr(cNFe,03,04) <> SubStr(AnoMes(dDEmissao),03,04)	// Data: AAMM
	Alert("Data na Chave NF-e est� errada!")
	lReturn  := .F.
ElseIf SubStr(cNFe,07,14) <> cCNPJ                           	// CNPJ
	Alert("C�digo do CNPJ na Chave NF-e est� errado!")
	lReturn  := .F.
ElseIf !(Substr(cNFe,21,02) $ GetMv("ES_MODELNF"))           	// Modelo
	Alert("Modelo da NF na Chave NF-e est� errado!")
	lReturn  := .F.
ElseIf Substr(cNFe,23,03) <> StrZero(Val(cSerie),03)         	// Serie
	Alert("N�mero da S�rie na Chave NF-e est� errado!")
	lReturn  := .F.
ElseIf Substr(cNFe,26,09) <> StrZero(Val(cNFiscal),09)       	// Numero
	Alert("N�mero da Nota na Chave NF-e est� errado!")
	lReturn  := .F.
ElseIf Substr(cNFe,44,01) <> Modulo11(Substr(cNFe,01,43))    	// Digito Verificador
	Alert("Chave da NF-e est� errada!")
	lReturn  := .F.
Endif

SA1->(RestArea(aAreaSA1))
SA2->(RestArea(aAreaSA2))
SF1->(RestArea(aAreaSF1))

Return lReturn