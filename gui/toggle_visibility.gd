@tool
extends CheckButton

@export var menu : Control

func _on_toggled(toggled_on: bool) -> void:
	menu.visible = button_pressed
