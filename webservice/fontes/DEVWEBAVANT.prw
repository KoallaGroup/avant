#INCLUDE "APWEBSRV.CH"
#INCLUDE "PROTHEUS.CH"

User Function DEVWEBAV()
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � DEVWEBAV    � Autor � Fernando Nogueira  � Data �01/05/2014���
�������������������������������������������������������������������������͹��
���Descri��o � WebService para integracao de Devolucao WEB (AVANT)        ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                                          ���
�������������������������������������������������������������������������͹��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������͹��
���              �  /  /  �                                        	      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
WSSERVICE DEVWEBAVANT DESCRIPTION "Integracao de Devolucao Web (AVANT)"
	WSDATA 	 EmpIntegra	As String
	WSDATA 	 FilIntegra	As String
	WSDATA 	 Parametro	As String
	WSDATA 	 aRetorno 	As RETDEVOL
	WSMETHOD CONNECT DESCRIPTION "Integracao de Devolucao Web (AVANT)"
ENDWSSERVICE

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
��� WSMETHOD � CONNECT     � Autor � Fernando Nogueita  � Data �  01/05/2014 ���
����������������������������������������������������������������������������͹��
���Desc.     � Metodo de Integracao.                                         ���
����������������������������������������������������������������������������͹��
���Uso       � Especifico AVANT.                                             ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
WSMETHOD CONNECT WSRECEIVE EmpIntegra, FilIntegra, Parametro WSSEND aRetorno WSSERVICE DEVWEBAVANT
	Local lRetorno 		:= .T.
	Local cMensagem		:= ""
	Local cDocumen		:= ""

	ConOut(Time() + " - 01 - Iniciando Integracao")

	If Empty(EmpIntegra) .Or. Empty(FilIntegra) .Or. Empty(Parametro)
		lRetorno	:= .F.
		ConOut(Time() + " - 02 - Parametros faltando")
		::aRetorno 	:= WSClassNew("RETDEVOL")
		::aRetorno:Mensagem	:= "Algum parametro obrigat�rio n�o foi enviado, integracao n�o ser� processada"
	EndIf
	
	If lRetorno
		
		ConOut(Time() + " - 02 - Processando Integracao")

		lRetorno := U_IntNFDev(EmpIntegra, FilIntegra, Parametro, @cMensagem, @cDocumen, .T.)
		
		::aRetorno 	:= WSClassNew("RETDEVOL")

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
WSSTRUCT RETDEVOL

	WSDATA Mensagem		As String OPTIONAL
	WSDATA Documento	As String OPTIONAL

ENDWSSTRUCT
