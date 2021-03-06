#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GATTPOPW � Autor � Amedeo D. P. Filho � Data �  18/07/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Gatilha o Tipo de Operacao WEB.                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AVANT.                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GATTPOPW
	Local cRetorno	:= ""
	Local cCampo	:= Alltrim(&(ReadVar()))
	Local nPosProd 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
	Local cProduto	:= aCols[n][nPosProd]
	Local aAreaB1	:= SB1->(GetArea())
	Local aAreaC5	:= SC5->(GetArea())
	Local aAreaC6	:= SC6->(GetArea())


	    DbSelectarea("SB1")
		SB1->(DbSetorder(1))
		If SB1->(DbSeek(xFilial("SB1") + cProduto))
			If SB1->B1_ORIGEM == "0" .AND. cCampo =="51"
	           cRetorno := "VENDA NACIONAL"
		    ElseIf SB1->B1_ORIGEM == "0" .AND. cCampo == "54"
			    cRetorno := "BONIFICACAO NAC" 
		    ElseIf SB1->B1_ORIGEM != "0" .AND. cCampo == "51"
			    cRetorno := "VENDA" 
		    ElseIf SB1->B1_ORIGEM != "0" .AND. cCampo == "54"
			    cRetorno := "BONIFICACAO"    
			ElseIf cCampo == "08"
				cRetorno := "TROCA"    
			EndIf    
	    EndIf
		   	
	RestArea(aAreaB1)
	RestArea(aAreaC5)
	RestArea(aAreaC6)
	
Return cRetorno