extends PanelContainer
class_name LiteralLabel

@export var value = 0

func _on_spin_box_value_changed(new_value: float) -> void:
	value = new_value
