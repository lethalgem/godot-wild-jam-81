class_name Lightning_Manager extends Node3D

@export var directional_light : DirectionalLight3D

func _ready():
	show_lightning()

func show_lightning():
	directional_light.light_energy = 2.0
	get_tree().create_timer(2.0).timeout.connect(hide_lightning)

func hide_lightning():
	directional_light.light_energy = 0.0
	get_tree().create_timer(2.0).timeout.connect(show_lightning)
