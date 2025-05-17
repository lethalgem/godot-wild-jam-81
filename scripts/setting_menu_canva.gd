class_name MenuCanva extends CanvasLayer

@export var setting_menu : SettingsMenu
var show_menu := false

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		show_menu = !show_menu
		if show_menu:
			setting_menu.toggle_menu()
		else:
			setting_menu.dismiss_menu()
