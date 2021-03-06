#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Web Service � Impostos      � Autor � Fernando Nogueira    � Data �02/06/2016���
�������������������������������������������������������������������������������͹��
���Descricao   � Gera uma tabela generica de impostos para uso na web           ���
�������������������������������������������������������������������������������͹��
���Uso         � Especifico AVANT.                                              ���
�������������������������������������������������������������������������������͹��
���Analista Resp.    �   Data   � Manutencao Efetuada                           ���
�������������������������������������������������������������������������������͹��
���                  �          �                                               ���
�������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
*/
User Function Impostos(aParam)

//������������������������������Ŀ
//�aParam     |  [01]   |  [02]  |
//�           | Empresa | Filial |
//��������������������������������

Local aTabelas	:= {"SA1", "SC5", "SC6", "SC9", "SD2", "SF2", "SF4", "SF5", "SFM", "SB1", "SB2", "SB9","ZZI","ZIA"}
Local cEmpCons	:= aParam[01]
Local cFilCons	:= aParam[02]
Local cLog		:= ""
Local cFileLog	:= "IMPOSTOS.LOG"
Local cPathLog	:= "\LOGS\"

RpcClearEnv()
RPCSetType(3)
RpcSetEnv(cEmpCons, cFilCons, NIL, NIL, "FAT", NIL, aTabelas)

cLog += Replicate( "-", 128 ) + CRLF
cLog += Replicate( " ", 128 ) + CRLF
cLog += "LOG DA ATUALIZA��O DA TABELA DE IMPOSTOS" + CRLF
cLog += Replicate( " ", 128 ) + CRLF
cLog += Replicate( "-", 128 ) + CRLF
cLog += CRLF
cLog += " Dados Ambiente" + CRLF
cLog += " --------------------"  + CRLF
cLog += " Empresa / Filial...: " + cEmpAnt + "/" + cFilAnt  + CRLF
cLog += " Nome Empresa.......: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_NOMECOM", cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
cLog += " Nome Filial........: " + Capital( AllTrim( GetAdvFVal( "SM0", "M0_FILIAL" , cEmpAnt + cFilAnt, 1, "" ) ) ) + CRLF
cLog += " DataBase...........: " + DtoC( dDataBase )  + CRLF
cLog += " Data / Hora �nicio.: " + DtoC( Date() )  + " / " + Time()  + CRLF
cLog += " Environment........: " + GetEnvServer()  + CRLF
cLog += " StartPath..........: " + GetSrvProfString( "StartPath", "" )  + CRLF
cLog += " RootPath...........: " + GetSrvProfString( "RootPath" , "" )  + CRLF
cLog += " Vers�o.............: " + GetVersao(.T.)  + CRLF
cLog += " Usu�rio TOTVS .....: " + __cUserId + " " +  cUserName + CRLF
cLog += " Computer Name......: " + GetComputerName() + CRLF

ZZI->(dbSetOrder(01))
ZZI->(dbGoTop())

// Limpa a Tabela ZIA somente de Domingo
If Dow(dDataBase) == 1
	TcSqlExec("DELETE FROM "+RetSqlName(("ZIA")))
	While ZZI->(!Eof())
		ZZI->(Reclock("ZZI",.F.))
			ZZI->ZZI_GERA := "1" // Eh para gerar a tabela de impostos
		ZZI->(MsUnlock())
		
		ZZI->(dbSkip())
	End
Endif

ZZI->(dbGoTop())

ZIA->(dbSetOrder(01))
ZIA->(dbGoTop())

SA1->(dbSetOrder(01))
SB1->(dbSetOrder(01))

While ZZI->(!Eof())

	SB1->(dbGoTop())
	
	If ZZI->ZZI_GERA == "1"
		
		While SB1->(!Eof())
			If SB1->B1_MSBLQL <> '1' .And. SB1->B1_TIPO $ ('PA.PR') .And. SB1->B1_X_BLWEB <> 'S'
				If SA1->(dbSeek(xFilial("SA1") + ZZI->ZZI_CLIENT + ZZI->ZZI_LOJA))
					GeraZIA()
				Endif
			Endif
			SB1->(dbSkip())
		End
		
		ZZI->(Reclock("ZZI",.F.))
			ZZI->ZZI_GERA := "2" // Nao eh para gerar mais
		ZZI->(MsUnlock())

	Else
		While SB1->(!Eof())
			If SB1->B1_MSBLQL <> '1' .And. SB1->B1_TIPO $ ('PA.PR') .And. SB1->B1_X_BLWEB <> 'S' .And. !ZIA->(dbSeek(xFilial("ZIA")+SB1->B1_COD+ZZI->(ZZI_UF+ZZI_TIPO)))
				If SA1->(dbSeek(xFilial("SA1") + ZZI->ZZI_CLIENT + ZZI->ZZI_LOJA))
					GeraZIA()
				Endif
			Endif
			SB1->(dbSkip())
		End	
	Endif
	
	ZZI->(dbSkip())	
End

cLog += Replicate( "-", 128 ) + CRLF
cLog += " Data / Hora Final.: " + DtoC( Date() ) + " / " + Time()  + CRLF
cLog += Replicate( "-", 128 ) + CRLF
cLog += Replicate( " ", 128 ) + CRLF

MemoWrite(cPathLog+cFileLog, cLog)

RpcClearEnv()

Return

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  � GeraZIA   � Autor � Fernando Nogueira  � Data  � 18/10/2016 ���
��������������������������������������������������������������������������Ĵ��
���Descricao � Gera um item da tabela de impostos                          ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function GeraZIA()

Local cTpOper	:= "51" //Venda
Local cTesOper	:= ""
Local nItem		:= 0
Local aImpostos	:= {}
Local nVlrIcm	:= 0
Local nAlqIcdst	:= 0
Local nVlrIpi	:= 0
Local nVlrIcc	:= 0
Local nVlrDif	:= 0
Local nVlrPis	:= 0
Local nVlrCof	:= 0
Local nVlrRet	:= 0
Local nDescSuf	:= 0
Local nMargem	:= 0                                                                                                                      

//Inicializa a Funcao Fiscal
MaFisIni(	SA1->A1_COD		,;		// 01-Codigo Cliente
			SA1->A1_LOJA	,;		// 02-Loja do Cliente
			"C"				,;		// 03-C:Cliente , F:Fornecedor
			"N"				,;		// 04-Tipo da NF
			SA1->A1_TIPO	,;		// 05-Tipo do Cliente
			Nil				,;		// 06-Relacao de Impostos que suportados no arquivo
			Nil				,;		// 07-Tipo de complemento
			Nil				,;		// 08-Permite Incluir Impostos no Rodape .T./.F.
			"SB1"			,;		// 09-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
			"MATA461"		,;		// 10-Nome da rotina que esta utilizando a funcao
			Nil				,;		// 11-Tipo de documento
			Nil				,;		// 12-Especie do documento 
			Nil				,;		// 13-Codigo e Loja do Prospect 
			Nil				,;		// 14-Grupo Cliente
			Nil				,;		// 15-Recolhe ISS
			Nil				,;		// 16-Codigo do cliente de entrega na nota fiscal de saida
			Nil				,;		// 17-Loja do cliente de entrega na nota fiscal de saida
			Nil				)		// 18-Informacoes do transportador [01]-UF,[02]-TPTRANS

//Recupera a TES de Saida para a Operacao Informada
cTesOper := MaTesInt(02, cTpOper, SA1->A1_COD, SA1->A1_LOJA, "C", SB1->B1_COD, NIL)

//Adiciona o Produto para Calculo dos Impostos
nItem := 	MaFisAdd(	SB1->B1_COD	,;   	// 1-Codigo do Produto ( Obrigatorio )
						cTesOper	,;	   	// 2-Codigo do TES ( Opcional )
						100			,;	   	// 3-Quantidade ( Obrigatorio )
						1			,;   	// 4-Preco Unitario ( Obrigatorio )
						0			,;  	// 5-Valor do Desconto ( Opcional )
						""			,;	   	// 6-Numero da NF Original ( Devolucao/Benef )
						""			,;		// 7-Serie da NF Original ( Devolucao/Benef )
						0			,;		// 8-RecNo da NF Original no arq SD1/SD2
						0			,;		// 9-Valor do Frete do Item ( Opcional )
						0			,;		// 10-Valor da Despesa do item ( Opcional )
						0			,;		// 11-Valor do Seguro do item ( Opcional )
						0			,;		// 12-Valor do Frete Autonomo ( Opcional )
						100			,;		// 13-Valor da Mercadoria ( Obrigatorio )
						0			,;		// 14-Valor da Embalagem ( Opiconal )
						NIL			,;		// 15-RecNo do SB1
						NIL			,;		// 16-RecNo do SF4
						NIL			)

aImpostos	:= MafisRet(NIL, "NF_IMPOSTOS")
nPosIcm		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "ICM"})
nPosIpi		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "IPI"})
nPosIcc		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "ICC"})
nPosDif		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "DIF"})
nPosPis		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "PS2"})
nPosCof		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "CF2"})
nPosRet		:= Ascan(aImpostos, {|x| AllTrim(x[01]) == "ICR"})

If nPosIcm > 0
	nVlrIcm := aImpostos[nPosIcm][05]
EndIf

If nPosIpi > 0
	nVlrIpi := aImpostos[nPosIpi][05]
EndIf

If nPosIcc > 0
	nVlrIcc := aImpostos[nPosIcc][05]
EndIf

If nPosDif > 0
	nVlrDif := aImpostos[nPosDif][05]
EndIf

If nPosPis > 0
	nVlrPis := aImpostos[nPosPis][05]
EndIf

If nPosCof > 0
	nVlrCof := aImpostos[nPosCof][05]
EndIf

If nPosRet > 0
	nAlqIcdst := aImpostos[nPosRet][04]
	nVlrRet   := aImpostos[nPosRet][05]
EndIf

If SA1->A1_CALCSUF = 'S'
	nDescSuf := MafisRet(,"IT_DESCZF")
Endif

// Chamado 003707 - Fernando Nogueira
If ValType(MafisRet(,"IT_EXCECAO")) == 'A' .And. Len(MafisRet(,"IT_EXCECAO")) >= 3
	nMargem	:= MafisRet(,"IT_EXCECAO")[3]
Endif

//Finaliza Funcao Fiscal
MaFisEnd()

// Inclusao na Tabela de Impostos
dbSelectArea('ZIA')
RecLock("ZIA",.T.)
ZIA->ZIA_FILIAL := xFilial("ZIA")
ZIA->ZIA_COD	:= SB1->B1_COD
ZIA->ZIA_UF		:= SA1->A1_EST
ZIA->ZIA_TIPO	:= ZZI->ZZI_TIPO
ZIA->ZIA_VALICM	:= nVlrIcm
ZIA->ZIA_DIFAL	:= nVlrDif
ZIA->ZIA_ICMCOM	:= nVlrIcc
ZIA->ZIA_ICMRET	:= nVlrRet
ZIA->ZIA_VALIPI	:= nVlrIpi
ZIA->ZIA_VALPIS := nVlrPis
ZIA->ZIA_VALCOF	:= nVlrCof
ZIA->ZIA_DESCZF	:= nDescSuf
ZIA->ZIA_MARGEM	:= nMargem
ZIA->ZIA_ICMDST := nAlqIcdst
MsUnlock()

Return