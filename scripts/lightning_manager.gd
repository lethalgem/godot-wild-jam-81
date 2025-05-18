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
var max_sky_light_energy := 1.0

func _ready():
	change_to_env(0.0,0.0,0.0)
	
	while true:
		await start_sequence_lightning()
		await get_tree().create_timer(randf_range(6.0, 14.0)).timeout

func start_sequence_lightning():
	directional_light.rotation = Vector3(directional_light.rotation.x,deg_to_rad(randf_range(-360, 360)),directional_light.rotation.z)
	
	## buildup
	var subtle_light_min_factor := 0.025
	var subtle_light_max_factor := 0.05
	var buildup_sky_light_energy_inc := max_sky_light_energy * randf_range(subtle_light_min_factor,subtle_light_max_factor)
	var buildup_dir_light_energy_inc := max_directional_light_energy * randf_range(subtle_light_min_factor,subtle_light_max_factor)
	var sky_light_energy := 0.1
	var dir_light_energy := 0.025
	for i in randi_range(1, 4):
		await change_to_env(sky_light_energy, 0.05, dir_light_energy)
		await get_tree().create_timer(randf_range(0.05, 0.1)).timeout
		await change_to_env(sky_light_energy - 0.1, randf_range(0.05, 0.1), dir_light_energy - 0.1)
		sky_light_energy += buildup_sky_light_energy_inc
		dir_light_energy += buildup_dir_light_energy_inc
	
	# suspense
	await change_to_env(0.0,randf_range(0.8, 1.3),0.0)
	
	# big bang
	var is_big_bang = randi_range(0, 1)
	for i in is_big_bang:
		await change_to_env(max_sky_light_energy, 0.05, max_directional_light_energy)
		await get_tree().create_timer(randf_range(0.1, 0.3)).timeout
		await change_to_env(0.0,randf_range(0.8, 1.3),0.0)
	
	if is_big_bang == 1:
		play_thunder_audio(true)
	else:
		play_thunder_audio(false)
	
func play_thunder_audio(force_play_close_audio : bool):
	var sound_lag = randf_range(0.2,1.5)
	var sound : AudioStream
	var volume : float = -sound_lag * 3.0 - 7.0
	
	if force_play_close_audio:
		sound = close_thunder_audio_pool.pick_random()
	elif sound_lag >= .5:
		sound = distant_thunder_audio_pool.pick_random()
	else:
		sound = close_thunder_audio_pool.pick_random()
	
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
	tween.parallel().tween_property(directional_light, 'light_energy', dir_light_intensity, duration)
	tween.parallel().tween_property(world_environment.environment, 'background_energy_multiplier', env_light_intensity, duration)
	
	await tween.finished
