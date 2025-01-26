extends Node

var levels: Array[PackedScene] = [
	preload("res://src/Levels/level_1.tscn"),
	preload("res://src/Levels/level_2.tscn"),
	preload("res://src/Levels/level_3.tscn"),
	preload("res://src/Levels/level_4.tscn"),
]

var current_level_index := 0


func _ready() -> void:
	TranslationServer.set_locale(OS.get_locale())


func change_level() -> void:
	if current_level_index + 1 < levels.size():
		current_level_index += 1
		get_tree().change_scene_to_packed(levels[current_level_index])
	else:
		get_tree().change_scene_to_file("res://src/Menu/menu.tscn")


func restart_level() -> void:
	get_tree().reload_current_scene()
