#INCLUDE "Protheus.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M410LIOK � Autor � Fernando Nogueira  � Data �  28/10/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada na validacao de linha do Pedido de Vendas.���
���          � Chamado 000022.                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function M410LIOK()

Local lReturn := .T.
Local nPosQtdVen := aScan(aHeader,{|x|Trim(x[2])=="C6_QTDVEN"})
Local nPosQtdLib := aScan(aHeader,{|x|Trim(x[2])=="C6_QTDLIB"})
Local nPosLocal  := aScan(aHeader,{|x|Trim(x[2])=="C6_LOCAL"})
Local nPosOper   := aScan(aHeader,{|x|Trim(x[2])=="C6_OPER"})
Local nPosProd   := aScan(aHeader,{|x|Trim(x[2])=="C6_PRODUTO"})


If aCols[n][nPosQtdLib] > 0 .And. aCols[n][nPosQtdVen] > aCols[n][nPosQtdLib]
	MsgInfo('N�o � permitido libera��o parcial!', 'Aten��o')
	lReturn := .F.
ElseIf AllTrim(aRotina[3][2]) <> 'A410Copia' .And. Inclui .And. Empty(aCols[n][nPosOper]) .And. !aCols[n][Len(aHeader)+1]
	MsgInfo('Obrigat�rio o preenchimento do Tipo de Opera��o!', 'Aten��o')
	lReturn := .F.
ElseIf Empty(M->C5_CLIENTE)
	MsgInfo('Necess�rio definir o Cliente antes de Incluir uma Linha!', 'Aten��o')
	aCols[n][nPosOper] := Space(02)
	lReturn := .F.
ElseIf Empty(M->C5_TRANSP)
	MsgInfo('Necess�rio definir a Transportadora antes de Incluir uma Linha!', 'Aten��o')
	aCols[n][nPosOper] := Space(02)
	lReturn := .F.
Endif


If n <> 1 .AND. !aCols[n,Len(aHeader)+1]
	If Posicione("SB1",1,xFilial("SB1")+aCols[n][nPosProd],"B1_UTLCOMS") <> Posicione("SB1",1,xFilial("SB1")+aCols[n-1][nPosProd],"B1_UTLCOMS")
		MsgAlert('Existe conflito de produtos que geram comiss�o com produtos que n�o geram! Ser� necess�rio fazer pedidos separados.', 'Aten��o')
		lReturn := .F.
	Endif  
Endif


//If AllTrim(SM0->M0_CODFIL) == "010104" .And. aScan(PswRet(1)[1][10],'000057') == 0 .And. aCols[n][nPosLocal] <> '01'
//	MsgInfo('Estoque diferente de "01" somente � permitido aos usu�rios de log�stica!', 'Aten��o')
//	lReturn := .F.
//Endif
	
Return lReturn