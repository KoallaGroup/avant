#include "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ReembCli    � Autor � Fernando Nogueira  � Data �31/03/2014���
�������������������������������������������������������������������������͹��
���Descri��o � Gera Reembolso de Clientes                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                                          ���
�������������������������������������������������������������������������͹��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������͹��
���              �  /  /  �                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ReembCli()

cChave := 	PadR(cVarPref, TamSx3("E2_PREFIXO")[1]) +;
			PadR(cVarNum, TamSx3("E2_NUM")[1]) +;
			PadR(cVarParc, TamSx3("E2_PARCELA")[1]) +;
			PadR(cVarTipo, TamSx3("E2_TIPO")[1]) +;
			PadR(cFornece, TamSx3("E2_FORNECE")[1]) +;
			PadR(cLojaFor, TamSx3("E2_LOJA")[1])

DbSelectarea("SE2")
SE2->(DbSetorder(1))
If !SE2->(DbSeek(xFilial("SE2") + cChave))
	
	//Faz a inclusao do Titulo a Pagar
	Aadd(aValues,{"E2_FILIAL"	, xFilial("SE2")	, Nil	})
	Aadd(aValues,{"E2_PREFIXO"	, cVarPref			, Nil	})
	Aadd(aValues,{"E2_NUM"		, cVarNum			, Nil	})
	Aadd(aValues,{"E2_PARCELA"	, cVarParc			, Nil	})
	Aadd(aValues,{"E2_TIPO"		, cVarTipo			, Nil	})
	Aadd(aValues,{"E2_FORNECE"	, cFornece			, Nil	})
	Aadd(aValues,{"E2_LOJA"		, cLojaFor			, Nil	})
	Aadd(aValues,{"E2_VALOR"	, nVarValor			, Nil	})
	Aadd(aValues,{"E2_EMISSAO"	, dVarEmiss			, Nil	})
	Aadd(aValues,{"E2_VENCTO"	, dVarVenc			, Nil	})
	Aadd(aValues,{"E2_HIST"		, cVarHist			, Nil	})
	Aadd(aValues,{"E2_ORIGEM"	, cOrigem			, Nil	})

	lMsErroAuto	:= .F.
	
	oObjReg:SetRegua2( 1 )
	oObjReg:IncRegua2( "Importando T�tulo : " + cVarNum  )

	MSExecAuto({|a, b, c| FINA050(a, b, c)}, aValues, Nil, 3)
	
	If lMsErroAuto
		MostraErro()
	EndIf
                    
Else
	cMenExist += "Num.: " + cVarNum + " Parcela: " + cVarParc + CRLF
EndIf

Return