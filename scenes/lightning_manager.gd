class_name Lightning_Manager extends Node3D

@export var directional_light : DirectionalLight3D
@export var world_environment : WorldEnvironment
@onready var dark_env := preload("res://environments/dark_env.tres")
@onready var subtle_flash_env := preload("res://environments/subtle_flash.tres")
@onready var big_flash_env := preload("res://environments/big_flash.tres")

var tween : Tween

#TODO: Fine tune timing/env.properties
#TODO: Randomized directional light vector (.x and .z)
#TODO: Incorporate directional light, one for ea. brightness
#TODO: Thunder sound - delayed sound - rolling thunder?

func _ready():
	change_to_env(dark_env,0.0,0.0)
	start_sequence_lightning()

func start_sequence_lightning():
	directional_light.rotation = Vector3(250,randf_range(-360, 360),0)
	var subtle_flash_timing = randf_range(0.01,0.15)
	
	for i in randi_range(1,2):
		await change_to_env(subtle_flash_env,subtle_flash_timing,0.05)
		await change_to_env(dark_env,0.2,0.01)
	await change_to_env(subtle_flash_env,subtle_flash_timing,0.05)
	for i in randi_range(0,1):
		await change_to_env(big_flash_env,subtle_flash_timing,0.8)
	await change_to_env(big_flash_env,randf_range(0.1,0.3),1.0)
	await change_to_env(subtle_flash_env,randf_range(0.7,1.0),0.3)
	await change_to_env(dark_env,randf_range(0.05,0.2),0.0)
	
	await get_tree().create_timer(randf_range(0.5, 3.0)).timeout
	start_sequence_lightning()

func change_to_env(environment_to:Environment, duration:float, dir_light_intensity:float):
	if tween != null:
		tween = null
	
	tween = create_tween().bind_node(self)
	tween.tween_property(directional_light,'light_energy',dir_light_intensity,duration)
	
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
	print(world_environment.environment.background_energy_multiplier)
