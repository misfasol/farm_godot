extends Node

enum TIPOS_PLANTAS {TRIGO}

var plantados: Dictionary
var posi: Vector2i = Vector2i(5, 5)
var dinheiro: int = 100
var qtd_trigo: int = 0

enum LOCAL {PLANTACAO, CIDADE}
var local_atual = LOCAL.PLANTACAO
var posi_plantacao = Vector2i(5, 5)
var posi_cidade = Vector2i(1, 1)

func trocar_plantacao_cidade() -> LOCAL:
	if local_atual == LOCAL.PLANTACAO: # ir para cidade
		local_atual = LOCAL.CIDADE
		posi_plantacao = posi
		posi = posi_cidade
	elif local_atual == LOCAL.CIDADE: # ir para plantacao
		local_atual = LOCAL.PLANTACAO
		posi_cidade = posi
		posi = posi_plantacao
	else:
		print("nao ta em nenhum ugar?")
		get_tree().quit(1)
	return local_atual
