User Function BIUSRTAB   
Local cAlias   := PARAMIXB[1] // Alias da Fato ou Dimens�o em grava��o no momento
Local aRet   := {}

Do Case 
	Case cAlias == "HJ7"  //CLIENTE
		aRet := {"SA1","SX5"}
EndCase	

Return aRet