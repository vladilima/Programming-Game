extends Control

var interpreter : Interpreter = Interpreter.new()

const INSTRUCTION_LABEL = preload('uid://ci5tnfsih6bil')

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
	for instruction_label : InstructionLabel in instruction_list.get_children():
		bytecode.append(instruction_label.instruction)
		if instruction_label.is_literal:
			bytecode.append(instruction_label.literal_value)
	
	interpreter.caster = caster
	interpreter.bytecode = bytecode
	interpreter.interpret(true)
	
	$Menu/StackOutput.text = str('Stack:\n', str(interpreter.stack))

func _onClearPressed() -> void:
	for instruction in instruction_list.get_children():
		instruction.queue_free()


func _onButtonDown(instruction : int) -> void:
	var new_label = INSTRUCTION_LABEL.instantiate()
	new_label.instruction = instruction
	new_label.setText(interpreter.Instruction.find_key(instruction))
	instruction_list.add_child(new_label)
	
	if instruction == interpreter.Instruction.LITERAL:
		new_label.showLiteral()
