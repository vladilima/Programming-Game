extends RefCounted
class_name Interpreter

enum Instruction {
	#region Internal Primitives
	LITERAL,
	SUM,
	SUBTRACT,
	MULTIPLY,
	DIVIDE,
	BUILD_VECTOR,
	#endregion
	#region External Primitives
	GET_CASTER_POSITION,
	GET_CURSOR_POSITION,
	
	TELEPORT_SELF,
	#endregion
}

var bytecode : Array[int] = []
var pointer : int = 0

const MAX_STACK : int = 128
var stack : Array = []
var skip : bool = false

var caster : CharacterBody2D

#region Interpreter Commands
func interpret(debug: bool):
	stack.clear()
	
	pointer = 0
	print('-----------------------')
	for instruction in bytecode:
		if skip: 
			skip = false
			pointer += 1
			continue
		await evaluate(instruction, pointer, debug)
		pointer += 1
		print('Stack:        ', stack)
		print('-----------------------')

func push(value: Variant) -> void:
	assert(stack.size() < MAX_STACK, "Max Stack size reached")
	stack.push_back(value)

func pop() -> Variant:
	assert(stack.size() > 0, "Stack is empty.")
	return stack.pop_back()
#endregion

func evaluate(instruction: Instruction, i: int, debug: bool) -> void:
	if debug:
		debug(instruction)
	
	match instruction:
		#region Internal Primitives
		Instruction.LITERAL:
			assert(bytecode.get(i + 1) != null, 'No number literal found.')
			var value : int = bytecode[i + 1]
			skip = true
			push(value)
		
		Instruction.SUM:
			var value1 = pop()
			var value2 = pop()
			if value1 is Vector2 and !value2 is Vector2:
				push(Vector2(value1.x + value2, value1.y + value2))
			elif value2 is Vector2 and !value1 is Vector2:
				push(Vector2(value2.x + value1, value2.y + value1))
			else:
				push(value1 + value2)
		
		Instruction.SUBTRACT:
			var value2 = pop()
			var value1 = pop()
			if value1 is Vector2 and !value2 is Vector2:
				push(Vector2(value1.x - value2, value1.y - value2))
			elif value2 is Vector2 and !value1 is Vector2:
				push(Vector2(value2.x - value1, value2.y - value1))
			else:
				push(value1 - value2)
		
		Instruction.MULTIPLY:
			var value1 = pop()
			var value2 = pop()
			push(value1 * value2)
		
		Instruction.DIVIDE:
			var value1 = pop()
			var value2 = pop()
			push(value2 / value1)
		
		Instruction.BUILD_VECTOR:
			var value1 = pop()
			var value2 = pop()
			push(Vector2(value2, value1))
		#endregion
		#region External Primitives
		Instruction.GET_CASTER_POSITION:
			push(caster.position)
		
		Instruction.GET_CURSOR_POSITION:
			push(caster.get_global_mouse_position())
			
		Instruction.TELEPORT_SELF:
			caster.position = pop()
		#endregion


func debug(instruction: Instruction) -> void:
	if debug:
		print('Current Step: ', pointer)
		
		if Instruction.find_key(instruction):
			print('Instruction:  ', Instruction.find_key(instruction))
		
		else:
			print('Literal:      ', instruction)
