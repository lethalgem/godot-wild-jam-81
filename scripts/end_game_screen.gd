class_name EndGameScreen extends Control

@export var button_sound: AudioStreamPlayer


func show_end_game_screen():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	self.show()

func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")
