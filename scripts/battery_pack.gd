class_name BatteryPack extends Area3D

signal battery_replenish

func _on_body_entered(_body):
	queue_free()
	emit_signal("battery_replenish")
