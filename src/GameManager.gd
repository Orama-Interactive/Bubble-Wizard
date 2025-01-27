extends Node

var levels: Array[PackedScene] = [
	preload("res://src/Levels/level_1.tscn"),
	preload("res://src/Levels/level_2.tscn"),
	preload("res://src/Levels/level_3.tscn"),
	preload("res://src/Levels/level_4.tscn"),
]

var current_level_index := 0
var variable_height := true

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	TranslationServer.set_locale(OS.get_locale())


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)



func start_changing_level() -> void:
	var scene_transition_rect := get_tree().current_scene.find_child("SceneTransitionRect") as SceneTransitionRect
	scene_transition_rect.animation_player.play(&"fade_in")


func change_level() -> void:
	if current_level_index < levels.size():
		get_tree().change_scene_to_packed(levels[current_level_index])
	else:
		get_tree().change_scene_to_file("res://src/Menu/menu.tscn")
		current_level_index = 0


func restart_level() -> void:
	get_tree().reload_current_scene()
