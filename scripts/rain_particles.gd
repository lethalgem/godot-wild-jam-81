class_name RainParticles extends Node3D

@export var player: Player3D
@export var rotation_offset := 90.0
@export var distance_offset := 3.0

func _ready() -> void:
	$RainParticles.position.x = -distance_offset

func _physics_process(_delta: float) -> void:
	if player != null:
		global_rotation.y = player.player_cam.global_rotation.y - deg_to_rad(rotation_offset)
