class_name AudioSlider extends HSlider

@export var bus_name: String
var bus_index: int

func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	
	if bus_index == -1:
		push_error("Audio bus with name '%s' does not exist." % bus_name)
		return
		
	value = db_to_linear(
		AudioServer.get_bus_volume_db(bus_index)
	)
	
func _on_value_changed(new_value: float) -> void:
	if bus_index == -1:
		push_error("Invalid bus index. Cannot set volume.")
		return
		
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(new_value)
	)
