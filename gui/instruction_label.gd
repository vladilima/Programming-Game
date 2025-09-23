extends PanelContainer
class_name InstructionLabel

var text : String = ''

func setText(new_text):
	text = new_text
	$MarginContainer/Label.text = text
