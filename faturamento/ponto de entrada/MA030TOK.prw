#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA030TOK  � Autor � Rodrigo Leite      � Data �  08/12/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Valida�ao do campo CNPJ e Cod.Mun                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MA030TOK ()

valida   := .F. 
Private nCliente :=M->A1_NOME 
Private cCliente :=M->A1_COD


IF !EMPTY (M->A1_CGC)
	IF M->A1_TIPO <> "X"
		valida:= .T.
    ELSE                         
        ALERT("O campo CNPJ n�o deve ser preenchido para Cliente tipo Exporta�ao")
        valida:= .F.
    ENDIF    
ELSE 
	IF M->A1_TIPO = "X"
		valida:= .T.
    ELSE 
        ALERT("O Campo CNPJ n�o foi preenchido")
        valida:= .F.
    ENDIF
ENDIF
                         

IF valida 
   If EMPTY(M->A1_COD_MUN) .and. M->A1_TIPO != "X"
	   ALERT("O Campo Cod. Municipio n�o esta preenchido")
        valida:= .F.
    EndIf
ENDIF



If M->A1_XREGESP = "S"
	If M->A1_TIPO <> "R" .OR. M->A1_GRPTRIB <> "060" .OR. M->A1_INSCR = " " .OR. M->A1_INSCR = "ISENTO"
		valida := .F.
		Msginfo("Cliente com Regime Especial. Verifique os campos de: Tipo, Grupo Trib. e Inscri��o Estadual.")
	EndIf
Else
	If Empty(M->A1_XREGESP)
		valida := .F.
		MsgInfo("Campo Regime Especial vazio.")
	EndIf
EndIf


Return(valida)