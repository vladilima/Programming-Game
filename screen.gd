extends Node2D

var interpreter : Interpreter = Interpreter.new()

func _ready():
	
	interpreter.bytecode = [
		interpreter.Instruction.LITERAL, 8, 
		interpreter.Instruction.LITERAL, 2,
		interpreter.Instruction.DIVIDE]
	interpreter.interpret()
