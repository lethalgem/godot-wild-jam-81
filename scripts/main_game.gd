class_name MainGame extends Node3D

@export var player : Player3D

@export var finish_line_area : Area3D
@export var end_game_screen : EndGameScreen


@onready var player_start_location := player.global_position

func _on_finish_line_area_body_entered(body):
	end_game_screen.show_end_game_screen()
	

func _on_death_area_body_entered(body):
	player.global_position = player_start_location

func _on_end_game_screen_restart_pressed():
	player.global_position = player_start_location
	player.player_cam.battery_life.value = 1000

func _on_battery_pack_battery_replenish():
	player.player_cam.battery_life.value += 400
	player.player_cam.battery_replenish()

func _on_battery_pack_2_battery_replenish():
	player.player_cam.battery_life.value += 400
	player.player_cam.battery_replenish()
