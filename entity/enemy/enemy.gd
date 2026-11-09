extends CharacterBody2D

@export var player_ref : CharacterBody2D

func _process(delta: float) -> void:
	velocity = global_position.direction_to(player_ref.global_position) * 10
	move_and_slide()
