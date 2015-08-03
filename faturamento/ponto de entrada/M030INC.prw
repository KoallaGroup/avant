#INCLUDE "Protheus.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � M030INC  � Autor � Rogerio Machado    � Data �  28/07/15   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada apos a inclusao de clientes.              ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function M030INC()

Local cPara    := M->A1_EMAIL
Local cBCC     := "rogerio.machado@avantled.com.br"
Local cAssunto := "Bem-vindo � Avant"
	
	cLog := "<html><body>"
	cLog += "<img src='http://avantled.com.br/BI/Bem%20Vindo.png'/>
	cLog += "</body></html>"

	If 	M->A1_X_WFLOW = " "
		U_MHDEnvMail(cPara, "", cBCC, cAssunto, cLog, "")
		SA1->(RecLock("SA1",.F.))
		SA1->A1_X_WFLOW := "S"
		SA1->(MsUnlock())
	EndIf

Return