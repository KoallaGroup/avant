#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MonCont  � Autor � Fernando Nogueira  � Data �  05/12/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Monitoramento de Contabilizacao off-line                   ���
�������������������������������������������������������������������������͹��
���Uso       � AVANT                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MonCont()                                      
Static oDlg
Static oButton1
Static oButton2
Static oSay1
Static oSay2
Static oSay3
Static oSay4

  DEFINE MSDIALOG oDlg TITLE "Monitoramento da Contabiliza��o" FROM 000, 000  TO 190, 250 COLORS 0, 16777215 PIXEL

    @ 020, 020 SAY oSay1 PROMPT "Faltam:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 040, 025 SAY oSay2 PROMPT "Total:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 020, 060 SAY oSay3 SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 040, 060 SAY oSay4 SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 070, 015 BUTTON oButton1 PROMPT "Atualizar" SIZE 037, 012 OF oDlg ACTION alert("teste") PIXEL
    @ 070, 070 BUTTON oButton1 PROMPT "Sair" SIZE 037, 012 OF oDlg ACTION oDlg:End() PIXEL
  ACTIVATE MSDIALOG oDlg CENTERED

Return

