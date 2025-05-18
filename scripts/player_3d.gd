class_name Player3D extends CharacterBody3D

@export var player_cam : PlayerCam
@export var footstep_player : AudioStreamPlayer3D

@export var max_speed := 7
@export var gravity_strength := 40
@export var steering_factor := 20
@export var stride_distance := 3.0

var target_velocity := Vector3.ZERO

@onready var last_stepped_position := global_position
@onready var last_velocity := velocity

var footsteps_sounds := [
	preload("res://assets/sfx/Footsteps/Gravel_Walking__01.wav"),
	preload("res://assets/sfx/Footsteps/Gravel_Walking__02.wav"),
	preload("res://assets/sfx/Footsteps/Gravel_Walking__03.wav"),
	preload("res://assets/sfx/Footsteps/Gravel_Walking__04.wav"),
	preload("res://assets/sfx/Footsteps/Gravel_Walking__05.wav"),
	preload("res://assets/sfx/Footsteps/Gravel_Walking__06.wav"),
	preload("res://assets/sfx/Footsteps/Gravel_Walking__07.wav"),
	preload("res://assets/sfx/Footsteps/Gravel_Walking__08.wav"),
	preload("res://assets/sfx/Footsteps/Gravel_Walking__09.wav"),
	preload("res://assets/sfx/Footsteps/Gravel_Walking__10.wav"),
	preload("res://assets/sfx/Footsteps/Gravel_Walking__11.wav"),
	preload("res://assets/sfx/Footsteps/Gravel_Walking__12.wav"),
	preload("res://assets/sfx/Footsteps/Gravel_Walking__13.wav"),
	preload("res://assets/sfx/Footsteps/Gravel_Walking__14.wav"),
	preload("res://assets/sfx/Footsteps/Gravel_Walking__15.wav"),
	preload("res://assets/sfx/Footsteps/Gravel_Walking__16.wav"),
	preload("res://assets/sfx/Footsteps/Gravel_Walking__17.wav"),
	preload("res://assets/sfx/Footsteps/Gravel_Walking__18.wav"),
	preload("res://assets/sfx/Footsteps/Gravel_Walking__19.wav"),
	preload("res://assets/sfx/Footsteps/Gravel_Walking__20.wav")]

@onready var footstep_randomizer := AudioStreamRandomizer.new()

func _ready() -> void:
	for sound in footsteps_sounds:
		footstep_randomizer.add_stream(-1, sound)
	footstep_randomizer.random_pitch = 2.0
	footstep_randomizer.random_volume_offset_db = 2.0
	footstep_player.stream = footstep_randomizer
	footstep_player.bus = 'sfx'

func _physics_process(delta):
	var input_vector := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	var direction := Vector3(input_vector.x, 0.0, input_vector.y).rotated(Vector3(0, 1, 0), player_cam.global_rotation.y)
	var desired_ground_velocity: Vector3 = max_speed * direction
	var steering_vector := desired_ground_velocity - velocity
	steering_vector.y = 0.0
	# We limit the steering amount to ensure the velocity can never overshoots the desired velocity.
	var steering_amount: float = min(steering_factor * delta, 1.0)
	velocity += steering_vector * steering_amount

	velocity += gravity_strength * delta * Vector3.DOWN
	move_and_slide()
	
	if velocity != last_velocity and last_velocity.length() == 0.0 and is_on_floor(): # just starting motion
		take_step()
	
	if global_position.distance_to(last_stepped_position) > stride_distance and is_on_floor():
		take_step()

	last_velocity = velocity
	
func take_step():
	last_stepped_position = global_position
	footstep_player.play()
