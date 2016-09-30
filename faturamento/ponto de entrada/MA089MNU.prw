#INCLUDE "Protheus.ch"
/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � MA089MNU � Autor � Fernando Nogueira  � Data � 30/09/2016 ���
������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada no Tes Inteligente para Adicionar funcao ���
���          � no Menu.                                                  ���
������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                          ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function MA089MNU

aAdd(aRotina,{"Import.TI", "U_ImpTI()", 0, 3, 0, .F.})

Return

/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � ImpTI    � Autor � Fernando Nogueira  � Data � 30/09/2016 ���
������������������������������������������������������������������������͹��
���Descricao � Importacao de Tes Inteligente                             ���
������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                          ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
User Function ImpTI()
Local   aSay     := {}
Local   aButton  := {}
Local   nOpc     := 0
Local   Titulo   := 'Importa��o de Tes Inteligente'
Local   cDesc1   := 'Esta rotina fara a Importa��o de Tes Inteligente'
Local   cDesc2   := ''
Local   cDesc3   := ''
Local   lOk      := .T.

aAdd(aSay, cDesc1)
aAdd(aSay, cDesc2)
aAdd(aSay, cDesc3)

aAdd(aButton, {1, .T., {|| nOpc := 1, FechaBatch()}})
aAdd(aButton, {2, .T., {|| FechaBatch()           }})

FormBatch(Titulo, aSay, aButton)

If nOpc == 1

	Processa({|| lOk := fRunproc()},'Aguarde','Processando...',.F.)

	If lOk
		ApMsgInfo('Processamento terminado com sucesso.', 'ATEN��O')

	Else
		ApMsgStop('Processamento realizado com problemas.', 'ATEN��O')

	EndIf

EndIf

Return

/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������ͻ��
���Programa  � Runproc  � Autor � Fernando Nogueira  � Data � 30/09/2016 ���
������������������������������������������������������������������������͹��
���Descricao � Processa a importacao                                     ���
������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                          ���
������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/
Static Function fRunproc()

Local aVetor := {}

PRIVATE lMsErroAuto := .F.

aVetor := {{"FM_FILIAL"  , xFilial("SFM"), Nil},;				 
			{"FM_TIPO"   , "52", Nil},;				 
			{"FM_TE"     , "", Nil},;
			{"FM_TS"     , "", Nil},;
			{"FM_CLIENTE", "", Nil},;
			{"FM_LOJACLI", "", Nil},;
			{"FM_FORNECE", "", Nil},;
			{"FM_LOJAFOR", "", Nil},;
			{"FM_EST"    , "", Nil},;
			{"FM_GRTRIB" , "", Nil},;
			{"FM_PRODUTO", "", Nil},;
			{"FM_GRPROD" , "", Nil},;
			{"FM_POSIPI" , "", Nil},;
			{"FM_REFGRD" , "", Nil},;
			{"FM_DESREF" , "", Nil},;
			{"FM_TIPOMOV", "", Nil},;
			{"FM_GRPTI"  , "", Nil},;
			{"FM_TIPOCLI", "", Nil},;
			{"FM_GRPCST" , "", Nil}}

MSExecAuto({|x,y| Mata089(x,y)}, aVetor, 03) //3- Inclusao, 4- Alteracao, 5- Exclusao 

If lMsErroAuto	
	Mostraerro()
	Return .F.
Else	
	Return .T.
Endif