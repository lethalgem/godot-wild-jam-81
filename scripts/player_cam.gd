class_name PlayerCam extends Camera3D

@export var camera_rotation_sensitivity := 100
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
	
	
