class_name PlayerCam extends Camera3D

@export var camera_rotation_sensitivity := 250
var camera_invert_on := false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotation.y -= event.relative.x/camera_rotation_sensitivity
		if camera_invert_on:
			rotation.x += event.relative.y/camera_rotation_sensitivity
		else:
			rotation.x -= event.relative.y/camera_rotation_sensitivity
		rotation.x = clamp(rotation.x,deg_to_rad(-90),deg_to_rad(90))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
