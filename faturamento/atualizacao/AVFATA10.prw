#include "TOTVS.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: AVFATA10  | Autor: Kley@TOTVS              | Data: 24/03/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao:  Cadastro de Regional
+---------------------------------------------------------------------------+
|    Projeto:  AVANT
+---------------------------------------------------------------------------+
|    Sintaxe:  U_AVFATA10()
+----------------------------------------------------------------------------
|    Retorno:  Nulo                                                               
+--------------------------------------------------------------------------*/

User Function AVFATA10()

AxCadastro("SZZ","Cadastro de Regional")

Return

/*----------------------+--------------------------------+------------------+
|   Programa: AVFATE10  | Autor: Kley@TOTVS              | Data: 21/05/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao:  Condi��o para edi��o do campo ZZ_GERENC (F3_WHEN)
+---------------------------------------------------------------------------+
|    Projeto:  AVANT
+---------------------------------------------------------------------------+
| Par�metros:  Nulo
+----------------------------------------------------------------------------
|    Retorno:  lRet    = .T. -> Habilita edi��o / .F. -> Desabilita edi��o                                                               
+--------------------------------------------------------------------------*/

User Function AVFATE10(cCampo)

Local aAreaAnt	:= GetArea()
Local aAreaSA3	:= SA3->(GetArea())
Local aAreaSUM	:= SUM->(GetArea())
Local lRet			:= .T.

If INCLUI .or. ALTERA
	If !Empty(M->ZZ_GERENC)
		dbSelectArea("SA3")
		If SA3->(dbSeek(xFilial("SA3")+M->ZZ_GERENC))
			dbSelectArea("SUM")
			If SUM->(dbSeek(xFilial("SUM")+SA3->A3_CARGO))
				If !("GERENTE" $ upper(SUM->UM_DESC) .and. ("REGIONAL" $ upper(SUM->UM_DESC) .or. "NACIONAL" $ upper(SUM->UM_DESC)))
					MsgAlert('O Cargo do Gerente informado n�o � "GERENTE REGIONAL".'+CRLF+CRLF+;
							  'Verifique o cadastro do Gerente, em Cadastro de Vendedores. � necess�rio que o CARGO seja "GERENTE REGIONAL".',"Gerente n�o � Gerente Regional")
					lRet := .F.
				EndIf 	
			Else
				MsgAlert("Cargo do Gerente n�o localizado."+CRLF+CRLF+;
						  '� necess�rio informar o CARGO do respectivo Gerente como "GERENTE REGIONAL" ou "GERENTE NACIONAL".',"Cargo do Gerente n�o localizado")
				lRet := .F.
			EndIf
		Else
			MsgAlert('Cadastro do Gerente n�o localizado.'+CRLF+CRLF+;
					  '� necess�rio cadastrar o Gerente em Cadastro de Vendedores, e informar o cargo "GERENTE REGIONAL" ou "GERENTE NACIONAL".',"Gerente n�o localizado")
			lRet := .F.
		EndIf
	EndIf
EndIf

SUM->(RestArea(aAreaSUM))
SA3->(RestArea(aAreaSA3))
RestArea(aAreaAnt)

Return lRet