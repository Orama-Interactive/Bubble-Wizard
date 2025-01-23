extends Panel


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Menu/settings.tscn")
