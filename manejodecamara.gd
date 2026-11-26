extends Node

var top_camera: Camera3D
var behind_camera: Camera3D
var minimap_visual: CanvasItem
var is_top_view := false


func _ready() -> void:
	await get_tree().process_frame

	var scene = get_tree().current_scene

	top_camera = scene.get_node_or_null("Player/camara arriba")
	behind_camera = scene.get_node_or_null("Player/Camara 1erper")
	minimap_visual = scene.get_node_or_null("camara del minimap")

	if not top_camera or not behind_camera or not minimap_visual:
		push_error("Faltan nodos de cámara o minimapa")
		return

	behind_camera.make_current()
	minimap_visual.show()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R:
		is_top_view = not is_top_view

		if is_top_view:
			top_camera.make_current()
			minimap_visual.hide()
		else:
			behind_camera.make_current()
			minimap_visual.show()
