#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GATTZ1   � Autor � Eduardo Jmk        � Data �  01/10/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Gatilha os campos relacionados ao cliente no Cadastro      ���
���          � TRANSP x FILIAL                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AVANT.                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/    

  User Function GATTZ1()        
    Local cRetorno :=""
   	Local aArea    := SB1->(GetArea())
    Local cCliente := M->Z1_CLIENTE + M->Z1_LOJA
    DbSelectarea("SA1")
		SA1->(DbSetorder(1))
		If SA1->(DbSeek(xFilial("SA1") + cCliente))
		   cRetorno     := SA1->A1_EST
		   M->Z1_MUNCLI := SA1->A1_MUN 
		   M->Z1_CGC    := SA1->A1_CGC   
        EndIf     
  	RestArea(aArea)    
  Return cRetorno	     
	    

