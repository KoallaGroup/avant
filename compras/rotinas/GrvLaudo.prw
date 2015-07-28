#Include "Protheus.Ch"           
#Include "TopConn.Ch"              
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Laudo_Troca � Autor � Fernando Nogueira  � Data �16/05/2014���
�������������������������������������������������������������������������͹��
���Descri��o � Monta Laudo_Troca.dot para o SOTA        				  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                   	                      ���
�������������������������������������������������������������������������͹��
���Analista Resp.�  Data  � Manutencao Efetuada                           ���
�������������������������������������������������������������������������͹��
���              �  /  /  �                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GrvLaudo()

Local cPathDoc  := 'c:\modelos\Troca_'+SF1->F1_NUMTRC+'.doc'
Local cPathGrv  := '\web\ws\trocas\'+SF1->F1_NUMTRC+'\'

SZH->(dbSetOrder(1))

If SZH->(dbSeek(xFilial()+SF1->F1_NUMTRC))

	If File(cPathDoc)
		If CpyT2S(cPathDoc,cPathGrv,.T.)
			ApMsgInfo("Laudo Gravado.")
		Else
			ApMsgInfo("Falha na Grava��o do Laudo")
		Endif
	Else
		ApMsgInfo("Laudo da Troca "+SF1->F1_NUMTRC+" n�o encontrado.")
	Endif
Else
	ApMsgInfo("Essa nota n�o � de Troca!")
Endif	

Return