extends Node2D

var planta = preload("res://cenas/planta.tscn")

func _ready() -> void:
	$CanvasLayer/hud/Label.text = "din: " + str(Globais.dinheiro) + "\ntrigo: " + str(Globais.qtd_trigo)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("plantar") and not $pers.andando:
		processar_plantar()
	if Input.is_action_just_pressed("cidade"):
		pri_trocar_plantacao_cidade()

enum ESTADO_CEL {GRAMA, SOLO, PLANTA}

func processar_plantar():
	var cel_grama = $plantacao/grama.get_cell_tile_data(Globais.posi)
	var cel_solo = $plantacao/solo.get_cell_tile_data(Globais.posi)
	var cel_planta = $plantacao/plantas_sprite.get_cell_tile_data(Globais.posi)
	if not cel_grama:
		print("como assim n tem cel grama")
		get_tree().quit(1)
	
	var estado: ESTADO_CEL
	
	var aravel = cel_grama.get_custom_data("aravel")
	if aravel:
		estado = ESTADO_CEL.GRAMA
	
	var plantavel: bool
	if cel_solo:
		plantavel = cel_solo.get_custom_data("plantavel")
	else:
		plantavel = false
	if plantavel:
		estado = ESTADO_CEL.SOLO

	if cel_planta:
		estado = ESTADO_CEL.PLANTA
	
	match estado:
		ESTADO_CEL.GRAMA:
			if Globais.dinheiro > 0:
				$plantacao/solo.set_cells_terrain_connect([Globais.posi], 0, 0)
				Globais.dinheiro -= 1
		ESTADO_CEL.SOLO:
			if Globais.dinheiro > 0:
				var nova: Node = planta.instantiate()
				$plantacao/plantas.add_child(nova)
				Globais.plantados[Globais.posi] = nova
				nova.setar(Globais.TIPOS_PLANTAS.TRIGO, Globais.posi)
				nova.start()
				nova.terminou.connect(terminou_planta)
				$plantacao/plantas_sprite.set_cell(Globais.posi, 0, nova.sprites[0])
				Globais.dinheiro -= 1
				aravel = false
		ESTADO_CEL.PLANTA:
			if cel_planta.get_custom_data("pronto"):
				Globais.qtd_trigo += 1
				var plantado: Node = Globais.plantados[Globais.posi]
				if not plantado:
					print("como assim n tem no plantado")
					get_tree().quit()
				Globais.plantados[Globais.posi] = null
				plantado.queue_free()
				$plantacao/plantas_sprite.set_cell(Globais.posi)
				plantavel = false
				aravel = false
	$CanvasLayer/hud/Label.text = "din: " + str(Globais.dinheiro) + "\ntrigo: " + str(Globais.qtd_trigo)

func terminou_planta(planta_node: Node):
	$plantacao/plantas_sprite.set_cell(planta_node.posi, 0, planta_node.sprites[1])

func pri_trocar_plantacao_cidade():
	var novo_local = Globais.trocar_plantacao_cidade()
	if novo_local == Globais.LOCAL.PLANTACAO:
		$cidade.process_mode = Node.PROCESS_MODE_DISABLED
		$plantacao.process_mode = Node.PROCESS_MODE_INHERIT
		$cidade.hide()
		$plantacao.show()
	if novo_local == Globais.LOCAL.CIDADE:
		$cidade.process_mode = Node.PROCESS_MODE_INHERIT
		$plantacao.process_mode = Node.PROCESS_MODE_DISABLED
		$cidade.show()
		$plantacao.hide()
