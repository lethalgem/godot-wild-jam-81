class_name EndGameScreen extends Control

@export var button_sound: AudioStreamPlayer

signal restart_pressed

func show_end_game_screen():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	self.show()

func _on_restart_button_pressed():
	emit_signal("restart_pressed")
	self.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
