extends Node2D

var interpreter : Interpreter = Interpreter.new()

const INSTRUCTION_LABEL = preload('uid://ci5tnfsih6bil')
const LITERAL_INPUT = preload('uid://63jj373c4rd2')

@onready var InstructionList = $HFlowContainer

func _ready() -> void:
	for instruction in interpreter.Instruction:
		var new_button : Button = Button.new()
		new_button.text = instruction
		new_button.pressed.connect(_onButtonDown.bind(interpreter.Instruction.get(instruction)))
		
		$ButtonList.add_child(new_button)


var bytecode : Array[int] = []
func runBytecode() -> void:
	bytecode.clear()
	for instruction in InstructionList.get_children():
		if instruction is InstructionLabel:
			bytecode.append(interpreter.Instruction.get(instruction.text))
		else:
			bytecode.append(int(instruction.value))
	
	interpreter.bytecode = bytecode
	interpreter.interpret()
	
	$StackOutput.text = str('Stack:\n', str(interpreter.stack))

func _onClearPressed() -> void:
	for instruction in InstructionList.get_children():
		instruction.queue_free()


func _onButtonDown(instruction : int) -> void:
	var new_label = INSTRUCTION_LABEL.instantiate()
	new_label.setText(interpreter.Instruction.find_key(instruction))
	InstructionList.add_child(new_label)
	
	if instruction == interpreter.Instruction.LITERAL:
		var new_literal = LITERAL_INPUT.instantiate()
		InstructionList.add_child(new_literal)
