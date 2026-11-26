extends Control

@onready var boton_jugar: Button = $VBoxContainer/Jugar
@onready var boton_salir: Button = $VBoxContainer/Salir

func _ready() -> void:
	# Nos aseguramos de quitar la pausa por si venimos del menú de derrota
	get_tree().paused = false
	
	if boton_jugar:
		boton_jugar.pressed.connect(_on_jugar_pressed)
	if boton_salir:
		boton_salir.pressed.connect(_on_salir_pressed)

func _on_jugar_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenas/mundo.tscn")

func _on_salir_pressed() -> void:
	get_tree().quit()
