extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_shape_entered(
	_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int
) -> void:
	if body is Player:
		animation_player.play(&"next_level")
		body.can_move = false
		GameManager.current_level_index += 1
		GameManager.start_changing_level()
