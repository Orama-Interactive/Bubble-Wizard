class_name SceneTransitionRect
extends CanvasLayer

@onready var animation_player: AnimationPlayer = $ColorRect/AnimationPlayer


func _ready() -> void:
	animation_player.play(&"fade_out")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"fade_in":
		GameManager.change_level()


func _on_touch_screen_button_pressed() -> void:
	GameManager.mouse_movement_enabled.emit(false)


func _on_touch_screen_button_released() -> void:
	GameManager.mouse_movement_enabled.emit(true)
