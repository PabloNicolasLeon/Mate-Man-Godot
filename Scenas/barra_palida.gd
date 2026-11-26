extends ProgressBar

@export var velocidad_subida: float = 2.0 # Porcentaje que sube por segundo
var juego_terminado: bool = false

func _ready():
	value = 0.0 # Arranca en 0%

func _process(delta: float) -> void:
	if juego_terminado:
		return # Si ya ganó o perdió, la barra se congela
	
	if value < max_value:
		value += velocidad_subida * delta
		if value >= max_value:
			value = max_value
			perder_juego()

# Función para reiniciar la Pálida a 0 (llamada por las Don Satur)
func reiniciar_palida():
	if not juego_terminado:
		value = 0.0
		print("Pálida reseteada a 0%")

# Congelar la barra cuando recolecta todos los mates
func detener_palida():
	juego_terminado = true
	print("Pálida congelada. ¡Misión cumplida!")

func perder_juego():
	juego_terminado = true
	
	# Paramos la música del mapa y hacemos sonar a Pac-Man
	var musica_juego = get_node_or_null("../AudioStreamPlayer")
	if musica_juego:
		musica_juego.stop()
		
	var sonido_derrota = get_node_or_null("../Sonido Derrota")
	if sonido_derrota:
		sonido_derrota.play()
	
	get_tree().paused = true # Congela la física y movimiento del juego
	
	var menu = get_node_or_null("../Menu Derrota")
	if menu:
		menu.show()
		
		var btn_reintentar = menu.get_node_or_null("Boton de Recursar")
		var btn_salir = menu.get_node_or_null("Boton Salir")
		
		if btn_reintentar and not btn_reintentar.pressed.is_connected(_on_reintentar):
			btn_reintentar.pressed.connect(_on_reintentar)
		if btn_salir and not btn_salir.pressed.is_connected(_on_salir):
			btn_salir.pressed.connect(_on_salir)

func _on_reintentar() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_salir() -> void:
	get_tree().quit()
