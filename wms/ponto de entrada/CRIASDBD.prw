#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CRIASDBD � Autor � Fernando Nogueira  � Data � 15/09/2015  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada apos criacao do servico wms               ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Avant                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CRIASDBD()

Local aAreaSDB := SDB->(GetArea())

// Se tiver recurso humano para esse documento mantem nos proximos servicos
If IsMemVar("__cRecHum")
	If !Empty(__cRecHum) .And. SDB->DB_TAREFA = "002"
		SDB->(RecLock("SDB",.F.))
		SDB->DB_RECHUM := __cRecHum
		SDB->(MsUnlock())
	Endif
Endif

SDB->(RestArea(aAreaSDB))

Return