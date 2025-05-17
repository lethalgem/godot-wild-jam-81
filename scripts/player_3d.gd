class_name Player3D extends CharacterBody3D

@export var player_cam : PlayerCam

@export var max_speed := 15
@export var gravity_strength := 40
@export var steering_factor := 20

var target_velocity = Vector3.ZERO


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
