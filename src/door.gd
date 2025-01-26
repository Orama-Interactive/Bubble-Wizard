extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _on_body_shape_entered(
	_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int
) -> void:
	if body is Player:
		animated_sprite_2d.play(&"default")
		body.can_move = false
		GameManager.change_level()
