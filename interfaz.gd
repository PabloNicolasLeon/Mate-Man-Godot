extends CanvasLayer

var mates_recolectados: int = 0
var total_mates: int = 0

func _ready() -> void:
	var contenedor_mates = get_node_or_null("../Mates puntos")
	if contenedor_mates:
		# Bucle for para contar cada hijo dentro del contenedor de forma automática
		for mate in contenedor_mates.get_children():
			total_mates += 1
			
	print("Total de mates detectados con for: ", total_mates)

func sumar_mate() -> void:
	mates_recolectados += 1
	print("Mates: ", mates_recolectados, " / ", total_mates)
	
	var nodo_texto = find_child("Contador Mates", true, false)
	if nodo_texto:
		nodo_texto.text = "Mates: " + str(mates_recolectados) + " / " + str(total_mates)
		
	if mates_recolectados >= total_mates and total_mates > 0:
		ganar_juego()

func ganar_juego() -> void:
	# 1. Congela la barra de pálida explícitamente
	var barra = get_node_or_null("Barra Palida")
	if barra and barra.has_method("detener_palida"):
		barra.detener_palida()

	# 2. Detiene la música de fondo
	var musica = get_node_or_null("../AudioStreamPlayer")
	if musica:
		musica.stop()
		
	# 3. Muestra el cartel de victoria y conecta los botones
	var menu_win = get_node_or_null("Menu Victoria")
	if menu_win:
		menu_win.visible = true
		
		var btn_siguiente = menu_win.get_node_or_null("Siguiente Nivel")
		var btn_salir = menu_win.get_node_or_null("Salir")
		
		if btn_siguiente and not btn_siguiente.pressed.is_connected(_on_siguiente_pressed):
			btn_siguiente.pressed.connect(_on_siguiente_pressed)
			
		if btn_salir and not btn_salir.pressed.is_connected(_on_salir_pressed):
			btn_salir.pressed.connect(_on_salir_pressed)
			
	get_tree().paused = true

func _on_siguiente_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://mundo_2.tscn")

func _on_salir_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenas/menu_inicio.tscn")
