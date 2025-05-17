class_name MainGame extends Node3D

@export var player : Player3D

func _on_battery_battery_replenish():
	print(player.player_cam.battery_life.value)
	player.player_cam.battery_life.value += 200
	print(player.player_cam.battery_life.value)
@export var finish_line_area : Area3D
@export var end_game_screen : EndGameScreen


@onready var player_start_location := player.global_position

func _on_finish_line_area_body_entered(body):
	end_game_screen.show_end_game_screen()
	print("winner")

func _on_death_area_body_entered(body):
	player.global_position = player_start_location
	print("RIP")
