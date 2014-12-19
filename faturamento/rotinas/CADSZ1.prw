#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CADSZ1   � Autor � Eduardo            � Data �  28/03/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Transportadoras por Filial                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AVANT                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CADSZ1()

Private cCadastro 	:= "Cadastro de Transportador x Filial"

Private aRotina 	:= {	{"Pesquisar"	,"AxPesqui"	,0,1} ,;
			             	{"Visualizar"	,"AxVisual"	,0,2} ,;
			             	{"Incluir"		,"AxInclui"	,0,3} ,;
			             	{"Alterar"		,"AxAltera"	,0,4} ,;
			             	{"Excluir"		,"AxDeleta"	,0,5} ,;
			             	{"Atualizar"	,"U_ATSZ1"	,0,6} }

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SZ1"

dbSelectArea("SZ1")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString)

Return

//��������������������������������������������������������������Ŀ
//� Function ATSZ1 - Atualiza Cadastro de Cliente                �
//����������������������������������������������������������������

User Function ATSZ1()
	Local cUpd := ""
	cUpd := "UPDATE "+RetSqlName("SZ1")
    cUpd += " SET Z1_TRANSP = '" + M->Z1_TRANSP + "'"  
    cUpd += " FROM "+RetSqlName("SZ1") + "Z "
    cUpd += " INNER JOIN " + RetSqlName("SA1") + "C "
    cUpd += " ON (Z.Z1_CLIENTE = C.A1_COD AND Z.Z1_LOJA=C.A1_LOJA) "
    cUpd += " WHERE A1_EST = '" + M->Z1_EST + "'"
    cUpd += " AND D_E_L_E_T_ <> '*'"
_nResult := TcSqlExec(cUpd)
Return