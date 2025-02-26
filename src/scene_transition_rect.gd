class_name UILayer
extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pause_menu: VBoxContainer = $UI/PauseMenu
@onready var pause_menu_color_rect: ColorRect = $PauseMenuColorRect


func _ready() -> void:
	animation_player.play(&"fade_out")
	$TouchScreenJoystick.visible = DisplayServer.is_touchscreen_available()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		GameManager.pause()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"fade_in":
		GameManager.change_level()


func _on_resume_pressed() -> void:
	GameManager.unpause()


func _on_return_to_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/Menu/menu.tscn")
