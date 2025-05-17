class_name Battery extends Area3D

signal battery_replenish

func _on_body_entered(body):
	queue_free()
	emit_signal("battery_replenish")
