extends Control

var interpreter : Interpreter = Interpreter.new()

const INSTRUCTION_LABEL = preload('uid://ci5tnfsih6bil')
const LITERAL_INPUT = preload('uid://63jj373c4rd2')

@onready var instruction_list = $Menu/HFlowContainer

@export var caster : CharacterBody2D

func _ready() -> void:
	for instruction : String in interpreter.Instruction.keys():
		var new_button : Button = Button.new()
		new_button.text = instruction.replace('_', ' ')
		new_button.focus_mode = Control.FOCUS_NONE
		new_button.autowrap_mode = TextServer.AUTOWRAP_WORD
		new_button.pressed.connect(_onButtonDown.bind(interpreter.Instruction.get(instruction)))
		
		$Menu/ScrollContainer/ButtonList.add_child(new_button)


var bytecode : Array[int] = []
func runBytecode() -> void:
	bytecode.clear()
	for instruction in instruction_list.get_children():
		if instruction is InstructionLabel:
			bytecode.append(interpreter.Instruction.get(instruction.text))
		else:
			bytecode.append(int(instruction.value))
	
	interpreter.caster = caster
	interpreter.bytecode = bytecode
	interpreter.interpret(true)
	
	$Menu/StackOutput.text = str('Stack:\n', str(interpreter.stack))

func _onClearPressed() -> void:
	for instruction in instruction_list.get_children():
		instruction.queue_free()


func _onButtonDown(instruction : int) -> void:
	var new_label = INSTRUCTION_LABEL.instantiate()
	new_label.setText(interpreter.Instruction.find_key(instruction))
	instruction_list.add_child(new_label)
	
	if instruction == interpreter.Instruction.LITERAL:
		var new_literal = LITERAL_INPUT.instantiate()
		instruction_list.add_child(new_literal)


func _onToggleVisibilityToggled(toggled_on: bool) -> void:
	$Menu.visible = toggled_on
