extends Node2D

var tempo_andar: float = 0.3
var andando: bool = false
var ultima_dir := Vector2i.DOWN

@onready var principal := get_parent()

func _ready() -> void:
	position = somar_vec2i(Globais.posi * 16, Vector2i(8, 8))

func _process(_delta: float) -> void:
	var input := Vector2i.ZERO
	if not andando:
		if Input.is_action_pressed("cima"):
			input.y += -1
		if Input.is_action_pressed("baixo"):
			input.y += 1
		if Input.is_action_pressed("esq") and input.y == 0:
			input.x += -1
		if Input.is_action_pressed("dir") and input.y == 0:
			input.x += 1
		ultima_dir = input
		match input:
			Vector2i.UP:
				if consegue_andar_dir(input):
					andando = true
					$AnimatedSprite2D.play("a_c")
					$timer_andar.start(tempo_andar)
				else:
					$AnimatedSprite2D.play("p_c")
			Vector2i.DOWN:
				if consegue_andar_dir(input):
					andando = true
					$AnimatedSprite2D.play("a_b")
					$timer_andar.start(tempo_andar)
				else:
					$AnimatedSprite2D.play("p_b")
			Vector2i.LEFT:
				if consegue_andar_dir(input):
					andando = true
					$AnimatedSprite2D.play("a_e")
					$timer_andar.start(tempo_andar)
				else:
					$AnimatedSprite2D.play("p_e")
			Vector2i.RIGHT:
				if consegue_andar_dir(input):
					andando = true
					$AnimatedSprite2D.play("a_d")
					$timer_andar.start(tempo_andar)
				else:
					$AnimatedSprite2D.play("p_d")
			_:
				pass

	else:
		var interp = ($timer_andar.wait_time - $timer_andar.time_left) / $timer_andar.wait_time
		position = somar_vec2i(somar_vec2i(Globais.posi * 16, Vector2i(8, 8)), 16 * interp * ultima_dir)

func consegue_andar_dir(dir: Vector2i) -> bool:
	var cel = principal.get_node("plantacao/solo").get_cell_tile_data(somar_vec2i(Globais.posi, dir))
	if not cel:
		return true
	return not cel.get_custom_data("nao_andavel")

func somar_vec2i(a: Vector2i, b: Vector2i) -> Vector2i:
	return Vector2i(a.x + b.x, a.y + b.y)

func _on_timer_andar_timeout() -> void:
	andando = false
	Globais.posi += ultima_dir
	position = somar_vec2i(Globais.posi * 16, Vector2i(8, 8))
	match ultima_dir:
		Vector2i.UP:
			$AnimatedSprite2D.play("p_c")
		Vector2i.DOWN:
			$AnimatedSprite2D.play("p_b")
		Vector2i.RIGHT:
			$AnimatedSprite2D.play("p_d")
		Vector2i.LEFT:
			$AnimatedSprite2D.play("p_e")
	ultima_dir = Vector2i.ZERO
