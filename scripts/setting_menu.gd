class_name SettingsMenu extends Control


@export var button_sound_player: AudioStreamPlayer
@export var fullscreen_button : Button

@onready var dim_rect := $"../PanelContainer"

var is_fullscreen := false

func show_menu():
	self.visible = true
	dim_rect.visible = true

func dismiss_menu():
	self.visible = false
	dim_rect.visible = false
	
func _on_go_back_button_up() -> void:
	self.visible = false
	dim_rect.visible = false
	button_sound_player.play()

func _on_fullscreen_toggle_button_up() -> void:
	is_fullscreen = !is_fullscreen
	
	if is_fullscreen:
		fullscreen_button.text = "Windowed"
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		fullscreen_button.text = "Fullscreen"
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	button_sound_player.play()
