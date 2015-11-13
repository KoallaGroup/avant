#Include "Protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � xProxNum � Autor � Fernando Nogueira   � Data � 02/09/2015 ���
�������������������������������������������������������������������������Ĵ��
���Descri�ao � Definicao do proximo NumSeq                                ���
���          � O sistema estah perdendo a sequencia para os Pedidos que   ���
���          � sao gerados pelo execauto e liberados automaticamente no   ���
���          � credito na geracao do DCF                                  ���
�������������������������������������������������������������������������Ĵ��
���Utilizacao� AVANT                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function xProxNum()

Local cNumSeq   := ""
Local cNumSeq1  := ""
Local cNumSeq2  := ""
Local cAliasTRB := GetNextAlias()
Local nTamSeq	:= TamSx3("D3_NUMSEQ")[1]

BeginSQL Alias cAliasTRB
	SELECT MAX(NUMSEQ) NUMSEQ FROM
	(SELECT MAX(D1_NUMSEQ) NUMSEQ FROM %Table:SD1%
	UNION
	SELECT MAX(D2_NUMSEQ) NUMSEQ FROM %Table:SD2%
	UNION
	SELECT MAX(D3_NUMSEQ) NUMSEQ FROM %Table:SD3%
	UNION
	SELECT MAX(DCF_NUMSEQ) NUMSEQ FROM %Table:DCF%) QRY_NUMSEQ
EndSQL

cNumSeq1 := Soma1(PadR((cAliasTRB)->NUMSEQ    ,nTamSeq),,,.T.)
cNumSeq2 := Soma1(PadR(SuperGetMv("MV_DOCSEQ"),nTamSeq),,,.T.)

If cNumSeq1 >= cNumSeq2
	cNumSeq := cNumSeq1
Else
	cNumSeq := cNumSeq2
Endif

PutMV("MV_DOCSEQ",cNumSeq)

(cAliasTRB)->(DbCloseArea())

Return cNumSeq