extends Node

const CONFIG_PATH := "user://save.cfg"

var levels: Array[PackedScene] = [
	preload("res://src/Levels/level_1.tscn"),
	preload("res://src/Levels/level_2.tscn"),
	preload("res://src/Levels/level_3.tscn"),
	preload("res://src/Levels/level_4.tscn"),
	preload("res://src/Levels/level_5.tscn"),
]
var config_file := ConfigFile.new()
var current_level_index := 0
var variable_height := true

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	config_file.load(CONFIG_PATH)
	TranslationServer.set_locale(OS.get_locale())


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func start_changing_level() -> void:
	var ui_layer := get_tree().current_scene.find_child("UILayer") as UILayer
	ui_layer.animation_player.play(&"fade_in")


func change_level() -> void:
	if current_level_index < levels.size():
		get_tree().change_scene_to_packed(levels[current_level_index])
	else:
		get_tree().change_scene_to_file("res://src/Menu/menu.tscn")
		current_level_index = 0
	save_game(current_level_index)


func restart_level() -> void:
	get_tree().reload_current_scene()


func pause() -> void:
	var scene := get_tree().current_scene
	if get_tree().paused:
		unpause()
		return
	get_tree().paused = true
	var ui_layer := scene.find_child("UILayer") as UILayer
	ui_layer.pause_menu.visible = true
	ui_layer.pause_menu.get_child(1).grab_focus()
	create_tween().tween_property(ui_layer.pause_menu_color_rect, "color", Color(0, 0, 0, 0.4), 0.3)


func unpause() -> void:
	var scene := get_tree().current_scene
	get_tree().paused = false
	var ui_layer := scene.find_child("UILayer") as UILayer
	ui_layer.pause_menu.visible = false
	create_tween().tween_property(ui_layer.pause_menu_color_rect, "color", Color(0, 0, 0, 0), 0.3)


func save_game(level_index: int) -> void:
	config_file.set_value("progress", "level", level_index)
	var max_level: int = config_file.get_value("progress", "max_level", 0)
	if level_index > max_level:
		config_file.set_value("progress", "max_level", level_index)
	config_file.save(CONFIG_PATH)


func load_game() -> int:
	config_file.load(CONFIG_PATH)
	var level_index = config_file.get_value("progress", "level", 0)
	return level_index
