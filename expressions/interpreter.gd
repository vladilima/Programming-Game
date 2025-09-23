extends RefCounted
class_name Interpreter

enum Instruction {
	LITERAL      = 0x00,
	ADD      = 0x01,
	SUBTRACT      = 0x02,
	MULTIPLY      = 0x03,
	DIVIDE      = 0x04,
}

var bytecode : Array[int] = []
var pointer : int = 0

const MAX_STACK : int = 128
var stack_size : int = 0
var stack : Array[int] = []

func interpret():
	pointer = 0
	print('-----------------------')
	for instruction in bytecode:
		evaluate(instruction, pointer, true)
		pointer += 1
		print('Stack:        ', stack)
		print('-----------------------')
	


func push(value: int) -> void:
	assert(stack_size < MAX_STACK)
	stack_size += 1
	stack.push_back(value)

func pop() -> int:
	assert(stack_size > 0)
	stack_size -= 1
	return stack.pop_back()


func evaluate(instruction: Instruction, i: int, debug: bool) -> void:
	if debug:
		debug(instruction, i)
	
	match instruction:
		Instruction.LITERAL:
			assert(bytecode.get(i + 1) != null, 'No number literal found.')
			var value : int = bytecode.pop_at(i + 1)
			push(value)
		
		Instruction.ADD:
			var value1 = pop()
			var value2 = pop()
			push(value1 + value2)
		
		Instruction.SUBTRACT:
			var value1 = pop()
			var value2 = pop()
			push(value1 - value2)
		
		Instruction.MULTIPLY:
			var value1 = pop()
			var value2 = pop()
			push(value1 * value2)
		
		Instruction.DIVIDE:
			var value1 = pop()
			var value2 = pop()
			push(value2 / value1)


func debug(instruction: Instruction, step: int) -> void:
	if debug:
		print('Current Step: ', step)
		
		if Instruction.find_key(instruction):
			match instruction:
				Instruction.LITERAL:
					print('Instruction:  LITERAL')
				Instruction.ADD:
					print('Instruction:  ADD')
				Instruction.SUBTRACT:
					print('Instruction:  SUBTRACT')
				Instruction.MULTIPLY:
					print('Instruction:  MULTIPLY')
				Instruction.DIVIDE:
					print('Instruction:  DIVIDE')
		
		else:
			print('Literal:      ', instruction)
