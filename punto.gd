extends Area3D

func _ready():
	# Conectamos la señal si no estaba conectada desde el editor
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player" or body.is_in_group("Player"):
		# Busca el nodo Interfaz en la escena y suma el mate
		var interfaz = get_tree().root.find_child("Interfaz", true, false)
		if interfaz and interfaz.has_method("sumar_mate"):
			interfaz.sumar_mate()
		
		queue_free()
