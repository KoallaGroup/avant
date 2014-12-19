#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

User Function PEDWEBAV()
Return Nil

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
��� Web Service � PEDWEBAVANT �Autor  � Amedeo D.P.Filho � Data �  21/03/12  ���
����������������������������������������������������������������������������͹��
���Descricao    � WebService para integracao de pedidos WEB (AVANT)          ���
���             �                                                            ���
����������������������������������������������������������������������������͹��
���Uso          � Especifico AVANT.                                          ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
WSSERVICE PEDWEBAVANT DESCRIPTION "Integracao de pedidos Web (AVANT)"
	WSDATA 	 EmpIntegra	As String
	WSDATA 	 FilIntegra	As String
	WSDATA 	 Parametro	As String
	WSDATA 	 aRetorno 	As RETINTEGRA
	WSMETHOD CONNECT DESCRIPTION "Integracao de pedidos Web (AVANT)"
ENDWSSERVICE

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
��� WSMETHOD � CONNECT     � Autor � Amedeo D.P. Filho  � Data �  21/03/12   ���
����������������������������������������������������������������������������͹��
���Desc.     � Metodo de Integracao.                                         ���
����������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                                             ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
WSMETHOD CONNECT WSRECEIVE EmpIntegra, FilIntegra, Parametro WSSEND aRetorno WSSERVICE PEDWEBAVANT
	Local lRetorno 		:= .T.
	Local cMensagem		:= ""
	Local cDocumen		:= ""

	ConOut(Time() + " - 01 - Iniciando Integracao")

	If Empty(EmpIntegra) .Or. Empty(FilIntegra) .Or. Empty(Parametro)
		lRetorno	:= .F.
		ConOut(Time() + " - 02 - Parametros faltando")
		::aRetorno 	:= WSClassNew("RETINTEGRA")
		::aRetorno:Mensagem	:= "Algum parametro obrigat�rio n�o foi enviado, integracao n�o ser� processada"
	EndIf
	
	If lRetorno
		
		ConOut(Time() + " - 02 - Processando Integracao")

		lRetorno := U_INTPEDIDO(EmpIntegra, FilIntegra, Parametro, @cMensagem, @cDocumen, .T.)
		
		::aRetorno 	:= WSClassNew("RETINTEGRA")

		If !lRetorno
			ConOut(Time() + " - 03 - Erro na Integracao " + cMensagem)
			::aRetorno:Mensagem := cMensagem
		Else
			ConOut(Time() + " - 03 - Integracao realizada com sucesso Documento " + cDocumen)
			::aRetorno:Documento := cDocumen
		EndIf			

	Else
		ConOut(Time() + " - 03 - Integracao nao sera realizada ")
	EndIf
	
	ConOut(Time() + " - 04 - Finalizando Integracao")

Return (.T.)

//�����������������������������������������Ŀ
//� Estrutura de Retorno              		�
//�������������������������������������������
WSSTRUCT RETINTEGRA

	WSDATA Mensagem		As String OPTIONAL
	WSDATA Documento	As String OPTIONAL

ENDWSSTRUCT
