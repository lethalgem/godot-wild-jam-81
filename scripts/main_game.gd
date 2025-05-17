class_name MainGame extends Node3D

@export var player : Player3D
@export var finish_line_area : Area3D
@export var end_game_screen : EndGameScreen


@onready var player_start_location := player.global_position

func _on_finish_line_area_body_entered(body):
	end_game_screen.show_end_game_screen()
	print("winner")

func _on_death_area_body_entered(body):
	player.global_position = player_start_location
	print("RIP")
