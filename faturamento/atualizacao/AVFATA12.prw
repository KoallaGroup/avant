#include "TOTVS.ch"

/*----------------------+--------------------------------+------------------+
|   Programa: AVFATA12  | Autor: Kley@TOTVS              | Data: 28/04/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao:  Calend�rio do Planejamento de Compras
+---------------------------------------------------------------------------+
|    Projeto:  AVANT
+---------------------------------------------------------------------------+
|    Sintaxe:  U_AVFATA12()
+----------------------------------------------------------------------------
|    Retorno:  Nulo                                                               
+--------------------------------------------------------------------------*/

User Function AVFATA12()

AxCadastro("SZY","Calend�rio do Planejamento de Compras")

Return

/*----------------------+--------------------------------+------------------+
|   Programa: AVFATE12  | Autor: Kley@TOTVS              | Data: 28/04/2014 |
+-----------------------+--------------------------------+------------------+
|  Descricao:  Condi��o para edi��o do campo A1_MSBLQL (F3_WHEN)
+---------------------------------------------------------------------------+
|    Projeto:  AVANT
+---------------------------------------------------------------------------+
| Par�metros:  cCodUsr = C�digo do usu�rio logado
+----------------------------------------------------------------------------
|    Retorno:  lRet    = .T. -> Habilita edi��o / .F. -> Desabilita edi��o                                                               
+--------------------------------------------------------------------------*/

User Function AVFATE12(cCampo)

Local aAreaSZY	:= SZY->(GetArea())
Local lRet			:= .T.
Local dFimPerAnt	:= CtoD("  /  /  ")
Local dIniPerPos	:= CtoD("31/12/30")
Local d1oDia		:= StoD(M->ZY_ANO+M->ZY_MES+"01")				// Primeiro dia do M�s informado
Local dUltDia		:= LastDate(d1oDia)								// �ltimo dia do M�s informado
Local d1oDiaAnt	:= MonthSub(StoD(M->ZY_ANO+M->ZY_MES+"01"),1) // Primeiro dia do m�s anterior ao informado
Local dUltDiaPos	:= MonthSum(LastDate(dUltDia),1)				// �ltimo dia do m�s posterior ao informado

dbSelectArea("SZY")
SZY->(dbSetOrder(1))

If SZY->(dbSeek(xFilial("SZY")+Transform(Year(d1oDiaAnt),"@E9999")+PadL(Transform(Month(d1oDiaAnt),"@R99"),2,"0")))	// Per�odo anterior
	dFimPerAnt := SZY->ZY_DTFIM
EndIf
If SZY->(dbSeek(xFilial("SZY")+Str(Year(dUltDiaPos))+PadL(Str(Month(dUltDiaPos)),2,"0")))	// Per�odo anterior
	dIniPerPos := SZY->ZY_DTINI
EndIf

If AllTrim(cCampo) == "ZY_DTINI"
	If !Empty(M->ZY_DTFIM) .and. M->ZY_DTINI >= M->ZY_DTFIM
		MsgAlert("A Data Inicial deve ser menor que Data Final.","Data inv�lida")
		lRet := .F.                                            
	ElseIf M->ZY_DTINI < d1oDiaAnt 
		MsgAlert("A Data Inicial deve ser maior que o 1� dia do m�s anterior.","Data inv�lida")
		lRet := .F.                                            
	ElseIf M->ZY_DTINI > dUltDia 
		MsgAlert("A Data Inicial deve ser menor que o �ltimo dia do m�s para o per�odo.","Data inv�lida")
		lRet := .F.
	ElseIf M->ZY_DTINI <= dFimPerAnt 
		MsgAlert("A Data Inicial deve ser maior que a Data Final do per�odo anterior.","Data inv�lida")
		lRet := .F.
	ElseIf M->ZY_DTINI >= dIniPerPos 
		MsgAlert("A Data Inicial deve ser menor que a Data Inicial do per�odo posterior.","Data inv�lida")
		lRet := .F.
	EndIf                                          
ElseIf AllTrim(cCampo) == "ZY_DTFIM"
	If !Empty(M->ZY_DTINI) .and. M->ZY_DTFIM <= M->ZY_DTINI
		MsgAlert("A Data Final deve ser maior que Data Final.","Data inv�lida")
		lRet := .F.                                            
	ElseIf M->ZY_DTFIM < d1oDia 
		MsgAlert("A Data Final deve ser maior que o 1� dia do m�s para o per�odo.","Data inv�lida")
		lRet := .F.                                            
	ElseIf M->ZY_DTFIM > dUltDiaPos 
		MsgAlert("A Data Final deve ser menor que o �ltimo dia do m�s posterior.","Data inv�lida")
		lRet := .F.
	ElseIf M->ZY_DTFIM <= dFimPerAnt 
		MsgAlert("A Data Final deve ser maior que a Data Final do per�odo anterior.","Data inv�lida")
		lRet := .F.
	ElseIf M->ZY_DTFIM >= dIniPerPos 
		MsgAlert("A Data Final deve ser menor que a Data Inicial do per�odo posterior.","Data inv�lida")
		lRet := .F.
	EndIf                                          
EndIf

SZY->(RestArea(aAreaSZY))
Return lRet