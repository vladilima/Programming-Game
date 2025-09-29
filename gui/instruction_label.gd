extends Control
class_name InstructionLabel

var text : String
var instruction : int

var is_literal : bool = false
var literal_value : int = 0

func setText(new_text):
	text = new_text
	$HBoxContainer/Label.text = text

func showLiteral():
	is_literal = true
	$HBoxContainer/Literal.visible = true

func _on_spin_box_value_changed(new_value: float) -> void:
	literal_value = new_value
