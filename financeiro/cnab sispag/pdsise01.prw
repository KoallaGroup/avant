#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � PDSISE01 � Autor �Ricardo Arruda         � Data � 01/09/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Converte a Linha Digit�vel em C�digo de Barras  U_PDSISE01 ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CNAB SISPAG                                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function PDSISE01()
 
    cCodbar :=""  
                                                                             
    cBanco := Substr(M->E2_LINDIGT,1,4)
    cCampFree := Substr(M->E2_LINDIGT,5,5)+Substr(M->E2_LINDIGT,11,10)+Substr(M->E2_LINDIGT,22,10) 
    cDigCamp := Substr(M->E2_LINDIGT,33,1)  
    cRetSisp3 := Substr(M->E2_LINDIGT,34,4)
    cValCamp := Substr(M->E2_LINDIGT,38,10)
    
    cCodbar := cBanco+cDigCamp+cRetSisp3+cValCamp+cCampFree
    
return (cCodbar)
