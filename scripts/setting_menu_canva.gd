class_name MenuCanva extends CanvasLayer

@export var setting_menu : SettingsMenu
var show_menu := false:
	set(new_value):
		if new_value:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			setting_menu.show_menu()
		else:
			setting_menu.dismiss_menu()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		show_menu = new_value

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		show_menu = !show_menu

func _on_setting_menu_back_button_pressed() -> void:
	show_menu = false
