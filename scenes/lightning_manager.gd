class_name Lightning_Manager extends Node3D

@export var directional_light : DirectionalLight3D
@export var world_environment : WorldEnvironment
@onready var dark_env := preload("res://environments/dark_env.tres")
@onready var subtle_flash_env := preload("res://environments/subtle_flash.tres")
@onready var big_flash_env := preload("res://environments/big_flash.tres")
var tween : Tween

func _ready():
	change_to_env(dark_env,0.0)
	show_lightning()

func show_lightning():
	await lightning_build_up()
	await lightning_big_flash()
	await show_darkness()
	
func lightning_build_up():
	await change_to_env(subtle_flash_env,1.5)

func lightning_big_flash():
	await change_to_env(big_flash_env,1)

func show_darkness():
	await change_to_env(dark_env,0.5)

func change_to_env(environment_to:Environment, duration:float):
	if tween != null:
		tween = null
	
	tween = create_tween().bind_node(self)
	
	for prop in world_environment.environment.get_property_list():
		if prop.type != 0 \
		and prop.name != "resource_path" \
		and prop.name != "RefCounted" \
		and prop.name != "Resource" \
		and prop.name != "resource_name" \
		and prop.name != "resource_scene_unique_id":
			var prop_val_to = environment_to.get(prop.name)
			tween.parallel().tween_property(world_environment.environment,prop.name,prop_val_to,duration)

	await tween.finished
