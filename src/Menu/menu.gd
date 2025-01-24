extends Panel


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Levels/level_1.tscn")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Menu/settings.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
