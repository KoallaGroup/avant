#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSOBJECT.CH"
#include "TBICONN.CH"

User Function CLASSE00()
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Classe   � uExecAuto �Autor  � Amedeo D. P.Filho � Data �  11/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gravacao via Rotina Automatica: deve ser utilizada por     ���
���          � Heranca.                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Class uExecAuto
	Data aCabec							//Dados do Cabecalho
	Data aItens							//Dados dos Itens
	Data aItemTemp						//Array temporario para o Item
	Data aTabelas						//Array com as Tabelas que devem ser abertas na Preparacao do Ambiente
	Data aValues						//Dados para Gravacao

	Data dEmissao						//Data da Inclusao ou Alteracao do Registro

	Data cEmpBkp						//Backup da Empresa Original
	Data cFilBkp						//Backup da Filial Original
	Data cEmpGrv						//Empresa para Gravacao
	Data cFilGrv						//Filial para Gravacao

	Data cFileLog						//Nome do Arquivo para Gravacao de Log de Erro da Rotina Automatica
	Data cMensagem						//Mensagem de Erro
	Data cPathLog						//Caminho para Gravacao do Arquivo de Log
	Data lGravaLog						//Variavel para Gravacao do Arquivo de Log
	
	Method New()						//Inializacao do Objeto
	Method AddValues(cCampo, xValor)	//Adiciona dados para Gravacao
	Method GetMensagem()				//Retorno das Mensagens de Erro
	Method SetItem()					//Insere os dados do Item no Array dos Itens
	Method SetEnv(nOpcao, cModulo)		//Prepara o Ambiente para Execucao da Rotina Automatica
EndClass
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Method   � New      �Autor  � Amedeo D. P. Filho � Data �  11/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Inicializa o Objeto                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Method New() Class uExecAuto
	::aCabec		:= {}
	::aItens		:= {}
	::aItemTemp		:= {}
	::aTabelas		:= {}
	::aValues		:= {}
	
	::cEmpBkp		:= ""
	::cFilBkp		:= ""
	::cEmpGrv		:= ""
	::cFilGrv		:= ""

	::cMensagem		:= ""
	::dEmissao		:= CtoD("  /  /  ")

	::lGravaLog		:= .T.
	::cFileLog		:= "MATAXXX.LOG"
	::cPathLog		:= "\LOGS\"

Return Self
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Method   � AddValues �Autor  � Amedeo D. P. Filho � Data � 11/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Armazena os valores para gravacao                          ���
�������������������������������������������������������������������������͹��
���Uso       � uExecAuto                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Method AddValues(cCampo, xValor) Class uExecAuto
	Local nPosCpo := Ascan(::aValues, {|x| AllTrim(x[01]) == AllTrim(cCampo)})

	If AllTrim(cCampo) == "EMPRESA"
		::cEmpGrv := xValor
	Else
		If "_FILIAL" $ AllTrim(cCampo)
			::cFilGrv := xValor
		EndIf

		If nPosCpo == 0
			Aadd(::aValues, {cCampo		,xValor		,NIL})
		Else
			::aValues[nPosCpo][02] := xValor
		EndIf
	EndIf
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Method   � SetEnv    � Autor � Amedeo D.P.Filho  � Data �  11/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Prepara o Ambiente para Gravacao na Empresa de destino     ���
�������������������������������������������������������������������������͹��
���Parametro � nOpcao -> 1 = Prepara / 2 = Restaura                       ���
�������������������������������������������������������������������������͹��
���Uso       � uExecAuto                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Method SetEnv(nOpcao, cModulo) Class uExecAuto
	Local	nTamEmp	:= Len(::cEmpGrv)

	Default cModulo := "FAT"

	If nTamEmp > 2
		::cEmpGrv := Substr(::cEmpGrv, 1, 2)
	EndIf

	If nOpcao == 1
		If !Empty(::cEmpGrv) .And. !Empty(::cFilGrv)
			::cEmpBkp := cEmpAnt
			::cFilBkp := cFilAnt
			
			If ::cEmpGrv <> ::cEmpBkp .OR. ::cFilGrv <> ::cFilBkp
				RpcClearEnv()
				RPCSetType(3)
				RpcSetEnv(::cEmpGrv, ::cFilGrv, Nil, Nil, cModulo, Nil, ::aTabelas, Nil, Nil, Nil, Nil)
			EndIf
		EndIf
	Else
		If !Empty(::cEmpBkp) .And. !Empty(::cFilBkp)
			If ::cEmpBkp <> cEmpAnt .OR. ::cFilBkp <> cFilAnt
				RpcClearEnv()
				RPCSetType(3)
				RpcSetEnv(::cEmpBkp, ::cFilBkp, Nil, Nil, cModulo, Nil, ::aTabelas, Nil, Nil, Nil, Nil)
			EndIf
		EndIf
	EndIf

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Metodo   � SetItem   � Autor � Amedeo D. P. Filho� Data � 21/09/11    ���
�������������������������������������������������������������������������͹��
���Desc.     � Armazena os Valores do Item e Reinicializa o Array         ���
���          � Temporario.                                                ���
�������������������������������������������������������������������������͹��
���Parametros� cCampo - Nome do Campo para Gravacao                       ���
���          � xValor - Valor do Campo para Gravacao                      ���
�������������������������������������������������������������������������͹��
���Uso       � Classe uExecAuto                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Method SetItem() Class uExecAuto
	Aadd(::aItens, ::aItemTemp)
	::aItemTemp := {}
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Method   � GetMensagem � Autor � Amedeo D. P. Filho� Data � 11/10/10  ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna a Mensagem de Erro do ExecAuto                     ���
�������������������������������������������������������������������������͹��
���Uso       � uExecAuto                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Method GetMensagem() Class uExecAuto
Return ::cMensagem
