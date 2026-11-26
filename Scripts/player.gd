extends CharacterBody3D

var SPEED = 5.0
var velocidad_normal: float = 5.0
const JUMP_VELOCITY = 4.5
const SENSIBILIDAD_MOUSE: float = 0.003

@onready var camara_arriba: Camera3D = $Cenital
@onready var camara_tercera: Camera3D = $"Tercera Persona"

@onready var menu_win = $"../Interfaz/Menu Victoria"
@onready var menu_lose = $"../Interfaz/Menu Derrota"
func _process(_delta: float) -> void:
	if menu_win.visible or menu_lose.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var mini_mapa = get_node_or_null("../Interfaz/Mini Mapa")	
	if mini_mapa:
		mini_mapa.visible = camara_tercera.current
func _physics_process(delta: float) -> void:
	if menu_win.visible or menu_lose.visible:
		return
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * 25 * delta)
		velocity.z = move_toward(velocity.z, 0, SPEED * 25 * delta)

	move_and_slide()

func activar_velocidad_extra(duracion: float = 5.0):
	SPEED = 8.5
	print("¡Velocidad aumentada!")
	await get_tree().create_timer(duracion).timeout
	SPEED = velocidad_normal
	print("Efecto de velocidad terminado.")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Cambiar Camara"):
		if camara_arriba.current:
			camara_tercera.current = true
		else:
			camara_arriba.current = true

	if event is InputEventMouseMotion and camara_tercera.current:
		rotate_y(-event.relative.x * SENSIBILIDAD_MOUSE)
