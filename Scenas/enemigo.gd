extends CharacterBody3D

enum TipoEnemigo { PROFESOR, ESTUDIANTE }
@export var tipo: TipoEnemigo = TipoEnemigo.PROFESOR
@export var SPEED: float = 3.2
@export var FUERZA_EMPUJON: float = 8.0  # Intensidad del empujón al tocar al player

var frases_profesor: Array[String] = [
	"Hubo muchos paros, pero igual entran todas las unidades en el parcial.",
	"Veo muchas caritas de recursantes.",
	"Lean la bibliografía.",
	"Entreguen antes de las 23:59.",
	"¿Hay alguna duda?"
]

var frases_estudiante: Array[String] = [
	"¿Alguien entendió el punto 3?",
	"Che, ¿pasan el grupo de WhatsApp?",
	"Pasen la asistencia, por favor.",
	"Tuve muchas cosas que hacer, no hice mi parte del TP",
	"No tengo grupo, ¿Quien me mete?"
]

@onready var label_frase: Label3D = $Label3D
var jugador: Node3D = null
var tiempo_siguiente_frase: float = 0.0
var cooldown_colision: float = 0.0  # Evita que aplique el golpe 60 veces por segundo

func _ready() -> void:
	if tipo == TipoEnemigo.ESTUDIANTE:
		SPEED = 3.8
	
	jugador = get_tree().root.find_child("Player", true, false)
	mostrar_frase_aleatoria()

func _physics_process(delta: float) -> void:
	# Temporizador para poder volver a golpear/empujar
	if cooldown_colision > 0:
		cooldown_colision -= delta

	if not is_on_floor():
		velocity += get_gravity() * delta

	if jugador:
		var direccion = (jugador.global_position - global_position).normalized()
		velocity.x = direccion.x * SPEED
		velocity.z = direccion.z * SPEED
		
		var mirar_a = Vector3(jugador.global_position.x, global_position.y, jugador.global_position.z)
		if global_position.distance_to(mirar_a) > 0.1:
			look_at(mirar_a, Vector3.UP)

		# Impacto al tocarse (menos de 0.9m de distancia)
		var distancia = global_position.distance_to(jugador.global_position)
		if distancia < 0.9 and cooldown_colision <= 0:
			aplicar_impacto(direccion)

	move_and_slide()

	# Cambio periódico de frases
	tiempo_siguiente_frase += delta
	if tiempo_siguiente_frase >= 3.5:
		tiempo_siguiente_frase = 0.0
		mostrar_frase_aleatoria()

func mostrar_frase_aleatoria() -> void:
	if not label_frase:
		return
	var lista = frases_profesor if tipo == TipoEnemigo.PROFESOR else frases_estudiante
	label_frase.text = lista.pick_random()

func aplicar_impacto(_direccion: Vector3) -> void:
	cooldown_colision = 1.0  # Espera 1 segundo antes de volver a golpear
	
	# 1. Sumar 15% de pálida
	var barra = get_tree().root.find_child("Barra Palida", true, false)
	if barra:
		if barra:	
			barra.value += 15.0
		if barra.value >= barra.max_value:
			barra.perder_juego()	

	# 2. Empujar al jugador en la dirección opuesta
	if jugador and jugador is CharacterBody3D:
		var direccion_empuje = (jugador.global_position - global_position)
		direccion_empuje.y = 0
		direccion_empuje = direccion_empuje.normalized()

		jugador.velocity = direccion_empuje * 25.0
