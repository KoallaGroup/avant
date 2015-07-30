#Include "Protheus.Ch"           
#Include "TopConn.Ch"              
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GrvLaudo    � Autor � Fernando Nogueira  � Data �28/07/2015���
�������������������������������������������������������������������������͹��
���Descri��o � Faz a gravacao do laudo do SOTA modificado  				  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                   	                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GrvLaudo()

//Local cPathDoc  := 'c:\modelos\Troca_'+SF1->F1_NUMTRC+'.doc'
//Local cPathGrv  := '\web\ws\trocas\'+SF1->F1_NUMTRC+'\'

Local cPathDoc  := 'c:\modelos\Troca_000001.doc'
Local cPathGrv  := '\web\ws\trocas\000001\'

SZH->(dbSetOrder(1))

//If SZH->(dbSeek(xFilial()+SF1->F1_NUMTRC))

	If File(cPathDoc)
		If CpyT2S(cPathDoc,cPathGrv,.T.)
			ApMsgInfo("Laudo Gravado.")
		Else
			ApMsgInfo("Falha na Grava��o do Laudo")
		Endif
	Else
		ApMsgInfo("Laudo da Troca "+SF1->F1_NUMTRC+" n�o encontrado.")
	Endif
//Else
//	ApMsgInfo("Essa nota n�o � de Troca!")
//Endif	

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GrvLaudo    � Autor � Fernando Nogueira  � Data �28/07/2015���
�������������������������������������������������������������������������͹��
���Descri��o � Faz a gravacao do laudo do SOTA modificado  				  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                   	                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AbreLaudo()

Local cPathEst  := 'c:\modelos\'
//Local cArquivo := '\web\ws\trocas\'+SF1->F1_NUMTRC+'\troca_'+SF1->F1_NUMTRC+'.doc'
Local cArquivo := '\web\ws\trocas\000001\troca_000001.doc'

//Cria o diretorio local para copiar o documento Word
MontaDir(cPathEst)

SZH->(dbSetOrder(1))

//If SZH->(dbSeek(xFilial()+SF1->F1_NUMTRC))
	If File(cArquivo)
		CpyS2T(cArquivo,cPathEst,.T.)
		Sleep(5000)
		shellExecute("Open", "C:\modelos\Troca_000001.doc", "", "C:\", 1 )
	Else
		ApMsgInfo("Laudo da Troca "+SF1->F1_NUMTRC+" n�o encontrado.")
	Endif
//Else
//	ApMsgInfo("Essa nota n�o � de Troca!")
//Endif	

Return