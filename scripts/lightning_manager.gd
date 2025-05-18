class_name Lightning_Manager extends Node3D

@export var directional_light : DirectionalLight3D
@export var world_environment : WorldEnvironment

@onready var distant_thunder_audio_pool := [preload("res://assets/sfx/Thunder_Sounds/Distant/mixkit-big-thunder-rumble-1297.wav"),
	preload('res://assets/sfx/Thunder_Sounds/Distant/mixkit-big-thunder-with-rain-1291.wav'),
	preload('res://assets/sfx/Thunder_Sounds/Distant/mixkit-heavy-storm-rain-loop-2400.wav'),
	preload('res://assets/sfx/Thunder_Sounds/Distant/mixkit-thunder-rumble-and-light-rain-2401.wav'),
	preload('res://assets/sfx/Thunder_Sounds/Distant/mixkit-thunderstorm-background-sound-2398.wav'),]
@onready var close_thunder_audio_pool := [preload("res://assets/sfx/Thunder_Sounds/Close/mixkit-nature-ambience-with-lightning-strike-and-thunder-3093.wav"),
	preload("res://assets/sfx/Thunder_Sounds/Close/mixkit-thunder-with-rain-in-the-storm-1294.wav")]

var tween : Tween
var max_directional_light_energy := 6.0
var max_sky_light_energy := 0.75

func _ready():
	change_to_env(0.0,0.0,0.0)
	lightning_pattern_two()
	
func start_sequence_lightning():
	print("Pattern 1")
	directional_light.rotation = Vector3(250,randf_range(-360, 360),0)
	var subtle_flash_timing = randf_range(0.01,0.2)
	
	for i in randi_range(0, 2):
		await change_to_env(0.34,subtle_flash_timing,0.05)
		await change_to_env(0.0,0.2,0.01)
		
	await change_to_env(0.34,subtle_flash_timing,0.05)
	for i in randi_range(0,1):
		await change_to_env(max_sky_light_energy,subtle_flash_timing,max_directional_light_energy)
		
	await change_to_env(max_sky_light_energy,randf_range(0.1,0.3),max_directional_light_energy)
	await change_to_env(0.34,randf_range(0.7,1.0),0.3)
	await change_to_env(0.0,randf_range(0.05,0.2),0.1)
	
	for i in randi_range(0,3):
		await change_to_env(0.34,subtle_flash_timing,0.03)
		await change_to_env(0.0,0.2,0.01)
		
	await change_to_env(0.34,randf_range(0.7,1.0),0.05)
	await change_to_env(0.0,randf_range(0.05,0.2),0.0)
	#play_thunder_audio(false)
	await get_tree().create_timer(randf_range(2.5,5.0)).timeout
	lightning_pattern_two()
	
func lightning_pattern_two():
	print("Pattern 2")
	directional_light.rotation = Vector3(250,randf_range(-360, 360),0)
	var subtle_flash_timing = randf_range(0.01,0.1)
	
	for i in randi_range(0,3):
		await change_to_env(0.34,subtle_flash_timing,0.02)
		await change_to_env(0.0,0.2,0.01)
		
	await change_to_env(1.93,subtle_flash_timing,0.05)
	for i in randi_range(0,1):
		await change_to_env(1.93,subtle_flash_timing,0.9)
	play_thunder_audio(true)
	await get_tree().create_timer(randf_range(0.5,2.0)).timeout
	start_sequence_lightning()
	
func play_thunder_audio(force_play_close_audio : bool):
	var sound_lag = randf_range(0.2,1.5)
	var sound : AudioStream
	var volume : float = -sound_lag * 3.0
	
	if force_play_close_audio:
		sound = close_thunder_audio_pool.pick_random()
		print("Close")
	elif sound_lag >= .5:
		sound = distant_thunder_audio_pool.pick_random()
		print("Distant")
	else:
		sound = close_thunder_audio_pool.pick_random()
		print("Close")
	
	var thunder_audio_player = AudioStreamPlayer.new()
	get_parent().add_child(thunder_audio_player)
	
	thunder_audio_player.volume_db = volume
	thunder_audio_player.stream = sound
	thunder_audio_player.bus = 'sfx'
	await get_tree().create_timer(sound_lag).timeout
	thunder_audio_player.play()
	
	await thunder_audio_player.finished
	thunder_audio_player.queue_free()
	
func change_to_env(env_light_intensity: float, duration: float, dir_light_intensity: float):
	if tween != null:
		tween = null
	
	tween = create_tween().bind_node(self)
	tween.tween_property(directional_light, 'light_energy', dir_light_intensity, duration)
	tween.parallel().tween_property(world_environment.environment, 'background_energy_multiplier', env_light_intensity, duration)
	
	await tween.finished
