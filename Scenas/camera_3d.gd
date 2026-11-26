extends Camera3D

@onready var player = get_node_or_null("/root/Mundo/Player")

func _process(_delta: float) -> void:
	if player:
		global_position = Vector3(player.global_position.x, 25.0, player.global_position.z)
