#Include "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MatImp   � Autor �TOTVS               � Data �             ���
�������������������������������������������������������������������������͹��
���Desc.     � Importacao cadastro de Produtos conforme arquivo disponivel���
���          � pelo cliente.                                              ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 10									    		  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MatImp()

Local aArea		:= GetArea()
Local _aProd	:= {}
Local _aProdMal	:= {}
Local aRet		:= {}

Local nQtde		:= 0
Local _cCodProd := ""
Local _cLocPad  := ""

IF Select("TRC") > 0
	DbSelectArea("TRC")
	dbCLOSEArea()
ENDIF

_cArqSeq:= "\import\saldimp"
dbUseArea(.T.,,_cArqSeq,"TRC",.F.,.F.)
IndRegua("TRC",_cArqSeq,"CODIGO",,,"Selecionando Registros...")
//IndRegua("TRC",_cArqSeq,"FILIAL+CODIGO",,,"Selecionando Registros...")
DbSelectArea("TRC")
DbGotop()
ProcRegua(LastRec()) // Numero de registros a processar

While TRC->(!Eof())
	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua                                                  �
	//�����������������������������������������������������������������������
	//��������������������������������������������������������������Ŀ
	//� Estrutura do array para importacao dos dados                 �
	//� COLUNA 01- Codigo do produto                                 �
	//� COLUNA 02- Almoxarifado                                      �
	//� COLUNA 03- Lote                                              �
	//� COLUNA 04- Data de validade do Lote                          �
	//� COLUNA 05- Localizacao                                       �
	//� COLUNA 06- Numero de Serie                                   �
	//� COLUNA 07- Quantidade                                        �
	//� COLUNA 08- Quantidade na segunda UM                          �
	//� COLUNA 09- Valor do movimento Moeda 1                        �
	//� COLUNA 10- Valor do movimento Moeda 2                        �
	//� COLUNA 11- Valor do movimento Moeda 3                        �
	//� COLUNA 12- Valor do movimento Moeda 4                        �
	//� COLUNA 13- Valor do movimento Moeda 5                        �
	//����������������������������������������������������������������
	//	aadd(_aProd,{Substr(TRC->MATERIAL,1,15),ALLTRIM(TRC->ARMAZEM),ALLTRIM(TRC->LOTE),IIF(Empty(TRC->VALIDADE),CTOD("__/__/__"),CTOD(TRC->VALIDADE)),ALLTRIM(TRC->ENDERECO),"",TRC->QTDE,0,TRC->VALOR,0,0,0,0})
	//	aadd(_aProd,{PADR(AllTrim(Str(TRC->CODIGO)),15),ALLTRIM(TRC->ALMOXARIFA),"",CTOD("__/__/__"),PADR(ALLTRIM(TRC->ENDERECO),15),"",TRC->QUANTIDADE,0,TRC->VALORI,0,0,0,0})
	
	IncProc()
	   	//dbSelectArea("SB1")
		//dbSetOrder(1)
		//If dbSeek( xFilial("SB1")+AllTrim(TRC->CODIGO) )
		//	_cCodProd := SB1->B1_COD
			
		//	If TRC->QUANTIDADE > 0
//				Aadd(_aProd,{_cCodProd,_cLocPad,TRC->LOTE,TRC->DATAV,TRC->ENDE,TRC->NUM_SERIE,TRC->QUANTIDADE,0,TRC->VALORI,0,0,0,0})
//                            Cod      ,Almox    , Lote     , Dt Val   ,Ender     ,Num Serie     , Qtd            ,0, Valor,
				Aadd(_aProd,{TRC->CODIGO,TRC->ALMOX,TRC->LOTE,TRC->DATAV,TRC->ENDE,TRC->NUM_SERIE,TRC->QUANTIDADE,0,TRC->VALORI,0,0,0,0})
		//	EndIf
	    //Else
		//	Aadd(_aProdMal,{TRC->CODIGO,TRC->ALMOX,TRC->LOTE,TRC->DATAV,TRC->ENDE,TRC->NUM_SERIE,TRC->QUANTIDADE,0,TRC->VALORI,0,0,0,0})
		//EndIf

	
	TRC->(DbSkip())
Enddo

// O retorno tem que ser um array contendo outro array
AADD(aRet,_aProd)

DbSelectArea("TRC")
DbcloseArea()
fErase("TRC"+Ordbagext())

RestArea(aArea)

Return(aRet)                                                                  