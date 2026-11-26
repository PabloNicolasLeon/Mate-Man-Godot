extends Area3D

enum TipoDonSatur { GRASA, DULCE }
@export var tipo: TipoDonSatur = TipoDonSatur.GRASA

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	# Cambia el color visualmente si es Dulce (Azul) o Grasa (Rojo)
	var mesh: MeshInstance3D = find_child("MeshInstance3D", true, false)
	if mesh:
		var mat = StandardMaterial3D.new()
		if tipo == TipoDonSatur.DULCE:
			mat.albedo_color = Color.BLUE
		else:
			mat.albedo_color = Color.RED
		mesh.set_surface_override_material(0, mat)

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player" or body.is_in_group("Player"):
		# 1. Resetear la barra de Pálida a 0%
		var barra = get_tree().root.find_child("Barra Palida", true, false)
		if barra and barra.has_method("reiniciar_palida"):
			barra.reiniciar_palida()
		
		# 2. Si es de Grasa, dar boost de velocidad al jugador
		if tipo == TipoDonSatur.GRASA and body.has_method("activar_velocidad_extra"):
			body.activar_velocidad_extra(5.0)
		
		# 3. Eliminar la Don Satur del mapa
		queue_free()
