class_name RainParticles extends GPUParticles3D

@export var player: Player3D
@export var rotation_offset := 90.0

func _physics_process(_delta: float) -> void:
	if player != null:
		global_rotation.y = player.player_cam.global_rotation.y - deg_to_rad(rotation_offset)
