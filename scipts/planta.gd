extends Node

signal terminou(planta: Node)

var posi: Vector2i
var sprites: Array[Vector2i] = []
var tempo = 0

func start():
	$Timer.start(tempo)

func setar(tipo: int, posi_: Vector2i):
	posi = posi_
	match tipo:
		Globais.TIPOS_PLANTAS.TRIGO:
			sprites.append(Vector2i(0, 0))
			sprites.append(Vector2i(1, 0))
			tempo = 2

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	terminou.emit($".")
