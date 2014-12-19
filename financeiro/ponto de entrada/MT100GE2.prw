/*
Programa.: 	MT100GE2.PRW 
Autor....:	Pedro Augusto
Data.....: 	Maio/2014 
Descricao: 	Ponto de entrada criado para gerar alcada de aprovacao para o titulo gerado
			no momento da inclusao do documento de entrada
Uso......: 	AVANT
*/

#include "PROTHEUS.ch"

User Function MT100GE2()

//Local _cNum		:= SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) 
Local _cNum		:= SE2->(E2_PREFIXO+E2_NUM+E2_TIPO+E2_FORNECE+E2_LOJA+E2_PARCELA) 
Local _aAreaSE2	:= SE2->(GetArea())
Local _cGrAprov	:= Alltrim(GetMV("MV_XGRAPRO"))
Local _lRet		:= .T.

SY1->(DbSetOrder(3))
If SY1->(DbSeek(xFilial("SY1")+__cUserId))
	If Empty(SY1->Y1_X_GRPFI)
		_cGrAprov	:= Alltrim(GetMV("MV_XGRAPRO"))
		MsgAlert("N�o existe Grupo de Aprova��o do Financeiro relacionado ao seu cadastro de Comprador."+CRLF+;
				 "Por favor, solicite a equipe de TI que providencie este cadastro."+CRLF+;
				 "Os Titulos a Pagar ser�o gerados para o Grupo de Aprova��o padr�o do sistema: " + _cGrAprov,"Al�ada de Aprova��o")
	Else
		_cGrAprov	:= SY1->Y1_X_GRPFI
	EndIf
Else
	_cGrAprov	:= Alltrim(GetMV("MV_XGRAPRO"))
	MsgAlert("Seu usu�rio n�o est� cadastrado como Comprador, e por isso n�o foi possivel buscar o Grupo de Aprovacao relacionado ao seu usu�rio."+CRLF+;
			 "Por favor, solicite a equipe de TI que providencie este cadastro."+CRLF+;
			 "Os Titulos a Pagar ser�o gerados para o Grupo de Aprova��o padr�o do sistema: " + _cGrAprov,"Al�ada de Aprova��o")
EndIf

RecLock("SE2",.F.,.t.)
	SE2->E2_X_USUAR := __cUserId
SE2->(MsUnlock())  

MAAlcDoc({_cNum,"TP",SE2->E2_VALOR ,,,_cGrAprov,,1,1,SE2->E2_EMISSAO},,1)  

RestArea( _aAreaSE2 )

Return