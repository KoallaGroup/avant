#include "Protheus.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MandMail � Autor � Fernando Nogueira  � Data �  06/01/2014 ���
�������������������������������������������������������������������������͹��
���Descricao � Conecta ao servidor de e-mail e envia o e-mail             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MandMail(cTo, cCC, cBCC, cSubject, cBody, cAttach)
	
	Local cMsgErro := ""
	//Local StartPath:= GetSrvProfString("Startpath","")
	Local cSMTPServer := GetMV( 'MV_RELSERV',, ''  ) 			//--Obtem endereco do servidor SMTP
	Local lSMTPAuth   := GetMV( 'MV_RELAUTH',, .T. )  	   //--Define se o Serv. SMTP exige autenticacao
	Local cAccount    := GetMV( 'MV_RELACNT',, ''  ) 			//--Conta para autenticacao
	Local cPassword   := GetMV( 'MV_RELAPSW',, ''  )			//--Senha
	Local cMailFrom   := GetMV( 'MV_RELFROM',, ''  )			//--Obtem e-mail do Remetente
	Local lConnect    := .F.
	Local lEnviado    := .F.
	
	//cAttach := StartPath+cAttach
	
	Connect SMTP SERVER cSMTPServer ACCOUNT cAccount PASSWORD cPassword RESULT lConnect

		If lConnect .And. If( lSMTPAuth, MailAuth( cAccount, cPassword ), .T. )
	
		SEND MAIL FROM cMailFrom ;
				     TO cTo ;
				     CC cCC ;
				     BCC cBCC ;
				     SUBJECT cSubject ;
				     BODY cBody ;
		           ATTACHMENT cAttach ;
					 RESULT lEnviado  
	
		If !lEnviado
			GET MAIL ERROR cMsgErro 
			Conout("----------- ERRO AO TENTAR ENVIAR E-MAIL  -------------------")
			Conout("N�o foi poss�vel enviar o e-mail. Erro abaixo '"+cMsgErro+"'")
		Endif
			
		DISCONNECT SMTP SERVER Result lDisConectou
	Else
		Conout("----------- ERRO AO TENTAR ENVIAR E-MAIL  -------------------")
		Conout("N�o foi poss�vel conectar ao servidor de e-mail.")
	Endif   
	
Return Nil